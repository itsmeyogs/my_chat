import 'package:flutter/material.dart';

class AuthButton extends StatelessWidget {
  const AuthButton({
    super.key,
    required this.onPressed,
    required this.label,
    required this.labelSize,
  });

  final VoidCallback? onPressed;
  final String label;
  final double labelSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.blueGrey,
          borderRadius: BorderRadius.circular(10)),
      child: TextButton(
          onPressed: onPressed,
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Text(
            label,
              style: TextStyle(
                  fontSize: labelSize,
                  color: Colors.white),
            ),
          )),
    );
  }
}