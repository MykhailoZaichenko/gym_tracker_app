import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// Імпортуй свої локалізації
import 'package:gym_tracker_app/l10n/app_localizations.dart';

/// Функція-обгортка для виклику (щоб було зручно, як у confirm_dialog)
Future<void> showForgotPasswordDialog({
  required BuildContext context,
  String? initialEmail,
}) {
  return showDialog<void>(
    context: context,
    builder: (ctx) => _ForgotPasswordDialog(initialEmail: initialEmail),
  );
}

/// Приватний віджет, який керує станом поля вводу
class _ForgotPasswordDialog extends StatefulWidget {
  final String? initialEmail;

  const _ForgotPasswordDialog({this.initialEmail});

  @override
  State<_ForgotPasswordDialog> createState() => _ForgotPasswordDialogState();
}

class _ForgotPasswordDialogState extends State<_ForgotPasswordDialog> {
  late TextEditingController _emailController;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLoading = false; // Щоб блокувати кнопку під час відправки

  @override
  void initState() {
    super.initState();
    // Ініціалізуємо контролер значенням, яке передали (якщо юзер вже ввів пошту на логіні)
    _emailController = TextEditingController(text: widget.initialEmail);
  }

  @override
  void dispose() {
    _emailController.dispose(); // Обов'язково очищаємо пам'ять
    super.dispose();
  }

  Future<void> _sendResetEmail() async {
    final email = _emailController.text.trim();
    final loc = AppLocalizations.of(context)!;

    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(loc.errEmailRequired)), // "Введіть email"
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      await _auth.sendPasswordResetEmail(email: email);

      if (mounted) {
        Navigator.of(context).pop(); // Закриваємо діалог
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(loc.resetPasswordEmailSent),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString().replaceAll('Exception: ', '')),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return AlertDialog(
      title: Text(loc.resetPasswordTitle),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(loc.resetPasswordInstruction),
          const SizedBox(height: 16),
          TextField(
            controller: _emailController,
            enabled: !_isLoading, // Блокуємо введення під час завантаження
            decoration: InputDecoration(
              labelText: loc.emailLabel,
              border: const OutlineInputBorder(),
            ),
            keyboardType: TextInputType.emailAddress,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
          child: Text(loc.cancel),
        ),
        ElevatedButton(
          // Використав ElevatedButton для головної дії
          onPressed: _isLoading ? null : _sendResetEmail,
          child: _isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(loc.send),
        ),
      ],
    );
  }
}
