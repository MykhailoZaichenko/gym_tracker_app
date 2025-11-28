import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:gym_tracker_app/services/firestore_service.dart';
import 'package:gym_tracker_app/features/profile/models/user_model.dart'
    as app_user;

class AuthService {
  final firebase_auth.FirebaseAuth _firebaseAuth =
      firebase_auth.FirebaseAuth.instance;
  final FirestoreService _firestoreService = FirestoreService();

  // Потік змін стану авторизації (вхід/вихід)
  Stream<app_user.User?> get authStateChanges {
    return _firebaseAuth.authStateChanges().asyncMap((firebaseUser) async {
      if (firebaseUser == null) return null;
      // Якщо є Firebase-юзер, завантажуємо наш профіль з Firestore
      return await _firestoreService.getUser();
    });
  }

  // Реєстрація (тепер повертає User, як і раніше)
  Future<app_user.User> register({
    required String email,
    required String name,
    required String password,
  }) async {
    try {
      // 1. Створюємо юзера в Firebase Auth
      final cred = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (cred.user == null) {
        throw Exception('Не вдалося створити користувача');
      }

      // 2. Створюємо нашу модель User (без хешів і солі, бо Firebase це робить сам)
      // Ми можемо зберегти ID з Firebase або залишити його null, якщо він не потрібен локально
      final newUser = app_user.User(
        id: null, // ID тепер в документі Firestore, тут може бути null або int (якщо переробити модель)
        email: email,
        name: name,
        passwordHash: '', // Більше не потрібно
        salt: '', // Більше не потрібно
        avatarUrl: null,
        weightKg: null,
      );

      // 3. Зберігаємо профіль у Firestore
      await _firestoreService.saveUser(newUser);

      return newUser;
    } on firebase_auth.FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        throw Exception('Користувач з таким email вже існує');
      }
      throw Exception(e.message ?? 'Помилка реєстрації');
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  // Автентифікація (повертає User? або null)
  Future<app_user.User?> login({
    required String email,
    required String password,
  }) async {
    try {
      // 1. Логінимось через Firebase
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // 2. Завантажуємо дані профілю з Firestore
      final user = await _firestoreService.getUser();
      return user;
    } on firebase_auth.FirebaseAuthException catch (_) {
      // Якщо логін не вдався (невірний пароль/email), повертаємо null, як у старому коді
      return null;
    } catch (e) {
      // Для інших помилок теж можна повернути null або кинути Exception
      return null;
    }
  }

  // Отримати поточного користувача (адаптація старого методу)
  // Раніше ми передавали ID, тепер ми просто беремо поточного залогіненого
  Future<app_user.User?> getUser(int? id) async {
    // Ігноруємо ID, бо в Firebase ми завжди беремо поточного
    return _firestoreService.getUser();
  }

  // Оновити профіль
  Future<void> updateProfile(app_user.User user) async {
    await _firestoreService.saveUser(user);
  }

  // Змінити пароль
  // У Firebase зміна пароля вимагає, щоб користувач був залогінений нещодавно.
  Future<void> changePassword(int? userId, String newPassword) async {
    final user = _firebaseAuth.currentUser;
    if (user == null) throw Exception('Користувач не авторизований');

    try {
      await user.updatePassword(newPassword);
    } on firebase_auth.FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        throw Exception('Для зміни пароля потрібно зайти в акаунт заново');
      }
      throw Exception(e.message ?? 'Не вдалося змінити пароль');
    }
  }

  // Вихід
  Future<void> logout() async {
    await _firebaseAuth.signOut();
  }

  // Скидання паролю (додаткова фіча, якої не було, але вона корисна)
  Future<void> resetPassword(String email) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }
}
