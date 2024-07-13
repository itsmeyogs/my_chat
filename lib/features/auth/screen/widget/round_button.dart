import 'package:flutter/material.dart';


//widget custom dari Button
class RoundButton extends StatelessWidget {
  const RoundButton({
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
          child: Text(
          label,
            style: TextStyle(
                fontSize: labelSize,
                fontWeight: FontWeight.w600,
                color: Colors.white),
          )),
    );
  }
}