
import '../constants/app_message.dart';

String? validateName(String? value){
  if(value ==null||value.isEmpty){
    return AppMessage.errorNameEmpty;
  }else if(value.length<3){
    return AppMessage.errorNameMinLength;
  }
  return null;
}


String? validateEmail(String? value) {
  final checkPattern = RegExp(r"[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?\.[a-zA-Z]{2,}");
  if (value == null || value.isEmpty) {
    return AppMessage.errorEmailEmpty;
  }else if (!checkPattern.hasMatch(value)) {
    return AppMessage.errorEmailNotValid;
  }
  return null;
}

String? validatePassword(String? value) {
  final checkUppercase = RegExp(r'[A-Z]');
  final checkLowercase = RegExp(r'[a-z]');
  final checkNumber = RegExp(r'[0-9]');

  if (value == null || value.isEmpty) {
    return AppMessage.errorPasswordEmpty;
  }else if(value.length<6){
    return AppMessage.errorPasswordMinLength;
  }else if(!checkUppercase.hasMatch(value)){
    return AppMessage.errorPasswordNotContainUppercase;
  }else if(!checkLowercase.hasMatch(value)){
    return AppMessage.errorPasswordNotContainLowercase;
  }else if(!checkNumber.hasMatch(value)){
    return AppMessage.errorPasswordNotContainNumber;
  }
  return null;
}