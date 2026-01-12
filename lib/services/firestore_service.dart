import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gym_tracker_app/features/health/models/body_weight_model.dart';
import 'package:gym_tracker_app/features/workout/models/workout_exercise_model.dart';
import 'package:gym_tracker_app/features/profile/models/user_model.dart'
    as app_user;
import 'package:gym_tracker_app/features/workout/models/workout_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? get currentUserId => _auth.currentUser?.uid;

  // --- КОРИСТУВАЧ ---

  Future<void> saveUser(app_user.UserModel user) async {
    if (currentUserId == null) return;
    // Не використовуємо await, щоб UI не блокувався в офлайні
    _db
        .collection('users')
        .doc(currentUserId)
        .set(user.toMap(), SetOptions(merge: true))
        .catchError((e) => print("Offline save error (ignore): $e"));
  }

  Future<app_user.UserModel?> getUser() async {
    if (currentUserId == null) return null;
    try {
      // Спочатку пробуємо кеш для миттєвого відображення
      try {
        final doc = await _db
            .collection('users')
            .doc(currentUserId)
            .get(const GetOptions(source: Source.cache));
        if (doc.exists && doc.data() != null) {
          return app_user.UserModel.fromMap(doc.data()!);
        }
      } catch (_) {}

      // Якщо кешу немає або він пустий, пробуємо сервер (з таймаутом)
      final doc = await _db
          .collection('users')
          .doc(currentUserId)
          .get()
          .timeout(const Duration(seconds: 2)); // Швидкий таймаут

      if (doc.exists && doc.data() != null) {
        return app_user.UserModel.fromMap(doc.data()!);
      }
    } catch (e) {
      // Ігноруємо помилки мережі
    }
    return null;
  }

  /// Повне видалення даних користувача (включно з підколекціями)
  Future<void> deleteUserData() async {
    final uid = currentUserId;
    if (uid == null) return;

    try {
      // 1. Видаляємо всі тренування з підколекції 'workouts'
      // Шлях: users/{uid}/workouts/{workoutId}
      final workoutsRef = _db
          .collection('users')
          .doc(uid)
          .collection('workouts');

      await _deleteCollection(workoutsRef);

      // 2. Видаляємо документ самого користувача
      // Шлях: users/{uid}
      await _db.collection('users').doc(uid).delete();

      // Якщо є ще якісь колекції (наприклад, 'history', 'measurements'),
      // додайте їх видалення тут аналогічно до кроку 1.
    } catch (e) {
      debugPrint("Error deleting user data: $e");
      rethrow; // Прокидаємо помилку далі, щоб UI міг її показати
    }
  }

  /// Допоміжний метод для пакетного видалення документів у колекції
  Future<void> _deleteCollection(
    CollectionReference collection, {
    int batchSize = 50,
  }) async {
    while (true) {
      // Беремо пачку документів (ліміт для зменшення навантаження)
      final snapshot = await collection.limit(batchSize).get();

      if (snapshot.docs.isEmpty) {
        break; // Якщо документів немає — ми все видалили
      }

      final batch = _db.batch();
      for (var doc in snapshot.docs) {
        batch.delete(doc.reference);
      }

      // Виконуємо видалення пачки
      await batch.commit();

      // Невелика пауза, щоб не заблокувати потік (опціонально)
      await Future.delayed(const Duration(milliseconds: 10));
    }
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

  // Отримати останнє тренування певного типу (Push, Pull...)
  Future<WorkoutModel?> getLastWorkoutByType(String type) async {
    final uid = currentUserId;
    if (uid == null) return null;

    try {
      final querySnapshot = await _db
          .collection('users')
          .doc(uid)
          .collection('workouts')
          .where('type', isEqualTo: type) // Фільтр по типу
          .orderBy('date', descending: true)
          .limit(1)
          .get();

      if (querySnapshot.docs.isEmpty) return null;

      final doc = querySnapshot.docs.first;
      return WorkoutModel.fromMap(doc.data(), doc.id);
    } catch (e) {
      debugPrint("Error fetching last workout: $e");
      return null;
    }
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
  Future<WorkoutModel?> getWorkout(DateTime date) async {
    if (currentUserId == null) return null;

    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59);

    try {
      // Спроба з кешу
      var query = await _db
          .collection('users')
          .doc(currentUserId)
          .collection('workouts')
          .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
          .where('date', isLessThanOrEqualTo: Timestamp.fromDate(endOfDay))
          .get(const GetOptions(source: Source.cache));

      if (query.docs.isNotEmpty) {
        final data = query.docs.first.data();
        return WorkoutModel.fromMap(data, query.docs.first.id);
      }

      // Спроба з сервера
      query = await _db
          .collection('users')
          .doc(currentUserId)
          .collection('workouts')
          .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
          .where('date', isLessThanOrEqualTo: Timestamp.fromDate(endOfDay))
          .get()
          .timeout(const Duration(seconds: 1));

      if (query.docs.isNotEmpty) {
        final data = query.docs.first.data();
        return WorkoutModel.fromMap(data, query.docs.first.id);
      }
    } catch (_) {}
    return null;
  }

  // Зберегти вагу
  Future<void> saveBodyWeight(BodyWeightModel model) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    // Використовуємо дату як ID, щоб був один запис на день
    final docId = model.date.toIso8601String().split('T').first;

    await _db
        .collection('users')
        .doc(uid)
        .collection('body_weights')
        .doc(docId)
        .set(model.toMap());
  }

  // Отримати історію ваги
  Stream<List<BodyWeightModel>> getBodyWeightHistory() {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return const Stream.empty();

    return _db
        .collection('users')
        .doc(uid)
        .collection('body_weights')
        .orderBy(
          'date',
          descending: false,
        ) // Для графіка потрібно від старого до нового
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => BodyWeightModel.fromMap(doc.id, doc.data()))
              .toList();
        });
  }
}
