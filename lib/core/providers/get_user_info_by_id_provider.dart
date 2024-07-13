import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_chat/core/constants/firebase_collection_names.dart';
import 'package:my_chat/core/models/user_model.dart';

//provider untuk mengambil data user berdasarkan uid
final getUserInfoByIdProvider =
FutureProvider.autoDispose.family<UserModel, String>((ref, userId) {
  return FirebaseFirestore.instance
      .collection(FirebaseCollectionNames.users)
      .doc(userId)
      .get()
      .then((userData) {
    return UserModel.fromMap(userData.data()!);
  });
});