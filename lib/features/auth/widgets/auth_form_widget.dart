import 'dart:async';

import 'package:flutter/material.dart';

// Визначаємо перелік, щоб розрізняти тип сторінки (Login чи Register)
enum AuthFormType { login, register }

class AuthPageWidget extends StatelessWidget {
  const AuthPageWidget({
    super.key,
    required this.formKey,
    required this.authFormType,
    // Email
    required this.emailFieldKey,
    required this.controllerEmail,
    required this.emailFocus,
    required this.validateEmail,
    required this.onEmailChanged,
    required this.onEmailSubmitted,
    // Name (тільки для Register)
    this.nameFieldKey,
    this.controllerName,
    this.nameFocus,
    this.validateName,
    this.onNameChanged,
    this.onNameSubmitted,
    // Password
    required this.passwordFieldKey,
    required this.controllerPassword,
    required this.paswFocus,
    required this.validatePassword,
    required this.onPasswordChanged,
    required this.onPasswordSubmitted,
    // Confirm Password (тільки для Register)
    this.passwordConfirmFieldKey,
    this.controllerPasswordConfirm,
    this.passwordConfirmFocus,
    this.validatePasswordConfirm,
    this.onPasswordConfirmChanged,
    this.onPasswordConfirmSubmitted,
  });

  final AuthFormType authFormType;
  final GlobalKey<FormState> formKey;

  // Email
  final GlobalKey<FormFieldState<String>> emailFieldKey;
  final TextEditingController controllerEmail;
  final FocusNode emailFocus;
  final String? Function(String?) validateEmail;
  final void Function(String) onEmailChanged;
  final void Function(String) onEmailSubmitted;

  // Name (опціонально для Register)
  final GlobalKey<FormFieldState<String>>? nameFieldKey;
  final TextEditingController? controllerName;
  final FocusNode? nameFocus;
  final String? Function(String?)? validateName;
  final void Function(String)? onNameChanged;
  final void Function(String)? onNameSubmitted;

  // Password
  final GlobalKey<FormFieldState<String>> passwordFieldKey;
  final TextEditingController controllerPassword;
  final FocusNode paswFocus;
  final String? Function(String?) validatePassword;
  final void Function(String) onPasswordChanged;
  final void Function(String) onPasswordSubmitted;

  // Confirm Password (опціонально для Register)
  final GlobalKey<FormFieldState<String>>? passwordConfirmFieldKey;
  final TextEditingController? controllerPasswordConfirm;
  final FocusNode? passwordConfirmFocus;
  final String? Function(String?)? validatePasswordConfirm;
  final void Function(String)? onPasswordConfirmChanged;
  final void Function(String)? onPasswordConfirmSubmitted;

  @override
  Widget build(BuildContext context) {
    // У Register-формі поле "Name" є обов'язковим,
    // тому перевіряємо, чи всі опціональні поля для Register присутні
    final isRegister = authFormType == AuthFormType.register;
    if (isRegister) {
      assert(nameFieldKey != null);
      assert(controllerName != null);
      assert(nameFocus != null);
      assert(validateName != null);
      assert(onNameChanged != null);
      assert(nameFieldKey != null);
      assert(controllerPasswordConfirm != null);
      assert(passwordConfirmFocus != null);
      assert(validatePasswordConfirm != null);
      assert(onPasswordConfirmChanged != null);
    }

    return Form(
      key: formKey,
      autovalidateMode: AutovalidateMode.disabled,
      child: Column(
        children: [
          // --- Email Field ---
          TextFormField(
            key: emailFieldKey,
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
            validator: validateEmail,
            onFieldSubmitted: onEmailSubmitted,
            onChanged: onEmailChanged,
          ),
          const SizedBox(height: 12),

          // --- Name Field (тільки для Register) ---
          if (isRegister) ...[
            TextFormField(
              key: nameFieldKey,
              focusNode: nameFocus,
              controller: controllerName,
              decoration: InputDecoration(
                hintText: 'Enter name',
                labelText: 'Name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              textInputAction: TextInputAction.next,
              validator: validateName,
              onFieldSubmitted: onNameSubmitted,
              onChanged: onNameChanged,
            ),
            const SizedBox(height: 12),
          ],

          // --- Password Field ---
          TextFormField(
            key: passwordFieldKey,
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
            textInputAction: isRegister
                ? TextInputAction.next
                : TextInputAction.done,
            validator: validatePassword,
            onFieldSubmitted: onPasswordSubmitted,
            onChanged: onPasswordChanged,
          ),

          // --- Confirm Password Field (тільки для Register) ---
          if (isRegister) ...[
            const SizedBox(height: 12),
            TextFormField(
              key: passwordConfirmFieldKey,
              focusNode: passwordConfirmFocus,
              controller: controllerPasswordConfirm,
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
              onFieldSubmitted: onPasswordConfirmSubmitted,
              onChanged: onPasswordConfirmChanged,
            ),
          ],
        ],
      ),
    );
  }
}
