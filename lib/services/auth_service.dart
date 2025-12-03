import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:gym_tracker_app/services/firestore_service.dart';
import 'package:gym_tracker_app/features/profile/models/user_model.dart'
    as app_user;

class AuthService {
  final firebase_auth.FirebaseAuth _firebaseAuth =
      firebase_auth.FirebaseAuth.instance;
  final FirestoreService _firestoreService = FirestoreService();
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Потік змін стану авторизації (вхід/вихід)
  Stream<app_user.User?> get authStateChanges {
    return _firebaseAuth.authStateChanges().asyncMap((firebaseUser) async {
      if (firebaseUser == null) return null;
      // Якщо є Firebase-юзер, завантажуємо наш профіль з Firestore
      return await _firestoreService.getUser();
    });
  }

  Future<void> sendEmailVerification() async {
    final user = _firebaseAuth.currentUser;
    if (user != null && !user.emailVerified) {
      await user.sendEmailVerification();
    }
  }

  Future<app_user.User?> loginWithGoogle() async {
    try {
      // 1. Запускаємо нативний процес входу Google (відкривається вікно вибору акаунту)
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      // Якщо користувач закрив вікно і не вибрав акаунт
      if (googleUser == null) return null;

      // 2. Отримуємо токени з Google
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // 3. Створюємо "квиток" для входу у Firebase
      final firebase_auth.AuthCredential credential =
          firebase_auth.GoogleAuthProvider.credential(
            accessToken: googleAuth.accessToken,
            idToken: googleAuth.idToken,
          );

      // 4. Входимо у Firebase за допомогою цього квитка
      final userCredential = await _firebaseAuth.signInWithCredential(
        credential,
      );
      final user = userCredential.user;

      if (user != null) {
        // 5. Перевіряємо, чи є такий юзер у нашій базі Firestore
        var appUser = await _firestoreService.getUser();

        if (appUser == null) {
          // Якщо немає (перший вхід) — створюємо профіль
          appUser = app_user.User(
            id: null,
            email: user.email ?? '',
            name: user.displayName ?? 'Google User', // Беремо ім'я з Google
            passwordHash: '',
            salt: '',
            weightKg: 0, // Вагу доведеться вказати пізніше
            avatarUrl: user.photoURL, // Беремо фото з Google!
          );
          await _firestoreService.saveUser(appUser);
        }
        return appUser;
      }
    } catch (e) {
      // Тут можна додати логування помилки
      throw Exception('Помилка входу через Google: $e');
    }
    return null;
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

      await cred.user!.sendEmailVerification();

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
    try {
      // 1. Перевіряємо, чи взагалі був вхід через Google
      // Це врятує тебе від помилки, якщо юзер зайшов через логін/пароль
      if (await _googleSignIn.isSignedIn()) {
        await _googleSignIn.disconnect();
      } else {
        // Якщо не залогінений в Google плагіні - нічого не робимо або просто signOut
        await _googleSignIn.signOut();
      }
    } catch (e) {
      // 2. Якщо Google викине помилку - ми її глушимо і йдемо далі
      print("Google disconnect error: $e");
    }
    await _firebaseAuth.signOut();
  }

  // Скидання паролю (додаткова фіча, якої не було, але вона корисна)
  Future<void> resetPassword(String email) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }
}
