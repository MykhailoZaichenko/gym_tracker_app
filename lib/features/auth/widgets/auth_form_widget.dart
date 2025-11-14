import 'dart:async';
import 'package:flutter/material.dart';

enum AuthFormMode { login, register }

class AuthFormWidget extends StatelessWidget {
  final AuthFormMode mode;

  final GlobalKey<FormState> formKey;

  final TextEditingController emailCtrl;
  final TextEditingController? nameCtrl;
  final TextEditingController passwordCtrl;
  final TextEditingController? passwordConfirmCtrl;

  final FocusNode emailFocus;
  final FocusNode? nameFocus;
  final FocusNode passwordFocus;
  final FocusNode? passwordConfirmFocus;

  final GlobalKey<FormFieldState<String>> emailFieldKey;
  final GlobalKey<FormFieldState<String>>? nameFieldKey;
  final GlobalKey<FormFieldState<String>> passwordFieldKey;
  final GlobalKey<FormFieldState<String>>? passwordConfirmFieldKey;

  final String? Function(String?) validateEmail;
  final String? Function(String?)? validateName;
  final String? Function(String?) validatePassword;
  final String? Function(String?)? validatePasswordConfirm;

  final VoidCallback onSubmit;

  final Timer? emailDebounce;
  final Timer? nameDebounce;
  final Timer? passwordDebounce;
  final Timer? passwordConfirmDebounce;

  const AuthFormWidget({
    super.key,
    required this.mode,
    required this.formKey,
    required this.emailCtrl,
    required this.passwordCtrl,
    required this.emailFocus,
    required this.passwordFocus,
    required this.emailFieldKey,
    required this.passwordFieldKey,
    required this.validateEmail,
    required this.validatePassword,
    required this.onSubmit,

    // Optional only for register
    this.nameCtrl,
    this.passwordConfirmCtrl,
    this.nameFocus,
    this.passwordConfirmFocus,
    this.nameFieldKey,
    this.passwordConfirmFieldKey,
    this.validateName,
    this.validatePasswordConfirm,

    this.emailDebounce,
    this.nameDebounce,
    this.passwordDebounce,
    this.passwordConfirmDebounce,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      autovalidateMode: AutovalidateMode.disabled,
      child: Column(
        children: [
          TextFormField(
            key: emailFieldKey,
            focusNode: emailFocus,
            controller: emailCtrl,
            decoration: InputDecoration(
              hintText: "Enter email",
              labelText: "Email",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            keyboardType: TextInputType.emailAddress,
            textInputAction: (mode == AuthFormMode.login)
                ? TextInputAction.next
                : TextInputAction.next,
            validator: validateEmail,
            onFieldSubmitted: (_) {
              if (mode == AuthFormMode.register) {
                FocusScope.of(context).requestFocus(nameFocus);
              } else {
                FocusScope.of(context).requestFocus(passwordFocus);
              }
            },
          ),
          const SizedBox(height: 12),

          // NAME (only for register)
          if (mode == AuthFormMode.register)
            TextFormField(
              key: nameFieldKey,
              focusNode: nameFocus,
              controller: nameCtrl,
              decoration: InputDecoration(
                hintText: 'Enter name',
                labelText: 'Name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              textInputAction: TextInputAction.next,
              validator: validateName,
              onFieldSubmitted: (_) {
                FocusScope.of(context).requestFocus(passwordFocus);
              },
            ),
          if (mode == AuthFormMode.register) const SizedBox(height: 12),

          // PASSWORD
          TextFormField(
            key: passwordFieldKey,
            focusNode: passwordFocus,
            controller: passwordCtrl,
            decoration: InputDecoration(
              hintText: "Enter password",
              labelText: "Password",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            obscureText: true,
            textInputAction: (mode == AuthFormMode.register)
                ? TextInputAction.next
                : TextInputAction.done,
            validator: validatePassword,
            onFieldSubmitted: (_) {
              if (mode == AuthFormMode.register) {
                FocusScope.of(context).requestFocus(passwordConfirmFocus);
              } else {
                onSubmit();
              }
            },
          ),
          const SizedBox(height: 12),

          // PASSWORD CONFIRM (only register)
          if (mode == AuthFormMode.register)
            TextFormField(
              key: passwordConfirmFieldKey,
              focusNode: passwordConfirmFocus,
              controller: passwordConfirmCtrl,
              decoration: InputDecoration(
                hintText: 'Enter password again',
                labelText: 'Confirm Password',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              obscureText: true,
              textInputAction: TextInputAction.done,
              validator: validatePasswordConfirm,
              onFieldSubmitted: (_) => onSubmit(),
            ),
        ],
      ),
    );
  }
}
