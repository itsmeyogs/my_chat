import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';


// Fungsi untuk menampilkan Image Picker
Future<File?> pickImage() async {
  // Membuat variabel nullable bertipe File dengan nama image untuk menyimpan path gambar
  File? image;

  // Inisialisasi ImagePicker
  final picker = ImagePicker();

  // Menampilkan Image Picker dan mengambil hasil pemilihan gambar
  final file = await picker.pickImage(
    // Membuka galeri untuk memilih gambar
    source: ImageSource.gallery,
    // Mengatur batas maksimum lebar gambar menjadi 720 pixel
    maxWidth: 720,
    // Mengatur batas maksimum tinggi gambar menjadi 720 pixel
    maxHeight: 720,
  );

  // Mengecek apakah ada gambar yang dipilih
  if (file != null) {
    // Jika gambar dipilih, simpan path gambar ke dalam variabel image
    image = File(file.path);
  }

  // Mengembalikan variabel image yang berisi path gambar.
  return image;
}

// Fungsi untuk menampilkan toast message dengan parameter text
void showToastMessage({required String text,}) {
  Fluttertoast.showToast(
    msg: text,
    backgroundColor: Colors.black54, // Mengatur warna background toast message menjadi hitam transparan
    fontSize: 14, // Mengatur ukuran font text pada toast message menjadi 14
    toastLength: Toast.LENGTH_SHORT, // Mengatur durasi toast message menjadi SHORT
    gravity: ToastGravity.BOTTOM, // Menampilkan toast message di bagian bawah layar
  );
}