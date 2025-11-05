import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gym_tracker_app/features/auth/pages/register_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lottie/lottie.dart';
import 'package:gym_tracker_app/widget/common/widget_tree.dart';
import '../../../data/sources/local/app_db.dart';
import '../../../services/auth_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, required this.title});

  final String title;
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormFieldState<String>> _emailFieldKey =
      GlobalKey<FormFieldState<String>>();
  final GlobalKey<FormFieldState<String>> _passwordFieldKey =
      GlobalKey<FormFieldState<String>>();

  final TextEditingController controllerEmail = TextEditingController();
  final TextEditingController controllerPassword = TextEditingController();

  final AuthService _auth = AuthService();
  bool _loading = false;

  late final FocusNode emailFocus;
  late final FocusNode paswFocus;

  Timer? _emailDebounce;
  Timer? _passwordDebounce;

  @override
  void initState() {
    super.initState();
    emailFocus = FocusNode();
    paswFocus = FocusNode();
    emailFocus.addListener(() {
      if (!emailFocus.hasFocus) {
        _emailFieldKey.currentState?.validate();
      }
    });
    paswFocus.addListener(() {
      if (!paswFocus.hasFocus) {
        _passwordFieldKey.currentState?.validate();
      }
    });
  }

  @override
  void dispose() {
    controllerEmail.dispose();
    controllerPassword.dispose();
    emailFocus.dispose();
    paswFocus.dispose();
    _emailDebounce?.cancel();
    _passwordDebounce?.cancel();
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

  Future<void> _onLoginPressed() async {
    FocusScope.of(context).unfocus();

    final formState = _formKey.currentState;
    if (formState == null) {
      _showMessage('Форма ще не прикріплена до дерева. Спробуй ще раз.');
      return;
    }

    if (!formState.validate()) {
      if (_emailFieldKey.currentState?.validate() == false) {
        FocusScope.of(context).requestFocus(emailFocus);
      } else {
        FocusScope.of(context).requestFocus(paswFocus);
      }
      return;
    }

    final email = controllerEmail.text.trim();
    final password = controllerPassword.text;

    setState(() => _loading = true);
    try {
      final user = await _auth.login(email: email, password: password);
      if (user == null) {
        _showMessage('Invalid email or password');
      } else {
        await _persistUserId(user.id!);
        if (!mounted) return;
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
                  final newpasswordCtrl = TextEditingController();
                  await showDialog<void>(
                    context: context,
                    builder: (ctx2) {
                      return AlertDialog(
                        title: const Text('Enter new password'),
                        content: TextField(
                          controller: newpasswordCtrl,
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
                              final newpassword = newpasswordCtrl.text;
                              if (newpassword.isEmpty) {
                                _showMessage('Password required');
                                return;
                              }
                              await _auth.changePassword(user.id!, newpassword);
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

  String? _validateEmail(String? v) {
    if (v == null || v.trim().isEmpty) return 'Email required';
    final email = v.trim();
    final emailRe = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    if (!emailRe.hasMatch(email)) return 'Invalid email';
    return null;
  }

  String? _validatePassword(String? v) {
    if (v == null || v.isEmpty) return 'Password required';
    if (v.length < 6) return 'Password must be at least 6 chars';
    return null;
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
                      Form(
                        key: _formKey,
                        autovalidateMode: AutovalidateMode.disabled,
                        child: Column(
                          children: [
                            TextFormField(
                              key: _emailFieldKey,
                              focusNode: emailFocus,
                              controller: controllerEmail,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                hintText: 'Enter email',
                                labelText: 'Email',
                              ),
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                              validator: _validateEmail,
                              onFieldSubmitted: (_) => FocusScope.of(
                                context,
                              ).requestFocus(paswFocus),
                              onChanged: (value) {
                                _emailDebounce?.cancel();
                                _emailDebounce = Timer(
                                  const Duration(milliseconds: 700),
                                  () {
                                    _emailFieldKey.currentState?.validate();
                                  },
                                );
                              },
                            ),
                            const SizedBox(height: 10.0),
                            TextFormField(
                              key: _passwordFieldKey,
                              focusNode: paswFocus,
                              controller: controllerPassword,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                hintText: 'Enter password',
                                labelText: 'Password',
                              ),
                              obscureText: true,
                              textInputAction: TextInputAction.done,
                              validator: _validatePassword,
                              onFieldSubmitted: (_) => _onLoginPressed(),
                              onChanged: (value) {
                                _passwordDebounce?.cancel();
                                _passwordDebounce = Timer(
                                  const Duration(milliseconds: 700),
                                  () {
                                    _passwordFieldKey.currentState?.validate();
                                  },
                                );
                              },
                            ),
                          ],
                        ),
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
}
