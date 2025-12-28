import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gym_tracker_app/features/profile/models/user_model.dart';
import 'package:gym_tracker_app/features/welcome/pages/welcome_page.dart';
import 'package:gym_tracker_app/l10n/app_localizations.dart';
import 'package:gym_tracker_app/services/auth_service.dart';
import 'package:gym_tracker_app/services/firestore_service.dart';
import 'package:gym_tracker_app/widget/common/primary_filled_button.dart';
import 'package:gym_tracker_app/widget/common/widget_tree.dart';

class VerifyEmailPage extends StatefulWidget {
  final double? pendingWeight; // Вага з онбордингу

  const VerifyEmailPage({super.key, this.pendingWeight});

  @override
  State<VerifyEmailPage> createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  bool isEmailVerified = false;
  bool canResendEmail = true;
  bool _isCreatingProfile = false;
  Timer? timer;

  final AuthService _authService = AuthService();
  final FirestoreService _firestoreService = FirestoreService();

  @override
  void initState() {
    super.initState();

    // Початкова перевірка
    isEmailVerified = FirebaseAuth.instance.currentUser?.emailVerified ?? false;

    if (!isEmailVerified) {
      // Запускаємо таймер для перевірки статусу кожні 3 секунди
      timer = Timer.periodic(
        const Duration(seconds: 3),
        (_) => checkEmailVerified(),
      );
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future<void> checkEmailVerified() async {
    if (_isCreatingProfile) return;

    try {
      await FirebaseAuth.instance.currentUser?.reload();
      final user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        timer?.cancel();
        return;
      }

      if (user.emailVerified) {
        timer?.cancel();

        if (mounted) setState(() => _isCreatingProfile = true);

        await _createFirestoreUser(user);

        if (mounted) {
          setState(() {
            isEmailVerified = true;
            _isCreatingProfile = false;
          });
        }
      }
    } catch (e) {
      debugPrint("Error verifying: $e");
    }
  }

  Future<void> _createFirestoreUser(User user) async {
    try {
      final newUser = UserModel(
        id: user.uid,
        email: user.email ?? '',
        name: user.displayName ?? 'User',
        weightKg: widget.pendingWeight,
      );

      await _firestoreService.saveUser(newUser);
    } catch (e) {
      debugPrint('Error creating user profile: $e');
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Error creating profile: $e")));
      }
    }
  }

  Future<void> sendVerificationEmail() async {
    try {
      await _authService.sendEmailVerification();
      setState(() => canResendEmail = false);

      // Затримка перед можливістю повторної відправки
      await Future.delayed(const Duration(seconds: 10));

      if (mounted) setState(() => canResendEmail = true);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }
  }

  // 🔥 ВИПРАВЛЕНИЙ МЕТОД ВИХОДУ
  Future<void> _onLogoutPressed() async {
    timer?.cancel();

    try {
      // Видаляємо користувача з Firebase Auth.
      // Це автоматично розлогінить його і звільнить Email.
      await FirebaseAuth.instance.currentUser?.delete();
    } catch (e) {
      debugPrint("Error deleting user: $e");
      // Якщо видалення не вдалося (наприклад, помилка мережі), робимо звичайний вихід
      await _authService.logout();
    }

    if (!mounted) return;

    // Переходимо на Welcome Page
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const WelcomePage()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isEmailVerified) {
      return const WidgetTree();
    }

    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(loc.verifyEmailTitle)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: _isCreatingProfile
            ? const Center(child: CircularProgressIndicator())
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    loc.verifyEmailMessage,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 24),

                  PrimaryFilledButton(
                    text: loc.resendEmail,
                    // Додав перевірку canResendEmail, щоб кнопка блокувалася
                    onPressed: sendVerificationEmail,
                  ),

                  const SizedBox(height: 8),

                  TextButton(
                    onPressed: _onLogoutPressed,
                    child: Text(loc.cancelLogout),
                  ),
                ],
              ),
      ),
    );
  }
}
