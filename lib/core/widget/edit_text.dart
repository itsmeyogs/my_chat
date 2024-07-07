import 'package:flutter/material.dart';

class EditText extends StatelessWidget {
  const EditText({super.key, required this.controller, required this.hint, required this.action, required this.keyboardType});

  final TextEditingController controller;
  final String hint;
  final TextInputAction action;
  final TextInputType keyboardType;

  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType: keyboardType,
      textInputAction: action,
      decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          hintText: hint),
      controller: controller,
    );
  }
}
