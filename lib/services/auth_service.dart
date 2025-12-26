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

  Stream<app_user.User?> get authStateChanges {
    return _firebaseAuth.authStateChanges().asyncMap((firebaseUser) async {
      if (firebaseUser == null) return null;
      return await _firestoreService.getUser();
    });
  }

  Future<void> sendEmailVerification() async {
    final user = _firebaseAuth.currentUser;
    if (user != null && !user.emailVerified) {
      await user.sendEmailVerification();
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  Future<app_user.User?> loginWithGoogle() async {
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    if (googleUser == null) return null;

    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    final firebase_auth.AuthCredential credential =
        firebase_auth.GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

    final userCredential = await _firebaseAuth.signInWithCredential(credential);
    final user = userCredential.user;

    if (user != null) {
      var appUser = await _firestoreService.getUser();

      if (appUser == null) {
        appUser = app_user.User(
          id: null,
          email: user.email ?? '',
          name: user.displayName ?? 'Google User',
          passwordHash: '',
          salt: '',
          weightKg: 0,
          avatarUrl: user.photoURL,
        );
        await _firestoreService.saveUser(appUser);
      }
      return appUser;
    }
    return null;
  }

  Future<app_user.User> register({
    required String email,
    required String name,
    required String password,
  }) async {
    final cred = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    if (cred.user == null) {
      throw Exception('Create user failed');
    }

    await cred.user!.sendEmailVerification();

    final newUser = app_user.User(
      id: null,
      email: email,
      name: name,
      passwordHash: '',
      salt: '',
      avatarUrl: null,
      weightKg: null,
    );

    await _firestoreService.saveUser(newUser);
    return newUser;
  }

  Future<app_user.User?> login({
    required String email,
    required String password,
  }) async {
    await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    final user = await _firestoreService.getUser();
    return user;
  }

  Future<void> updateProfile(app_user.User user) async {
    await _firestoreService.saveUser(user);
  }

  Future<void> changePassword(int? userId, String newPassword) async {
    final user = _firebaseAuth.currentUser;
    if (user == null) throw Exception('No user');
    await user.updatePassword(newPassword);
  }

  // Вихід
  Future<void> logout() async {
    if (await _googleSignIn.isSignedIn()) {
      await _googleSignIn.disconnect();
    } else {
      await _googleSignIn.signOut();
    }
  }

  Future<void> deleteAccount() async {
    final user = _firebaseAuth.currentUser;
    if (user == null) return;

    // Спроба видалити
    await user.delete();
  }

  Future<void> resetPassword(String email) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }
}
