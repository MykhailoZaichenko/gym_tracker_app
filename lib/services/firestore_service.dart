import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gym_tracker_app/features/workout/models/workout_exercise_model.dart';
import 'package:gym_tracker_app/features/profile/models/user_model.dart'
    as app_user;

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Отримуємо ID поточного юзера. Якщо юзера немає — повертаємо null.
  String? get currentUserId => _auth.currentUser?.uid;

  // --- КОРИСТУВАЧ ---

  // Збереження даних профілю (вага, ім'я)
  Future<void> saveUser(app_user.User user) async {
    if (currentUserId == null) return;
    // Зберігаємо в колекцію 'users', документ називаємо ID юзера
    await _db
        .collection('users')
        .doc(currentUserId)
        .set(user.toMap(), SetOptions(merge: true));
  }

  // Отримання профілю
  Future<app_user.User?> getUser() async {
    if (currentUserId == null) return null;
    final doc = await _db.collection('users').doc(currentUserId).get();
    if (doc.exists && doc.data() != null) {
      return app_user.User.fromMap(doc.data()!);
    }
    return null;
  }

  // --- ТРЕНУВАННЯ ---

  // Збереження конкретного тренування
  // Шлях: users -> {userId} -> workouts -> {дата}
  Future<void> saveWorkout(
    DateTime date,
    List<WorkoutExercise> exercises,
  ) async {
    if (currentUserId == null) return;

    // Використовуємо дату як ключ документа (2025-11-27)
    final dateKey = date.toIso8601String().split('T').first;
    final exercisesMap = exercises.map((e) => e.toMap()).toList();

    await _db
        .collection('users')
        .doc(currentUserId)
        .collection('workouts')
        .doc(dateKey)
        .set({'exercises': exercisesMap});
  }

  // Отримання тренування за дату
  Future<List<WorkoutExercise>> getWorkout(DateTime date) async {
    if (currentUserId == null) return [];
    final dateKey = date.toIso8601String().split('T').first;

    final doc = await _db
        .collection('users')
        .doc(currentUserId)
        .collection('workouts')
        .doc(dateKey)
        .get();

    if (doc.exists && doc.data() != null) {
      final data = doc.data()!;
      final list = data['exercises'] as List<dynamic>;
      return list.map((e) => WorkoutExercise.fromMap(e)).toList();
    }
    return [];
  }

  // Отримання ВСІХ тренувань (для календаря та графіків)
  Future<Map<String, List<WorkoutExercise>>> getAllWorkouts() async {
    if (currentUserId == null) return {};

    final snapshot = await _db
        .collection('users')
        .doc(currentUserId)
        .collection('workouts')
        .get();

    final Map<String, List<WorkoutExercise>> result = {};

    for (var doc in snapshot.docs) {
      final dateKey = doc.id;
      final list = doc.data()['exercises'] as List<dynamic>;
      final exercises = list.map((e) => WorkoutExercise.fromMap(e)).toList();
      result[dateKey] = exercises;
    }
    return result;
  }

  // --- ТИЖНЕВИЙ ПЛАН ---

  Future<void> saveWeeklyPlan(Map<String, List<String>> plan) async {
    if (currentUserId == null) return;
    await _db
        .collection('users')
        .doc(currentUserId)
        .collection('settings') // Окрема підколекція для налаштувань
        .doc('weekly_plan')
        .set(plan);
  }

  Future<Map<String, List<String>>> getWeeklyPlan() async {
    if (currentUserId == null) return {};

    final doc = await _db
        .collection('users')
        .doc(currentUserId)
        .collection('settings')
        .doc('weekly_plan')
        .get();

    if (doc.exists && doc.data() != null) {
      final data = doc.data()!;
      final Map<String, List<String>> typedPlan = {};
      // Конвертуємо динамічні дані в типізовану мапу
      data.forEach((key, value) {
        typedPlan[key] = List<String>.from(value);
      });
      return typedPlan;
    }
    return {};
  }
}
