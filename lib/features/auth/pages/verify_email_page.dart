import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gym_tracker_app/services/auth_service.dart';
import 'package:gym_tracker_app/widget/common/primary_filled_button.dart';
import 'package:gym_tracker_app/widget/common/widget_tree.dart';

class VerifyEmailPage extends StatefulWidget {
  const VerifyEmailPage({super.key});

  @override
  State<VerifyEmailPage> createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  bool isEmailVerified = false;
  bool canResendEmail = false;
  Timer? timer;
  final AuthService _authService = AuthService();

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
    // Оновлюємо дані юзера з сервера Firebase
    await FirebaseAuth.instance.currentUser?.reload();

    setState(() {
      isEmailVerified =
          FirebaseAuth.instance.currentUser?.emailVerified ?? false;
    });

    if (isEmailVerified) {
      timer?.cancel();
    }
  }

  Future<void> sendVerificationEmail() async {
    try {
      await _authService.sendEmailVerification();
      setState(() => canResendEmail = false);
      // Затримка перед можливістю повторної відправки
      await Future.delayed(const Duration(seconds: 5));
      if (mounted) setState(() => canResendEmail = true);
    } catch (e) {
      if (mounted)
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    // Якщо пошта підтверджена, показуємо основний додаток
    if (isEmailVerified) {
      return const WidgetTree();
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Підтвердження пошти')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Лист із підтвердженням було надіслано на вашу електронну пошту. Будь ласка, перейдіть за посиланням у листі.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 24),
            PrimaryFilledButton(
              text: 'Надіслати лист ще раз',
              onPressed: canResendEmail ? sendVerificationEmail : () {},
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () => _authService.logout(),
              child: const Text('Скасувати (Вийти)'),
            ),
          ],
        ),
      ),
    );
  }
}
