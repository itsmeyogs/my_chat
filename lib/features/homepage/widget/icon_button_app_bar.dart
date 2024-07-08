import 'package:flutter/material.dart';

class IconButtonAppBar extends StatelessWidget {
  const IconButtonAppBar(
      {super.key, required this.onPressed, required this.icon});

  final VoidCallback? onPressed;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: onPressed,
        child: Icon(icon)
    );
  }
}
