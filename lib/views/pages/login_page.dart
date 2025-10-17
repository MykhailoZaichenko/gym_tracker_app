import 'package:flutter/material.dart';
import 'package:gym_tracker_app/views/pages/register_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lottie/lottie.dart';
import 'package:gym_tracker_app/views/widget_tree.dart';
import '../../data/db/app_db.dart';
import '../../services/auth_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, required this.title});

  final String title;
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController controllerEmail = TextEditingController();
  final TextEditingController controllerPassword = TextEditingController();

  final AuthService _auth = AuthService();
  bool _loading = false;

  @override
  void dispose() {
    controllerEmail.dispose();
    controllerPassword.dispose();
    super.dispose();
  }

  Future<void> _persistUserId(int id) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('current_user_id', id);
  }

  Future<int?> _readPersistedUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('current_user_id');
  }

  Future<void> _tryAutoLogin() async {
    final id = await _readPersistedUserId();
    if (id != null) {
      final user = await AppDb().getUserById(id);
      if (user != null) {
        _goToApp();
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _tryAutoLogin();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    double widthScreen = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: LayoutBuilder(
              builder: (context, BoxConstraints constraints) {
                return FractionallySizedBox(
                  widthFactor: widthScreen < 500 ? 0.9 : 0.4,
                  child: Column(
                    children: [
                      isDark
                          ? ColorFiltered(
                              colorFilter: const ColorFilter.mode(
                                Colors.white,
                                BlendMode.srcATop,
                              ),
                              child: Lottie.asset(
                                'assets/lotties/dumbell.json',
                                height: 300,
                              ),
                            )
                          : Lottie.asset(
                              'assets/lotties/dumbell.json',
                              height: 300,
                            ),
                      // const SizedBox(height: 8.0),
                      Text(
                        'Ввійти в обліковий запис',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: controllerEmail,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          hintText: 'Enter email',
                          labelText: 'Email',
                        ),
                        keyboardType: TextInputType.emailAddress,
                        onEditingComplete: () => setState(() {}),
                      ),
                      const SizedBox(height: 10.0),
                      TextField(
                        controller: controllerPassword,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          hintText: 'Enter password',
                          labelText: 'Password',
                        ),
                        obscureText: true,
                        onEditingComplete: () => setState(() {}),
                      ),
                      const SizedBox(height: 20.0),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: FilledButton(
                          onPressed: _loading ? null : _onLoginPressed,
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size.fromHeight(50),
                          ),
                          child: _loading
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : Text(widget.title),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                            onPressed: _loading
                                ? null
                                : () {
                                    Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => const RegisterPage(
                                          title: 'Register',
                                        ),
                                      ),
                                      (route) => false,
                                    );
                                  },
                            child: const Text('Register'),
                          ),
                          const SizedBox(width: 8),
                          TextButton(
                            onPressed: _loading ? null : _onForgotPressed,
                            child: const Text('Forgot password'),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _onLoginPressed() async {
    final email = controllerEmail.text.trim();
    final password = controllerPassword.text;
    if (email.isEmpty || password.isEmpty) {
      _showMessage('Email and password are required');
      return;
    }

    setState(() => _loading = true);
    try {
      final user = await _auth.login(email: email, password: password);
      if (user == null) {
        _showMessage('Invalid email or password');
      } else {
        await _persistUserId(user.id!);
        _goToApp();
      }
    } catch (e) {
      _showMessage('Login error: ${e.toString()}');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _onForgotPressed() async {
    final emailCtrl = TextEditingController(text: controllerEmail.text.trim());
    await showDialog<void>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Reset password (local)'),
          content: TextField(
            controller: emailCtrl,
            decoration: const InputDecoration(labelText: 'Email'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                final email = emailCtrl.text.trim();
                if (email.isEmpty) {
                  _showMessage('Email required');
                  return;
                }
                final user = await AppDb().getUserByEmail(email);
                if (user == null) {
                  _showMessage('No user with that email');
                } else {
                  // local reset: ask for new password
                  Navigator.of(ctx).pop();
                  final newPwCtrl = TextEditingController();
                  await showDialog<void>(
                    context: context,
                    builder: (ctx2) {
                      return AlertDialog(
                        title: const Text('Enter new password'),
                        content: TextField(
                          controller: newPwCtrl,
                          decoration: const InputDecoration(
                            labelText: 'New password',
                          ),
                          obscureText: true,
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(ctx2).pop(),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () async {
                              final newPw = newPwCtrl.text;
                              if (newPw.isEmpty) {
                                _showMessage('Password required');
                                return;
                              }
                              await _auth.changePassword(user.id!, newPw);
                              Navigator.of(ctx2).pop();
                              _showMessage('Password updated');
                            },
                            child: const Text('Save'),
                          ),
                        ],
                      );
                    },
                  );
                }
              },
              child: const Text('Reset'),
            ),
          ],
        );
      },
    );
  }

  void _goToApp() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const WidgetTree()),
      (route) => false,
    );
  }

  void _showMessage(String text) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }
}
