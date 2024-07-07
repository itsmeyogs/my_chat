import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:my_chat/core/constants/firebase_collection_names.dart';
import 'package:my_chat/core/constants/firebase_field_names.dart';
import 'package:my_chat/core/constants/storage_folder_names.dart';
import 'package:my_chat/features/auth/models/user.dart';
import 'package:path_provider/path_provider.dart';

import '../../../core/utils/utils.dart';

class AuthRepository {
  final _auth = FirebaseAuth.instance;
  final _storage = FirebaseStorage.instance;
  final _firestore = FirebaseFirestore.instance;

  //login method
  Future<UserCredential?> login({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return credential;
    } catch (e) {
      showToastMessage(text: e.toString());
      return null;
    }
  }

  //logout method
  Future<String?> logout() async {
    try {
      _auth.signOut();
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  //register method
  Future<UserCredential?> register(
      {required name, required email, required password}) async {
    try {
      //create an account in firebase
      final credential = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      //mendapatkan path storage by id
      final path = _storage
          .ref(StorageFolderNames.profilePics)
          .child(_auth.currentUser!.uid);

      //mengakses gambar profile default dari images
      final defaultProfileImage =
          await rootBundle.load('images/profile_default.png');
      final byteData = defaultProfileImage.buffer.asUint8List();

      //membuat tempFile untuk profile default
      final appDocDir = await getApplicationDocumentsDirectory();
      final tempFile = File('${appDocDir.path}/profile_default.png');
      await tempFile.writeAsBytes(byteData);

      //mengupload profile default ke firebase_storage
      final taskSnapshot = await path.putFile(tempFile);

      //mengambil link gambar profile
      final downloadUrl = await taskSnapshot.ref.getDownloadURL();

      //membuat objek dari model
      UserModel user = UserModel(
          name: name,
          email: email,
          password: password,
          profilePicUrl: downloadUrl,
          uid: _auth.currentUser!.uid);

      //menyimpan data user ke firestore
      await _firestore
          .collection(FirebaseCollectionNames.users)
          .doc(_auth.currentUser!.uid)
          .set(user.toMap());

      return credential;
    } catch (e) {
      showToastMessage(text: e.toString());
      return null;
    }
  }

  //verify email;
  Future<String?> verifyEmail() async {
    final user = _auth.currentUser;
    try {
      if (user != null) {
        user.sendEmailVerification();
      }
      return null;
    } catch (e) {
      showToastMessage(text: e.toString());
      return e.toString();
    }
  }

  //get user info
  Future<UserModel> getUserInfo() async {
    final userData = await _firestore
        .collection(FirebaseCollectionNames.users)
        .doc(_auth.currentUser!.uid)
        .get();

    final user = UserModel.fromMap(userData.data()!);
    return user;
  }

  Future<void> updateProfilePicture({required File image}) async {
    try {
      final path = _storage
          .ref(StorageFolderNames.profilePics)
          .child(_auth.currentUser!.uid);

      final taskSnapshot = await path.putFile(image);
      final downloadUrl = await taskSnapshot.ref.getDownloadURL();

      await _firestore
          .collection(FirebaseCollectionNames.users)
          .doc(_auth.currentUser!.uid)
          .update({FirebaseFieldNames.profilePicUrl: downloadUrl});

      showToastMessage(text: 'successfully updated profile photo!');
    } catch (e) {
      showToastMessage(text: e.toString());
    }
  }

  Future<void> updateProfileName({required String name}) async{
    try{
      await _firestore.collection(FirebaseCollectionNames.users).doc(_auth.currentUser!.uid).update(
          {FirebaseFieldNames.name:name});
      showToastMessage(text: 'successfully updated name');
    }catch(e){
      showToastMessage(text: e.toString());
    }
  }

}
