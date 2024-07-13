import 'dart:io';

import 'package:flutter/material.dart';


//widget untuk pick image dan menampilkan image di profile page
class PickImageWidget extends StatelessWidget{
  const PickImageWidget({super.key,required this.onPressed, required this.image, required this.currentImage});

  final VoidCallback? onPressed;
  final File? image;
  final String currentImage;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        //mengecek jika image tidak sama dengan kosong, maka ditampilkan image(foto yang dipilih dari galeri)
        image != null
            ? CircleAvatar(
          radius: 85,
          backgroundImage: FileImage(image!),
        )
        //jika false maka akan ditampilkan gambar saat ini(dari firestore)
            :  CircleAvatar(
          radius: 85,
          backgroundImage: NetworkImage(currentImage),
        ),
        //meanmpilkan button icon camera untuk mengganti profile
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
