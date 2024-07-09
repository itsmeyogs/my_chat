import 'package:flutter/material.dart';

class EditText extends StatelessWidget {
  const EditText(
      {super.key,
      required this.controller,
      required this.hint,
      required this.action,
      required this.keyboardType,
      this.isPassword = false,
      this.validator,
      this.suffixIcon});

  final TextEditingController controller;
  final String hint;
  final TextInputAction action;
  final TextInputType keyboardType;
  final bool isPassword;
  final String? Function(String?)? validator;
  final Widget? suffixIcon;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        keyboardType: keyboardType,
        textInputAction: action,
        decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            hintText: hint,
            suffixIcon: suffixIcon),
        controller: controller,
        obscureText: isPassword,
        validator: validator);
  }
}
