import 'package:flutter/material.dart';

class StyledTextField extends StatelessWidget {
  final bool autofocus;
  // Ключ для доступу до поля (опціонально)
  final Key? fieldKey;
  // Контролер для керування текстом
  final TextEditingController? controller;
  // Фокус-нода для керування фокусом
  final FocusNode? focusNode;
  // Текст-заповнювач
  final String? hintText;
  // Текст-мітка
  final String? labelText;
  // Валідатор
  final FormFieldValidator<String>? validator;
  // Дія при надсиланні
  final ValueChanged<String>? onFieldSubmitted;
  // Дія при зміні тексту
  final ValueChanged<String>? onChanged;
  // Тип клавіатури
  final TextInputType keyboardType;
  // Дія клавіші Enter
  final TextInputAction textInputAction;
  // Чи приховувати текст (для паролів)
  final bool obscureText;
  // Іконка на початку
  final Widget? prefixIcon;
  // Іконка в кінці
  final Widget? suffixIcon;

  const StyledTextField({
    super.key,
    this.autofocus = false,
    this.fieldKey,
    this.controller,
    this.focusNode,
    this.hintText,
    this.labelText,
    this.validator,
    this.onFieldSubmitted,
    this.onChanged,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.done,
    this.obscureText = false,
    this.prefixIcon,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: fieldKey,
      autofocus: autofocus,
      // autofillHints: ,
      controller: controller,
      focusNode: focusNode,
      obscureText: obscureText,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      validator: validator,
      onFieldSubmitted: onFieldSubmitted,
      onChanged: onChanged,
      // Уніфікований стиль InputDecoration
      decoration: InputDecoration(
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        hintText: hintText,
        labelText: labelText,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 14.0,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0), // Уніфіковане заокруглення
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: BorderSide(
            color: Theme.of(context).dividerColor,
            width: 1.0,
          ),
        ),
      ),
    );
  }
}
