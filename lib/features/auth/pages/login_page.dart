import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gym_tracker_app/data/sources/local/app_db.dart';
import 'package:gym_tracker_app/features/auth/widgets/auth_form_widget.dart';

import 'package:gym_tracker_app/features/welcome/pages/onboarding_page.dart';
import 'package:gym_tracker_app/l10n/app_localizations.dart';
import 'package:gym_tracker_app/services/auth_service.dart';
import 'package:gym_tracker_app/widget/common/hero_widget.dart';
import 'package:gym_tracker_app/widget/common/page_title.dart';
import 'package:gym_tracker_app/widget/common/primary_filled_button.dart';
import 'package:gym_tracker_app/widget/common/primary_text_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gym_tracker_app/widget/common/widget_tree.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

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
    // _tryAutoLogin();
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

  String? _validateEmail(String? v) {
    final loc = AppLocalizations.of(context)!;
    if (v == null || v.trim().isEmpty) return loc.errEmailRequired;
    final email = v.trim();
    final emailRe = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    if (!emailRe.hasMatch(email)) return loc.errInvalidEmail;
    return null;
  }

  String? _validatePassword(String? v) {
    final loc = AppLocalizations.of(context)!;
    if (v == null || v.isEmpty) return loc.errPasswordRequired;
    if (v.length < 6) return loc.errPasswordShort;
    return null;
  }

  Future<void> _onLoginPressed() async {
    FocusScope.of(context).unfocus();

    final formState = _formKey.currentState;
    if (formState == null) return;

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
    final loc = AppLocalizations.of(context)!;
    await showDialog<void>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Reset password (local)'),
          content: TextField(
            controller: emailCtrl,
            decoration: InputDecoration(labelText: loc.emailLabel),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: Text(loc.cancel),
            ),
            TextButton(
              onPressed: () async {
                final email = emailCtrl.text.trim();
                if (email.isEmpty) {
                  _showMessage(loc.errEmailRequired);
                  return;
                }
                final user = await AppDb().getUserByEmail(email);
                if (!mounted) return;
                if (user == null) {
                  _showMessage('No user with that email');
                  return;
                }

                Navigator.of(context).pop();

                final newpasswordCtrl = TextEditingController();
                final newPassword = await showDialog<String>(
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
                          onPressed: () {
                            final newpassword = newpasswordCtrl.text;
                            if (newpassword.isEmpty) {
                              if (mounted) _showMessage('Password required');
                              return;
                            }
                            Navigator.of(ctx2).pop(newpassword); // return value
                          },
                          child: Text(loc.save),
                        ),
                      ],
                    );
                  },
                );

                // after await — check mounted before using context
                if (!mounted || newPassword == null || newPassword.isEmpty) {
                  return;
                }

                await _auth.changePassword(user.id!, newPassword);
                if (mounted) _showMessage('Password updated');
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

  // Функції debounce для передачі в AuthPageWidget
  void _onEmailChanged(String value) {
    _emailDebounce?.cancel();
    _emailDebounce = Timer(const Duration(milliseconds: 700), () {
      _emailFieldKey.currentState?.validate();
    });
  }

  void _onPasswordChanged(String value) {
    _passwordDebounce?.cancel();
    _passwordDebounce = Timer(const Duration(milliseconds: 700), () {
      _passwordFieldKey.currentState?.validate();
    });
  }

  // Обробники submit для полів
  void _onEmailSubmitted(_) => FocusScope.of(context).requestFocus(paswFocus);
  void _onPasswordSubmitted(_) => _onLoginPressed();

  @override
  Widget build(BuildContext context) {
    double widthScreen = MediaQuery.of(context).size.width;
    final loc = AppLocalizations.of(context)!;

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
                      HeroWidget(tag: 'login_lottie'),
                      AppPageTitle(title: loc.loginTitle),
                      const SizedBox(height: 20),
                      AuthPageWidget(
                        formKey: _formKey,
                        authFormType: AuthFormType.login,
                        emailFieldKey: _emailFieldKey,
                        controllerEmail: controllerEmail,
                        emailFocus: emailFocus,
                        validateEmail: _validateEmail,
                        onEmailChanged: _onEmailChanged,
                        onEmailSubmitted: _onEmailSubmitted,
                        // Password Fields
                        passwordFieldKey: _passwordFieldKey,
                        controllerPassword: controllerPassword,
                        paswFocus: paswFocus,
                        validatePassword: _validatePassword,
                        onPasswordChanged: _onPasswordChanged,
                        onPasswordSubmitted: _onPasswordSubmitted,
                      ),
                      const SizedBox(height: 20.0),
                      PrimaryFilledButton(
                        onPressed: _onLoginPressed,
                        text: loc.loginAction,
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          PrimaryTextButton(
                            text: loc.registerAction,
                            onPressed: _loading
                                ? null
                                : () {
                                    Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => const OnboardingPage(),
                                      ),
                                      (route) => false,
                                    );
                                  },
                          ),
                          const SizedBox(width: 8),
                          PrimaryTextButton(
                            text: loc.forgotPassword,
                            onPressed: _loading ? null : _onForgotPressed,
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
