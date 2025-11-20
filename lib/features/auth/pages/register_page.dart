import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gym_tracker_app/features/auth/widgets/auth_form_widget.dart';
import 'package:gym_tracker_app/l10n/app_localizations.dart';
import 'package:gym_tracker_app/widget/common/hero_widget.dart';
import 'package:gym_tracker_app/widget/common/page_title.dart';
import 'package:gym_tracker_app/widget/common/primary_filled_button.dart';
import 'package:gym_tracker_app/widget/common/primary_text_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gym_tracker_app/features/auth/pages/login_page.dart';
import 'package:gym_tracker_app/widget/common/widget_tree.dart';
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

  Future<void> _persistUserId(int id) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('current_user_id', id);
  }

  void _showMessage(String text) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
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
      final user = await _auth.register(
        email: email,
        name: name,
        password: password,
      );
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

  // Функції debounce для передачі в AuthPageWidget
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

  // Обробники submit для полів
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
                        // Email Fields
                        emailFieldKey: _emailFieldKey,
                        controllerEmail: _emailCtrl,
                        emailFocus: emailFocus,
                        validateEmail: _validateEmail,
                        onEmailChanged: _onEmailChanged,
                        onEmailSubmitted: _onEmailSubmitted,
                        // Name Fields
                        nameFieldKey: _nameFieldKey,
                        controllerName: _nameCtrl,
                        nameFocus: nameFocus,
                        validateName: _validateName,
                        onNameChanged: _onNameChanged,
                        onNameSubmitted: _onNameSubmitted,
                        // Password Fields
                        passwordFieldKey: _passwordFieldKey,
                        controllerPassword: _passwordCtrl,
                        paswFocus: passwordFocus,
                        validatePassword: _validatePassword,
                        onPasswordChanged: _onPasswordChanged,
                        onPasswordSubmitted: _onPasswordSubmitted,
                        // Confirm Password Fields
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
