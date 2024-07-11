
import '../constants/app_message.dart';


//function untuk validasi nama
String? validateName(String? value){
  //mengecek apakah nama null atau kosong
  if(value ==null||value.isEmpty){
    return AppMessage.errorNameEmpty;
    //mengecek apakah nama memiliki panjang minimal 3
  }else if(value.length<3){
    return AppMessage.errorNameMinLength;
  }
  return null;
}

//function untuk validasi email
String? validateEmail(String? value) {
  //membuat pattern email menggunkan regex
  final checkPattern = RegExp(r"[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?\.[a-zA-Z]{2,}");
  //mengecek apakah email null atau kosong
  if (value == null || value.isEmpty) {
    return AppMessage.errorEmailEmpty;
    //mengecek apakah email tidak sama dengan pattern
  }else if (!checkPattern.hasMatch(value)) {
    return AppMessage.errorEmailNotValid;
  }
  return null;
}

//function untuk validasi password
String? validatePassword(String? value) {
  //membuat patern check uppercase menggunakan regex
  final checkUppercase = RegExp(r'[A-Z]');
  //membuat patern check lowercase menggunakan regex
  final checkLowercase = RegExp(r'[a-z]');
  //membuat patern check number menggunakan regex
  final checkNumber = RegExp(r'[0-9]');

  //mengecek apakah email null atau kosong
  if (value == null || value.isEmpty) {
    return AppMessage.errorPasswordEmpty;
    //mengecek apakah nama memiliki panjang minimal 6
  }else if(value.length<6){
    return AppMessage.errorPasswordMinLength;
    //mengecek apakah password tidak sama dengan pattern uppercase(memiliki huruf besar)
  }else if(!checkUppercase.hasMatch(value)){
    return AppMessage.errorPasswordNotContainUppercase;
    //mengecek apakah password tidak sama dengan pattern lowercase(memiliki huruf kecil)
  }else if(!checkLowercase.hasMatch(value)){
    return AppMessage.errorPasswordNotContainLowercase;
    //mengecek apakah password tidak sama dengan pattern number(memiliki angka)
  }else if(!checkNumber.hasMatch(value)){
    return AppMessage.errorPasswordNotContainNumber;
  }
  return null;
}