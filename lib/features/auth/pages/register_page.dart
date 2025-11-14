import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gym_tracker_app/features/auth/widgets/auth_form_widget.dart';
import 'package:gym_tracker_app/widget/common/hero_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gym_tracker_app/features/auth/pages/login_page.dart';
import 'package:gym_tracker_app/widget/common/widget_tree.dart';
import '../../../services/auth_service.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key, required this.title});
  final String title;

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
    if (formState == null) {
      _showMessage('Форма ще не прикріплена до дерева. Спробуй ще раз.');
      return;
    }
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
    if (v != _passwordCtrl.text) return 'Passwords do not match';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final widthScreen = MediaQuery.of(context).size.width;

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
                      Text(
                        'Створити обліковий запис',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 18),
                      Form(
                        key: _formKey,
                        child: AuthFormWidget(
                          mode: AuthFormMode.register,
                          formKey: _formKey,

                          emailCtrl: _emailCtrl,
                          nameCtrl: _nameCtrl,
                          passwordCtrl: _passwordCtrl,
                          passwordConfirmCtrl: _passwordConfirmCtrl,

                          emailFocus: emailFocus,
                          nameFocus: nameFocus,
                          passwordFocus: passwordFocus,
                          passwordConfirmFocus: passwordConfirmFocus,

                          emailFieldKey: _emailFieldKey,
                          nameFieldKey: _nameFieldKey,
                          passwordFieldKey: _passwordFieldKey,
                          passwordConfirmFieldKey: _passwordConfirmFieldKey,

                          validateEmail: _validateEmail,
                          validateName: _validateName,
                          validatePassword: _validatePassword,
                          validatePasswordConfirm: _validatePasswordConfirm,

                          onSubmit: _onRegisterPressed,

                          emailDebounce: _emailDebounce,
                          nameDebounce: _nameDebounce,
                          passwordDebounce: _passwordDebounce,
                          passwordConfirmDebounce: _passwordConfirmDebounce,
                        ),
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
