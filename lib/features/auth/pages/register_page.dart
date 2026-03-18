import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gym_tracker_app/features/auth/pages/verify_email_page.dart';
import 'package:gym_tracker_app/features/auth/widgets/auth_form_widget.dart';
import 'package:gym_tracker_app/features/health/models/body_weight_model.dart';
import 'package:gym_tracker_app/l10n/app_localizations.dart';
import 'package:gym_tracker_app/services/firestore_service.dart';
import 'package:gym_tracker_app/widget/common/custome_snackbar.dart';
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
  final GlobalKey<FormFieldState<String>> _passwordFieldKey =
      GlobalKey<FormFieldState<String>>();
  final GlobalKey<FormFieldState<String>> _passwordConfirmFieldKey =
      GlobalKey<FormFieldState<String>>();

  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _passwordCtrl = TextEditingController();
  final TextEditingController _passwordConfirmCtrl = TextEditingController();

  late final FocusNode emailFocus;
  late final FocusNode passwordFocus;
  late final FocusNode passwordConfirmFocus;

  Timer? _emailDebounce;
  Timer? _passwordDebounce;
  Timer? _passwordConfirmDebounce;

  final AuthService _auth = AuthService();
  final FirestoreService _firestore = FirestoreService();
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    emailFocus = FocusNode();
    passwordFocus = FocusNode();
    passwordConfirmFocus = FocusNode();
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _passwordConfirmCtrl.dispose();
    emailFocus.dispose();
    passwordFocus.dispose();
    passwordConfirmFocus.dispose();
    _emailDebounce?.cancel();
    _passwordDebounce?.cancel();
    _passwordConfirmDebounce?.cancel();
    super.dispose();
  }

  void _showMessage(String text) {
    if (!mounted) return;
    CustomSnackBar.show(context, message: text, isError: true);
  }

  // --- ЛОГІКА GOOGLE ---
  Future<void> _onGoogleRegisterPressed() async {
    final loc = AppLocalizations.of(context)!;
    setState(() => _loading = true);
    try {
      final user = await _auth.loginWithGoogle();

      if (user != null) {
        final prefs = await SharedPreferences.getInstance();
        final savedWeight = prefs.getDouble('user_weight');

        if (savedWeight != null && savedWeight > 0) {
          await _firestore.saveUser(user);

          await _firestore.saveBodyWeight(
            BodyWeightModel(id: '', weight: savedWeight, date: DateTime.now()),
          );

          await prefs.remove('user_weight');
        }

        if (!mounted) return;
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const VerifyEmailPage()),
          (route) => false,
        );
      }
    } catch (e) {
      _showMessage('${loc.errGoogleSignIn}: $e');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  // --- ЛОГІКА EMAIL ---
  Future<void> _onRegisterPressed() async {
    FocusScope.of(context).unfocus();

    final formState = _formKey.currentState;
    if (formState == null) return;
    if (!formState.validate()) return;

    final email = _emailCtrl.text.trim();
    final password = _passwordCtrl.text;

    setState(() => _loading = true);
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      await userCredential.user?.sendEmailVerification();

      final prefs = await SharedPreferences.getInstance();
      final savedWeight = prefs.getDouble('user_weight');

      if (!mounted) return;

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) => VerifyEmailPage(pendingWeight: savedWeight),
        ),
        (route) => false,
      );
    } catch (e) {
      _showMessage(e.toString().replaceAll('Exception: ', ''));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
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

  void _onEmailSubmitted(_) =>
      FocusScope.of(context).requestFocus(passwordFocus);

  void _onPasswordSubmitted(_) =>
      FocusScope.of(context).requestFocus(passwordConfirmFocus);
  void _onPasswordConfirmSubmitted(_) => _onRegisterPressed();

  @override
  Widget build(BuildContext context) {
    final widthScreen = MediaQuery.of(context).size.width;
    final loc = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;

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
                          Text(
                            '${loc.alreadyHaveAccount} ',
                            style: textTheme.bodyMedium,
                          ),
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
