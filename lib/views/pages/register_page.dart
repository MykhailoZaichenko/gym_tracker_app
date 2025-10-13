// lib/views/pages/register_page.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lottie/lottie.dart';
import 'package:gym_tracker_app/views/pages/login_page.dart';
import 'package:gym_tracker_app/views/widget_tree.dart';
import '../../services/auth_service.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key, required this.title});
  final String title;

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _nameCtrl = TextEditingController();
  final TextEditingController _pwCtrl = TextEditingController();
  final TextEditingController _pwConfirmCtrl = TextEditingController();

  final AuthService _auth = AuthService();
  bool _loading = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _nameCtrl.dispose();
    _pwCtrl.dispose();
    _pwConfirmCtrl.dispose();
    super.dispose();
  }

  Future<void> _persistUserId(int id) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('current_user_id', id);
  }

  void _showMessage(String text) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  Future<void> _onRegisterPressed() async {
    final formState = _formKey.currentState;
    if (formState == null) {
      _showMessage('Форма ще не прикріплена до дерева. Спробуй ще раз.');
      return;
    }
    if (!formState.validate()) return;

    final email = _emailCtrl.text.trim();
    final name = _nameCtrl.text.trim();
    final pw = _pwCtrl.text;

    setState(() => _loading = true);
    try {
      final user = await _auth.register(email: email, name: name, password: pw);
      if (user == null) {
        _showMessage('Реєстрація не вдалася: сервіс повернув null');
        return;
      }
      if (user.id == null) {
        _showMessage('Реєстрація пройшла, але ID користувача не отримано');
        return;
      }
      await _persistUserId(user.id!);
      _goToApp();
    } catch (e) {
      _showMessage(e.toString().replaceAll('Exception: ', ''));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _goToApp() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const WidgetTree()),
      (route) => false,
    );
  }

  String? _validateEmail(String? v) {
    if (v == null || v.trim().isEmpty) return 'Email required';
    final email = v.trim();
    final emailRe = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    if (!emailRe.hasMatch(email)) return 'Invalid email';
    return null;
  }

  String? _validateName(String? v) {
    if (v == null || v.trim().isEmpty) return 'Name required';
    if (v.trim().length < 2) return 'Name too short';
    return null;
  }

  String? _validatePassword(String? v) {
    if (v == null || v.isEmpty) return 'Password required';
    if (v.length < 6) return 'Password must be at least 6 chars';
    return null;
  }

  String? _validatePasswordConfirm(String? v) {
    if (v == null || v.isEmpty) return 'Confirm password';
    if (v != _pwCtrl.text) return 'Passwords do not match';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            child: Column(
              children: [
                isDark
                    ? ColorFiltered(
                        colorFilter: const ColorFilter.mode(
                          Colors.white,
                          BlendMode.srcATop,
                        ),
                        child: Lottie.asset('assets/lotties/dumbell.json'),
                      )
                    : Lottie.asset('assets/lotties/dumbell.json'),
                const SizedBox(height: 8),
                Text(
                  'Створити обліковий запис',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 20),

                // IMPORTANT: Form with key attached so currentState is not null
                Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _emailCtrl,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        validator: _validateEmail,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _nameCtrl,
                        decoration: InputDecoration(
                          labelText: 'Name',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        validator: _validateName,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _pwCtrl,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        obscureText: true,
                        validator: _validatePassword,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _pwConfirmCtrl,
                        decoration: InputDecoration(
                          labelText: 'Confirm Password',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        obscureText: true,
                        validator: _validatePasswordConfirm,
                      ),
                      const SizedBox(height: 18),
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: FilledButton(
                          onPressed: _loading ? null : _onRegisterPressed,
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: _loading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Text('Register'),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Already have account? '),
                          TextButton(
                            onPressed: _loading
                                ? null
                                : () => Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) {
                                        return const LoginPage(title: 'Log in');
                                      },
                                    ),
                                    (route) => false,
                                  ),
                            child: const Text("Log In"),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
