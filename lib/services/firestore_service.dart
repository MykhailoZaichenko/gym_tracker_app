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

  Future<void> saveUser(app_user.User user) async {
    if (currentUserId == null) return;
    await _db
        .collection('users')
        .doc(currentUserId)
        .set(user.toMap(), SetOptions(merge: true));
  }

  Future<app_user.User?> getUser() async {
    if (currentUserId == null) return null;
    // Спроба отримати з кешу, якщо сервер недоступний
    try {
      final doc = await _db.collection('users').doc(currentUserId).get();
      if (doc.exists && doc.data() != null) {
        return app_user.User.fromMap(doc.data()!);
      }
    } catch (_) {
      // Fallback на кеш при помилці мережі
      try {
        final doc = await _db
            .collection('users')
            .doc(currentUserId)
            .get(const GetOptions(source: Source.cache));
        if (doc.exists && doc.data() != null) {
          return app_user.User.fromMap(doc.data()!);
        }
      } catch (_) {}
    }
    return null;
  }

  // --- ТРЕНУВАННЯ ---

  Future<void> saveWorkout(WorkoutModel workout) async {
    if (currentUserId == null) return;

    // Зберігаємо. Завдяки persistenceEnabled: true, це запишеться в кеш миттєво, а в хмару полетить, коли буде інтернет.
    await _db
        .collection('users')
        .doc(currentUserId)
        .collection('workouts')
        .doc(workout.id)
        .set(workout.toMap(), SetOptions(merge: true));
  }

  Future<List<WorkoutExercise>> getWorkout(DateTime date) async {
    if (currentUserId == null) return [];
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59);

    try {
      // Спочатку пробуємо кеш, щоб було швидко
      var query = await _queryWorkouts(startOfDay, endOfDay, Source.cache);
      if (query.docs.isEmpty) {
        // Якщо в кеші пусто, пробуємо сервер
        query = await _queryWorkouts(
          startOfDay,
          endOfDay,
          Source.serverAndCache,
        );
      }

      if (query.docs.isNotEmpty) {
        // Беремо перше тренування за день (або можна об'єднати всі)
        final data = query.docs.first.data();
        final model = WorkoutModel.fromMap(data, query.docs.first.id);
        return model.exercises;
      }
    } catch (e) {
      print('Error getting workout: $e');
    }
    return [];
  }

  Future<QuerySnapshot<Map<String, dynamic>>> _queryWorkouts(
    DateTime start,
    DateTime end,
    Source source,
  ) {
    return _db
        .collection('users')
        .doc(currentUserId)
        .collection('workouts')
        .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(start))
        .where('date', isLessThanOrEqualTo: Timestamp.fromDate(end))
        .get(GetOptions(source: source));
  }

  Stream<Map<String, List<WorkoutExercise>>> getAllWorkoutsStream() {
    if (currentUserId == null) return Stream.value({});

    return _db
        .collection('users')
        .doc(currentUserId)
        .collection('workouts')
        .snapshots() // <--- Слухаємо зміни в реальному часі
        .map((snapshot) {
          final Map<String, List<WorkoutExercise>> result = {};

          for (var doc in snapshot.docs) {
            try {
              final workout = WorkoutModel.fromMap(doc.data(), doc.id);
              final dateKey = workout.date.toIso8601String().split('T').first;

              if (result.containsKey(dateKey)) {
                result[dateKey]!.addAll(workout.exercises);
              } else {
                result[dateKey] = workout.exercises;
              }
            } catch (e) {
              print("Error parsing workout ${doc.id}: $e");
            }
          }
          return result;
        });
  }

  Future<Map<String, List<WorkoutExercise>>> getAllWorkouts() async {
    try {
      final snapshot = await _db
          .collection('users')
          .doc(currentUserId)
          .collection('workouts')
          .get(
            const GetOptions(source: Source.cache),
          ); // Спробувати спочатку кеш?
      // Або просто .get() - SDK саме вирішить.

      // ... логіка парсингу (така ж як в Stream)
      final Map<String, List<WorkoutExercise>> result = {};
      for (var doc in snapshot.docs) {
        final workout = WorkoutModel.fromMap(doc.data(), doc.id);
        final dateKey = workout.date.toIso8601String().split('T').first;
        result[dateKey] = workout.exercises;
      }
      return result;
    } catch (e) {
      // Якщо помилка (наприклад, перший запуск без нету), повертаємо пусте
      return {};
    }
  }

  // --- ТИЖНЕВИЙ ПЛАН (залишаємо як є) ---

  Future<Map<String, List<String>>> getWeeklyPlan() async {
    if (currentUserId == null) return {};

    try {
      // Пробуємо кеш
      var doc = await _db
          .collection('users')
          .doc(currentUserId)
          .collection('settings')
          .doc('weekly_plan')
          .get(const GetOptions(source: Source.cache));
      if (!doc.exists) {
        doc = await _db
            .collection('users')
            .doc(currentUserId)
            .collection('settings')
            .doc('weekly_plan')
            .get();
      }

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

  Future<void> saveWeeklyPlan(Map<String, List<String>> plan) async {
    if (currentUserId == null) return;
    await _db
        .collection('users')
        .doc(currentUserId)
        .collection('settings')
        .doc('weekly_plan')
        .set(plan);
  }
}
