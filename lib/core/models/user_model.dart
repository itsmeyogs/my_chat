import 'package:flutter/foundation.dart' show immutable;
import 'package:my_chat/core/constants/firebase_field_names.dart';

//class ini berisi model untuk user
@immutable
class UserModel {
  final String name;
  final String email;
  final String password;
  final String profilePicUrl;
  final String uid;

  const UserModel(
      {required this.name,
      required this.email,
      required this.password,
      required this.profilePicUrl,
      required this.uid});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      FirebaseFieldNames.name: name,
      FirebaseFieldNames.email: email,
      FirebaseFieldNames.password: password,
      FirebaseFieldNames.profilePicUrl: profilePicUrl,
      FirebaseFieldNames.uid: uid,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
        name: map[FirebaseFieldNames.name] as String,
        email: map[FirebaseFieldNames.email] as String,
        password: map[FirebaseFieldNames.password] as String,
        profilePicUrl: map[FirebaseFieldNames.profilePicUrl] as String,
        uid: map[FirebaseFieldNames.uid] as String);
  }
}
