import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gym_tracker_app/features/workout/models/workout_exercise_model.dart';
import 'package:gym_tracker_app/features/profile/models/user_model.dart'
    as app_user;
import 'package:gym_tracker_app/features/workout/models/workout_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? get currentUserId => _auth.currentUser?.uid;

  // --- КОРИСТУВАЧ ---

  Future<void> saveUser(app_user.User user) async {
    if (currentUserId == null) return;
    // Не використовуємо await, щоб UI не блокувався в офлайні
    _db
        .collection('users')
        .doc(currentUserId)
        .set(user.toMap(), SetOptions(merge: true))
        .catchError((e) => print("Offline save error (ignore): $e"));
  }

  Future<app_user.User?> getUser() async {
    if (currentUserId == null) return null;
    try {
      // Спочатку пробуємо кеш для миттєвого відображення
      try {
        final doc = await _db
            .collection('users')
            .doc(currentUserId)
            .get(const GetOptions(source: Source.cache));
        if (doc.exists && doc.data() != null) {
          return app_user.User.fromMap(doc.data()!);
        }
      } catch (_) {}

      // Якщо кешу немає або він пустий, пробуємо сервер (з таймаутом)
      final doc = await _db
          .collection('users')
          .doc(currentUserId)
          .get()
          .timeout(const Duration(seconds: 2)); // Швидкий таймаут

      if (doc.exists && doc.data() != null) {
        return app_user.User.fromMap(doc.data()!);
      }
    } catch (e) {
      // Ігноруємо помилки мережі
    }
    return null;
  }

  // --- ТРЕНУВАННЯ ---

  Future<void> saveWorkout(WorkoutModel workout) async {
    if (currentUserId == null) return;

    // Fire-and-forget: Запускаємо запис, але не чекаємо відповіді сервера
    // Це дозволяє UI миттєво реагувати (закрити вікно), а Firestore синхронізує дані фоном.
    _db
        .collection('users')
        .doc(currentUserId)
        .collection('workouts')
        .doc(workout.id)
        .set(workout.toMap(), SetOptions(merge: true));
  }

  // Стрім для миттєвого відображення (вже у вас є, залишаємо)
  Stream<Map<String, List<WorkoutExercise>>> getAllWorkoutsStream() {
    if (currentUserId == null) return Stream.value({});

    return _db
        .collection('users')
        .doc(currentUserId)
        .collection('workouts')
        .snapshots(includeMetadataChanges: true) // Враховуємо локальні зміни
        .map((snapshot) {
          final Map<String, List<WorkoutExercise>> result = {};
          for (var doc in snapshot.docs) {
            try {
              final workout = WorkoutModel.fromMap(doc.data(), doc.id);
              final dateKey = workout.date.toIso8601String().split('T').first;
              if (result.containsKey(dateKey)) {
                result[dateKey]!.addAll(workout.exercises);
              } else {
                result[dateKey] = List.from(workout.exercises);
              }
            } catch (_) {}
          }
          return result;
        });
  }

  // Для профілю, щоб отримати статистику (один раз)
  Future<Map<String, List<WorkoutExercise>>> getAllWorkouts() async {
    if (currentUserId == null) return {};

    // Беремо дані зі стріма (перший snapshot), це найнадійніший спосіб отримати кеш+сервер
    try {
      final snapshot = await _db
          .collection('users')
          .doc(currentUserId)
          .collection('workouts')
          .get(const GetOptions(source: Source.cache)); // Пріоритет кешу

      final Map<String, List<WorkoutExercise>> result = {};
      for (var doc in snapshot.docs) {
        final workout = WorkoutModel.fromMap(doc.data(), doc.id);
        final dateKey = workout.date.toIso8601String().split('T').first;
        result[dateKey] = workout.exercises;
      }
      return result;
    } catch (_) {
      return {};
    }
  }

  // Отримання конкретного тренування
  Future<List<WorkoutExercise>> getWorkout(DateTime date) async {
    if (currentUserId == null) return [];

    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59);

    try {
      // ТІЛЬКИ КЕШ або СТРІМ. Get() з сервера буде висіти.
      final query = await _db
          .collection('users')
          .doc(currentUserId)
          .collection('workouts')
          .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
          .where('date', isLessThanOrEqualTo: Timestamp.fromDate(endOfDay))
          .get(const GetOptions(source: Source.cache)); // <--- Ключова зміна

      if (query.docs.isNotEmpty) {
        final data = query.docs.first.data();
        final model = WorkoutModel.fromMap(data, query.docs.first.id);
        return model.exercises;
      } else {
        // Якщо в кеші пусто, можна спробувати сервер з малим таймаутом
        try {
          final serverQuery = await _db
              .collection('users')
              .doc(currentUserId)
              .collection('workouts')
              .where(
                'date',
                isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay),
              )
              .where('date', isLessThanOrEqualTo: Timestamp.fromDate(endOfDay))
              .get()
              .timeout(const Duration(seconds: 1)); // 1 сек

          if (serverQuery.docs.isNotEmpty) {
            final data = serverQuery.docs.first.data();
            final model = WorkoutModel.fromMap(data, serverQuery.docs.first.id);
            return model.exercises;
          }
        } catch (_) {}
      }
    } catch (_) {}
    return [];
  }

  // --- ТИЖНЕВИЙ ПЛАН ---

  Future<void> saveWeeklyPlan(Map<String, List<String>> plan) async {
    if (currentUserId == null) return;
    // Fire-and-forget
    _db
        .collection('users')
        .doc(currentUserId)
        .collection('settings')
        .doc('weekly_plan')
        .set(plan);
  }

  Future<Map<String, List<String>>> getWeeklyPlan() async {
    if (currentUserId == null) return {};
    try {
      // Пріоритет кешу
      final doc = await _db
          .collection('users')
          .doc(currentUserId)
          .collection('settings')
          .doc('weekly_plan')
          .get(const GetOptions(source: Source.cache));

      if (doc.exists && doc.data() != null) {
        final data = doc.data()!;
        final Map<String, List<String>> typedPlan = {};
        data.forEach((key, value) {
          typedPlan[key] = List<String>.from(value);
        });
        return typedPlan;
      }
    } catch (_) {}
    return {};
  }
}
