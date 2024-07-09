import 'package:flutter/material.dart';

class BottomSheetEditName extends StatelessWidget {
  const BottomSheetEditName(
      {super.key,
      required this.nameController,
      required this.onCancelPressed,
      required this.onSavePressed});

  final TextEditingController nameController;
  final VoidCallback? onCancelPressed;
  final VoidCallback? onSavePressed;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Enter your name",
              style: TextStyle(fontSize: 16),
            ),
            TextField(
              controller: nameController,
              autofocus: true,
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextButton(
                      onPressed: onCancelPressed, child: const Text("Cancel")),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextButton(
                      onPressed: onSavePressed, child: const Text("Save")),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
