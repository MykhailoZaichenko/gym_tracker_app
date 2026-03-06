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
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    await _db
        .collection('users')
        .doc(uid)
        .set(user.toMap(), SetOptions(merge: true));
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
          return app_user.UserModel.fromMap(doc.data()!, doc.id);
        }
      } catch (_) {}

      // Якщо кешу немає або він пустий, пробуємо сервер (з таймаутом)
      final doc = await _db
          .collection('users')
          .doc(currentUserId)
          .get()
          .timeout(const Duration(seconds: 2)); // Швидкий таймаут

      if (doc.exists && doc.data() != null) {
        return app_user.UserModel.fromMap(doc.data()!, doc.id);
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

  // --- ЗБЕРЕЖЕННЯ ТА ІСТОРІЯ ВАГИ ---

  Future<void> saveBodyWeight(BodyWeightModel model) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    final collection = _db
        .collection('users')
        .doc(uid)
        .collection('body_weight');

    // Якщо це редагування існуючого запису (є ID)
    if (model.id.isNotEmpty) {
      await collection.doc(model.id).set(model.toMap());
    } else {
      // Якщо це новий запис
      await collection.add(model.toMap());
    }
  }

  Stream<List<BodyWeightModel>> getBodyWeightHistory() {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return const Stream.empty();

    return _db
        .collection('users')
        .doc(uid)
        .collection('body_weight')
        .orderBy(
          'date',
          descending: false,
        ) // Обов'язково сортуємо за датою для графіка
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            final data = doc.data();
            // Якщо ваш fromMap приймає тільки data:
            data['id'] = doc.id;
            return BodyWeightModel.fromMap(doc.id, doc.data());

            // ПРИМІТКА: Якщо ваш BodyWeightModel.fromMap вимагає 2 аргументи (data, id),
            // тоді розкоментуйте нижній рядок і видаліть верхні:
            // return BodyWeightModel.fromMap(data, doc.id);
          }).toList();
        });
  }

  // 🔥 1. Отримання актуальної ваги ДРУГА
  Future<double?> getFriendLatestWeight(String friendId) async {
    try {
      // Пробуємо отримати останню вагу
      var snapshot = await _db
          .collection('users')
          .doc(friendId)
          .collection('body_weight')
          .orderBy('date', descending: true)
          .limit(1)
          .get();

      // Якщо пусто (можливо, Firebase не може відсортувати через відсутність поля date)
      if (snapshot.docs.isEmpty) {
        snapshot = await _db
            .collection('users')
            .doc(friendId)
            .collection('body_weight')
            .limit(1)
            .get();
      }

      if (snapshot.docs.isNotEmpty) {
        return (snapshot.docs.first.data()['weight'] as num?)?.toDouble();
      }
      return null;
    } catch (e) {
      debugPrint("Помилка отримання ваги друга: $e");
      return null;
    }
  }

  // 🔥 2. Отримання всіх тренувань ДРУГА (щоб порахувати рекорди і статистику)
  Future<List<Map<String, dynamic>>> getFriendWorkoutsList(
    String friendId,
  ) async {
    try {
      final snapshot = await _db
          .collection('users')
          .doc(friendId)
          .collection('workouts')
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['docId'] = doc.id; // Зберігаємо ID документа на всякий випадок
        return data;
      }).toList();
    } catch (e) {
      debugPrint("Помилка отримання тренувань друга: $e");
      return [];
    }
  }

  Future<void> updateWeeklyGoal(int newGoal) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    await _db.collection('users').doc(uid).update({'weeklyGoal': newGoal});
  }

  // --- СОЦІАЛЬНІ ФУНКЦІЇ ---

  // Забронювати нікнейм за поточним користувачем
  // 🔥 НОВИЙ МЕТОД: Перевіряє тільки існування документа, не парсячи його
  Future<bool> isUsernameAvailable(String username) async {
    try {
      final queryText = username.trim().toLowerCase();
      final snapshot = await _db
          .collection('users')
          .where('name', isEqualTo: queryText)
          .limit(1)
          .get();

      // Якщо документів 0 — нік 100% вільний
      if (snapshot.docs.isEmpty) return true;

      // Якщо документ є, перевіряємо, чи це не наш власний акаунт
      // (на випадок, якщо ми просто перезберігаємо своє ім'я)
      final ownerId = snapshot.docs.first.id;
      if (ownerId == _auth.currentUser?.uid) {
        return true;
      }

      // Якщо власник інший — нік зайнятий
      return false;
    } catch (e) {
      debugPrint("Помилка перевірки нікнейму: $e");
      // Якщо сталася помилка доступу, для безпеки кажемо, що зайнято
      return false;
    }
  }

  // Тепер використовує безпечну перевірку
  Future<bool> claimUsername(String username) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return false;

    try {
      final lowerCaseName = username.trim().toLowerCase();

      // Використовуємо новий надійний метод
      final available = await isUsernameAvailable(lowerCaseName);
      if (!available) {
        return false;
      }

      await _db.collection('users').doc(uid).update({'name': lowerCaseName});

      return true;
    } catch (e) {
      debugPrint("Помилка збереження нікнейму: $e");
      return false;
    }
  }

  // Знайти користувача за Email (для додавання)
  Future<app_user.UserModel?> findUserByEmail(String email) async {
    final snapshot = await _db
        .collection('users')
        .where('email', isEqualTo: email)
        .limit(1)
        .get();

    if (snapshot.docs.isEmpty) return null;
    return app_user.UserModel.fromMap(
      snapshot.docs.first.data(),
      snapshot.docs.first.id,
    );
  }

  // Живий пошук по email або @username
  // Живий пошук по email або @username (без поточних друзів)
  Future<List<app_user.UserModel>> searchUsersLive(String queryText) async {
    String query = queryText.trim().toLowerCase();
    if (query.isEmpty) return [];

    try {
      final currentUid = _auth.currentUser?.uid;
      if (currentUid == null) return [];

      final currentUserDoc = await _db
          .collection('users')
          .doc(currentUid)
          .get();
      final List<dynamic> myFriends = currentUserDoc.data()?['friends'] ?? [];

      QuerySnapshot<Map<String, dynamic>> snapshot;

      if (query.startsWith('@')) {
        final usernameQuery = query.substring(1).toLowerCase();
        if (usernameQuery.isEmpty) return [];

        snapshot = await _db
            .collection('users')
            .where(
              'name',
              isGreaterThanOrEqualTo: usernameQuery,
            ) // Шукаємо по name
            .where('name', isLessThanOrEqualTo: '$usernameQuery\uf8ff')
            .limit(10)
            .get();
      } else {
        snapshot = await _db
            .collection('users')
            .where('email', isGreaterThanOrEqualTo: query)
            .where('email', isLessThanOrEqualTo: '$query\uf8ff')
            .limit(10)
            .get();
      }

      return snapshot.docs
          .map((doc) => app_user.UserModel.fromMap(doc.data(), doc.id))
          .where((u) => u.id != currentUid && !myFriends.contains(u.id))
          .toList();
    } catch (e) {
      print("Помилка живого пошуку: $e");
      return [];
    }
  }

  // Знайти користувача за нікнеймом
  Future<app_user.UserModel?> findUserByUsername(String username) async {
    try {
      final queryText = username.trim().toLowerCase();
      final snapshot = await _db
          .collection('users')
          .where('nameLowerCase', isEqualTo: queryText)
          .limit(1)
          .get();

      if (snapshot.docs.isEmpty) return null;
      return app_user.UserModel.fromMap(
        snapshot.docs.first.data(),
        snapshot.docs.first.id,
      );
    } catch (e) {
      debugPrint("Помилка пошуку за ніком: $e");
      return null;
    }
  }

  // Генерація посилання на дружбу
  String generateFriendLink() {
    final uid = currentUserId;
    if (uid == null) return "";
    // Формат лінка, який перехоплюватиметься додатком через Deep Links
    return "https://gymtracker.app/addfriend?uid=$uid";
  }

  // 2. Відправити запит у друзі
  // Відправити запит у друзі (зберігаємо нікнейм)
  Future<void> sendFriendRequest(String friendUid) async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) return;

    // Отримуємо наші актуальні дані, щоб передати нікнейм
    final myDoc = await _db.collection('users').doc(currentUser.uid).get();
    final myName =
        myDoc.data()?['name'] ??
        currentUser.email?.split('@')[0] ??
        'Користувач';

    await _db
        .collection('users')
        .doc(friendUid)
        .collection('friend_requests')
        .doc(currentUser.uid)
        .set({
          'fromUid': currentUser.uid,
          'fromEmail': currentUser.email,
          'fromName': myName,
          'timestamp': FieldValue.serverTimestamp(),
          'status': 'pending',
        });
  }

  // Отримати список вхідних запитів
  Stream<List<Map<String, dynamic>>> getFriendRequests() {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return const Stream.empty();

    return _db
        .collection('users')
        .doc(uid)
        .collection('friend_requests')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  }

  // Прийняти дружбу
  Future<void> acceptFriendRequest(String friendUid) async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) return;

    final batch = _db.batch();

    final myDocRef = _db.collection('users').doc(currentUser.uid);
    batch.update(myDocRef, {
      'friends': FieldValue.arrayUnion([friendUid]),
    });

    final friendDocRef = _db.collection('users').doc(friendUid);
    batch.update(friendDocRef, {
      'friends': FieldValue.arrayUnion([currentUser.uid]),
    });

    final requestDocRef = _db
        .collection('users')
        .doc(currentUser.uid)
        .collection('friend_requests')
        .doc(friendUid);

    batch.delete(requestDocRef);

    await batch.commit();
  }

  // 5. Отримати список друзів (Повертає стрім об'єктів UserModel)
  Stream<List<app_user.UserModel>> getFriendsStream() {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return const Stream.empty();

    return _db.collection('users').doc(uid).snapshots().asyncMap((
      userDoc,
    ) async {
      final data = userDoc.data();
      if (data == null || !data.containsKey('friends')) return [];

      final List<dynamic> friendIds = data['friends'];
      if (friendIds.isEmpty) return [];

      // Отримуємо актуальні дані кожного друга (щоб бачити свіжий стрік)
      // (Для >10 друзів треба розбивати на пачки по 10 для whereIn, але поки так)
      final friendsSnapshot = await _db
          .collection('users')
          .where(FieldPath.documentId, whereIn: friendIds.take(10).toList())
          .get();

      return friendsSnapshot.docs
          .map((doc) => app_user.UserModel.fromMap(doc.data(), doc.id))
          .toList();
    });
  }

  // ОНОВЛЕННЯ СТАТИСТИКИ (Викликати після завершення тренування)
  Future<void> updateUserStats() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    // 1. Отримуємо ціль користувача на тиждень
    final userDoc = await _db.collection('users').doc(uid).get();
    final userData = userDoc.data();
    if (userData == null) return;

    final int weeklyGoal = (userData['weeklyGoal'] as num?)?.toInt() ?? 0;

    // Отримуємо всі тренування
    final workouts = await getAllWorkouts();

    // 2. Рахуємо тижневий стрік
    int streak = 0;
    if (workouts.isNotEmpty && weeklyGoal > 0) {
      final dates = workouts.keys
          .map((dateStr) => DateTime.parse(dateStr))
          .toList();
      final Map<String, int> workoutsPerWeek = {};

      // Групуємо кількість тренувань по понеділках кожного тижня
      for (var date in dates) {
        final startOfWeek = date.subtract(Duration(days: date.weekday - 1));
        final key =
            "${startOfWeek.year}-${startOfWeek.month}-${startOfWeek.day}";
        workoutsPerWeek[key] = (workoutsPerWeek[key] ?? 0) + 1;
      }

      final now = DateTime.now();
      final currentMonday = now.subtract(Duration(days: now.weekday - 1));

      // Перевіряємо поточний тиждень
      final currentKey =
          "${currentMonday.year}-${currentMonday.month}-${currentMonday.day}";
      if ((workoutsPerWeek[currentKey] ?? 0) >= weeklyGoal) {
        streak++;
      }

      // Рухаємось назад по минулих тижнях
      DateTime checkMonday = currentMonday.subtract(const Duration(days: 7));
      while (true) {
        final key =
            "${checkMonday.year}-${checkMonday.month}-${checkMonday.day}";
        if ((workoutsPerWeek[key] ?? 0) >= weeklyGoal) {
          streak++;
          checkMonday = checkMonday.subtract(const Duration(days: 7));
        } else {
          break; // Стрік перервався
        }
      }
    }

    // 3. Рахуємо кращі ваги за поточний місяць
    final nowTime = DateTime.now();
    final startOfMonth = DateTime(nowTime.year, nowTime.month, 1);

    Map<String, double> monthlyMaxes = {};
    int workoutsThisMonth = 0; // 🔥 Нова змінна для кількості тренувань

    workouts.forEach((dateStr, exercises) {
      final date = DateTime.parse(dateStr);
      if (date.isAfter(startOfMonth) || date.isAtSameMomentAs(startOfMonth)) {
        workoutsThisMonth++; // 🔥 Додаємо +1 тренування за цей місяць

        for (var ex in exercises) {
          double maxInEx = 0;
          for (var s in ex.sets) {
            if ((s.weight ?? 0) > maxInEx) maxInEx = s.weight!;
          }

          if (maxInEx > (monthlyMaxes[ex.name] ?? 0)) {
            monthlyMaxes[ex.name] = maxInEx;
          }
        }
      }
    });

    // 4. Зберігаємо оновлені дані в профіль, щоб їх бачили друзі
    await _db.collection('users').doc(uid).update({
      'currentStreak': streak,
      'monthlyBestWeights': monthlyMaxes,
      'lastWorkoutDate': DateTime.now().toIso8601String(),
      'workoutsThisMonth': workoutsThisMonth, // 🔥 Зберігаємо нову статистику
    });
  }

  // Видалення з друзів (взаємне)
  Future<void> removeFriend(String friendUid) async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) return;

    final batch = _db.batch();

    // 1. Видаляємо ID друга з МОГО масиву friends
    final myDocRef = _db.collection('users').doc(currentUser.uid);
    batch.update(myDocRef, {
      'friends': FieldValue.arrayRemove([friendUid]),
    });

    // 2. Видаляємо МІЙ ID з масиву friends ДРУГА
    final friendDocRef = _db.collection('users').doc(friendUid);
    batch.update(friendDocRef, {
      'friends': FieldValue.arrayRemove([currentUser.uid]),
    });

    // Виконуємо транзакцію
    await batch.commit();
  }
}
