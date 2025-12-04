import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gym_tracker_app/features/auth/pages/verify_email_page.dart';
import 'package:gym_tracker_app/features/auth/widgets/auth_form_widget.dart';
import 'package:gym_tracker_app/l10n/app_localizations.dart';
import 'package:gym_tracker_app/services/firestore_service.dart';
import 'package:gym_tracker_app/widget/common/hero_widget.dart';
import 'package:gym_tracker_app/widget/common/page_title.dart';
import 'package:gym_tracker_app/widget/common/primary_filled_button.dart';
import 'package:gym_tracker_app/widget/common/primary_text_button.dart';
import 'package:gym_tracker_app/features/auth/pages/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../services/auth_service.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormFieldState<String>> _emailFieldKey =
      GlobalKey<FormFieldState<String>>();
  final GlobalKey<FormFieldState<String>> _nameFieldKey =
      GlobalKey<FormFieldState<String>>();
  final GlobalKey<FormFieldState<String>> _passwordFieldKey =
      GlobalKey<FormFieldState<String>>();
  final GlobalKey<FormFieldState<String>> _passwordConfirmFieldKey =
      GlobalKey<FormFieldState<String>>();

  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _nameCtrl = TextEditingController();
  final TextEditingController _passwordCtrl = TextEditingController();
  final TextEditingController _passwordConfirmCtrl = TextEditingController();

  late final FocusNode emailFocus;
  late final FocusNode nameFocus;
  late final FocusNode passwordFocus;
  late final FocusNode passwordConfirmFocus;

  Timer? _emailDebounce;
  Timer? _nameDebounce;
  Timer? _passwordDebounce;
  Timer? _passwordConfirmDebounce;

  final AuthService _auth = AuthService();
  final FirestoreService _firestore = FirestoreService();
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    emailFocus = FocusNode();
    nameFocus = FocusNode();
    passwordFocus = FocusNode();
    passwordConfirmFocus = FocusNode();

    emailFocus.addListener(() {
      if (!emailFocus.hasFocus) {
        _emailFieldKey.currentState?.validate();
      }
    });
    nameFocus.addListener(() {
      if (!nameFocus.hasFocus) {
        _nameFieldKey.currentState?.validate();
      }
    });
    passwordFocus.addListener(() {
      if (!passwordFocus.hasFocus) {
        _passwordFieldKey.currentState?.validate();
      }
    });
    passwordConfirmFocus.addListener(() {
      if (!passwordConfirmFocus.hasFocus) {
        _passwordConfirmFieldKey.currentState?.validate();
      }
    });
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    _nameCtrl.dispose();
    _passwordCtrl.dispose();
    _passwordConfirmCtrl.dispose();

    emailFocus.dispose();
    nameFocus.dispose();
    passwordFocus.dispose();
    passwordConfirmFocus.dispose();

    _emailDebounce?.cancel();
    _nameDebounce?.cancel();
    _passwordDebounce?.cancel();
    _passwordConfirmDebounce?.cancel();

    super.dispose();
  }

  void _showMessage(String text) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  Future<void> _onGoogleRegisterPressed() async {
    final loc = AppLocalizations.of(context)!;
    setState(() => _loading = true);
    try {
      // Цей метод в AuthService вже містить логіку створення юзера, якщо його немає
      final user = await _auth.loginWithGoogle();

      if (user != null) {
        // Додатково: якщо ви хочете зберегти вагу з onboarding для Google юзера,
        // це можна зробити тут, аналогічно до звичайної реєстрації.
        final prefs = await SharedPreferences.getInstance();
        final savedWeight = prefs.getDouble('user_weight');

        // Якщо вага є і у профілю вона ще 0 (новий юзер)
        if (savedWeight != null &&
            savedWeight > 0 &&
            (user.weightKg == null || user.weightKg == 0)) {
          // Оновлюємо профіль через ваш сервіс (потрібно буде імпортувати FirestoreService або додати метод в AuthService)
          await _auth.updateProfile(user.copyWith(weightKg: savedWeight));
          await prefs.remove('user_weight');
        }

        if (!mounted) return;
        _goToApp();
      }
    } catch (e) {
      _showMessage('${loc.errGoogleSignIn}: $e');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _onRegisterPressed() async {
    FocusScope.of(context).unfocus();

    final formState = _formKey.currentState;
    if (formState == null) return;
    if (!formState.validate()) return;

    final email = _emailCtrl.text.trim();
    final name = _nameCtrl.text.trim();
    final password = _passwordCtrl.text;

    setState(() => _loading = true);
    try {
      final newUser = await _auth.register(
        email: email,
        name: name,
        password: password,
      );

      final prefs = await SharedPreferences.getInstance();
      final savedWeight = prefs.getDouble('user_weight');

      if (savedWeight != null && savedWeight > 0) {
        final updatedUser = newUser.copyWith(weightKg: savedWeight);

        await _firestore.saveUser(updatedUser);

        await prefs.remove('user_weight');
      }

      if (!mounted) return;
      _goToApp();
    } catch (e) {
      _showMessage(e.toString().replaceAll('Exception: ', ''));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _goToApp() async {
    try {
      final email = _emailCtrl.text.trim();
      final password = _passwordCtrl.text;
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      await userCredential.user?.sendEmailVerification();
    } catch (e) {
      _showMessage(e.toString().replaceAll('Exception: ', ''));
    }
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const VerifyEmailPage()),
      (route) => false,
    );
  }

  String? _validateEmail(String? v) {
    final loc = AppLocalizations.of(context)!;
    if (v == null || v.trim().isEmpty) return loc.errEmailRequired;
    final email = v.trim();
    final emailRe = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    if (!emailRe.hasMatch(email)) return loc.errInvalidEmail;
    return null;
  }

  String? _validateName(String? v) {
    final loc = AppLocalizations.of(context)!;
    if (v == null || v.trim().isEmpty) return loc.errNameRequired;
    if (v.trim().length < 2) return loc.errNameShort;
    return null;
  }

  String? _validatePassword(String? v) {
    final loc = AppLocalizations.of(context)!;
    if (v == null || v.isEmpty) return loc.errPasswordRequired;
    if (v.length < 6) return loc.errPasswordShort;
    return null;
  }

  String? _validatePasswordConfirm(String? v) {
    final loc = AppLocalizations.of(context)!;
    if (v == null || v.isEmpty) return loc.confirmPasswordHint;
    if (v != _passwordCtrl.text) return loc.errPasswordsDoNotMatch;
    return null;
  }

  void _onEmailChanged(String value) {
    _emailDebounce?.cancel();
    _emailDebounce = Timer(const Duration(milliseconds: 700), () {
      _emailFieldKey.currentState?.validate();
    });
  }

  void _onNameChanged(String value) {
    _nameDebounce?.cancel();
    _nameDebounce = Timer(const Duration(milliseconds: 700), () {
      _nameFieldKey.currentState?.validate();
    });
  }

  void _onPasswordChanged(String value) {
    _passwordDebounce?.cancel();
    _passwordDebounce = Timer(const Duration(milliseconds: 700), () {
      _passwordFieldKey.currentState?.validate();
    });
  }

  void _onPasswordConfirmChanged(String value) {
    _passwordConfirmDebounce?.cancel();
    _passwordConfirmDebounce = Timer(const Duration(milliseconds: 700), () {
      _passwordConfirmFieldKey.currentState?.validate();
    });
  }

  void _onEmailSubmitted(_) => FocusScope.of(context).requestFocus(nameFocus);
  void _onNameSubmitted(_) =>
      FocusScope.of(context).requestFocus(passwordFocus);
  void _onPasswordSubmitted(_) =>
      FocusScope.of(context).requestFocus(passwordConfirmFocus);
  void _onPasswordConfirmSubmitted(_) => _onRegisterPressed();

  @override
  Widget build(BuildContext context) {
    final widthScreen = MediaQuery.of(context).size.width;
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(10),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return FractionallySizedBox(
                widthFactor: widthScreen < 500 ? 1 : 0.4,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 20,
                    horizontal: 12,
                  ),
                  child: Column(
                    children: [
                      HeroWidget(tag: 'register_lottie'),
                      const SizedBox(height: 8),
                      AppPageTitle(title: loc.registerTitle),
                      const SizedBox(height: 18),
                      AuthPageWidget(
                        formKey: _formKey,
                        authFormType: AuthFormType.register,
                        emailFieldKey: _emailFieldKey,
                        controllerEmail: _emailCtrl,
                        emailFocus: emailFocus,
                        validateEmail: _validateEmail,
                        onEmailChanged: _onEmailChanged,
                        onEmailSubmitted: _onEmailSubmitted,
                        nameFieldKey: _nameFieldKey,
                        controllerName: _nameCtrl,
                        nameFocus: nameFocus,
                        validateName: _validateName,
                        onNameChanged: _onNameChanged,
                        onNameSubmitted: _onNameSubmitted,
                        passwordFieldKey: _passwordFieldKey,
                        controllerPassword: _passwordCtrl,
                        paswFocus: passwordFocus,
                        validatePassword: _validatePassword,
                        onPasswordChanged: _onPasswordChanged,
                        onPasswordSubmitted: _onPasswordSubmitted,
                        passwordConfirmFieldKey: _passwordConfirmFieldKey,
                        controllerPasswordConfirm: _passwordConfirmCtrl,
                        passwordConfirmFocus: passwordConfirmFocus,
                        validatePasswordConfirm: _validatePasswordConfirm,
                        onPasswordConfirmChanged: _onPasswordConfirmChanged,
                        onPasswordConfirmSubmitted: _onPasswordConfirmSubmitted,
                      ),
                      const SizedBox(height: 18),
                      PrimaryFilledButton(
                        onPressed: _onRegisterPressed,
                        text: loc.registerAction,
                      ),
                      const SizedBox(height: 12),

                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: _loading ? null : _onGoogleRegisterPressed,
                          icon: const Icon(Icons.g_mobiledata, size: 32),
                          label: Text(loc.googleButton),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            side: BorderSide(
                              color: Theme.of(context).dividerColor,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('${loc.alreadyHaveAccount} '),
                          PrimaryTextButton(
                            text: loc.loginAction,
                            onPressed: _loading
                                ? null
                                : () => Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) {
                                        return const LoginPage();
                                      },
                                    ),
                                    (route) => false,
                                  ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
