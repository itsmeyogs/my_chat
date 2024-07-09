import 'dart:io';

import 'package:flutter/material.dart';

class PickImageWidget extends StatelessWidget{
  const PickImageWidget({super.key,required this.onPressed, required this.image, required this.currentImage});

  final VoidCallback? onPressed;
  final File? image;
  final String currentImage;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        image != null
            ? CircleAvatar(
          radius: 85,
          backgroundImage: FileImage(image!),
        )
            :  CircleAvatar(
          radius: 85,
          backgroundImage: NetworkImage(currentImage),
        ),
        Positioned(
          bottom: 0,
          right: 0,
            child: IconButton(
              onPressed: onPressed,
              icon: Container(
                decoration: BoxDecoration(
                  color: Colors.blueGrey, // Change color as needed
                  borderRadius: BorderRadius.circular(30.0), // Adjust corner radius
                ),
                child: const Padding(
                  padding: EdgeInsets.all(10.0), // Adjust padding as needed
                  child: Icon(Icons.camera_alt_outlined, size: 28, color: Colors.white),
                ),
              ),
            )
        ),
      ],
    );
  }
}
