import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:my_chat/core/constants/firebase_collection_names.dart';
import 'package:my_chat/core/constants/firebase_field_names.dart';
import 'package:my_chat/core/constants/storage_folder_names.dart';
import 'package:my_chat/core/models/user_model.dart';
import 'package:path_provider/path_provider.dart';

import '../constants/app_message.dart';
import '../utils/utils.dart';

//class ini digunakan untuk memanajemen data(function) yang berhubungan dengan user
class UserRepository {
  final _auth = FirebaseAuth.instance;
  final _storage = FirebaseStorage.instance;
  final _firestore = FirebaseFirestore.instance;

  //function ini digunakan untuk register user
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
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use'){
        showToastMessage(text: AppMessage.errorEmailAlreadyInUse);
      } else {
        showToastMessage(text: AppMessage.defaultError);
      }
      return null;
    }
  }

  //function ini digunakan untuk login user
  Future<UserCredential?> login({
    required String email,
    required String password,
  }) async {
    try {
      //mendapatkan kredensial dari sign in dengan email dan password
      final credential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      //me return kredensial yang didapatkan
      return credential;
    }catch (e) {
      showToastMessage(text: AppMessage.errorLogin);
      if (kDebugMode) {
        print(e.toString());
      }
      return null;
    }
  }

  //function ini digunakan untuk logout (menghapus sesi akun yang tersimpan saat ini)
  Future<void> logout() async {
    try {
      //menghapus sesi akun yang tersimpan saat ini(log out)
      await _auth.signOut();
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }


  //function ini digunakan untuk mengirimkan link verifikasi email pada email
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

  ///function untuk change email dari verify email page (menghapus akun yang sudah dibuat, dikarenakan ketika user register,
  ///maka otomatis data akan langsung tersimpan di firestore dan firebase auth(sehingga harus dihapus agar tidak ada sampah di databse))
  Future<void> changeAccountFromVerify() async{
    final currentUser = _auth.currentUser;
    try{
      if(currentUser!=null){
        //mendapatkan data email dan password user dari collection user pada firestore untuk mendapatkan kredensial ulang
        final userData = await _firestore
            .collection(FirebaseCollectionNames.users)
            .where("uid", isEqualTo: currentUser.uid)
            .get();
        final user = UserModel.fromMap(userData.docs.first.data());

        // mendapatkan kredensial ulang dengan email dan password
        final authCredential = EmailAuthProvider.credential(email: user.email, password: user.password);

        //menautentikasi ulang dengan kredensial yang sudah didapatkan sebelumnya
        await currentUser.reauthenticateWithCredential(authCredential);

        //menghapus foto profile yang ada di firebase storage
        await _storage.ref(StorageFolderNames.profilePics).child(user.uid).delete();

        //menghapus data user yang ada di firestore
        await _firestore.collection(FirebaseCollectionNames.users).doc(user.uid).delete();

        //menghapus data user dari firebase auth
        await currentUser.delete();

        //menghapus sesi akun yang tersimpan saat ini
        await _auth.signOut();
      }
    }catch(e){
      showToastMessage(text: e.toString());
    }
  }

  //function ini digunakan untuk mendapatkan data user (untuk ditampilkan pada profile page)
  Future<UserModel> getUserInfo() async {
    final userData = await _firestore
        .collection(FirebaseCollectionNames.users)
        .doc(_auth.currentUser!.uid)
        .get();

    final user = UserModel.fromMap(userData.data()!);
    return user;
  }

  //function untuk mengupdate foto profile user
  Future<void> updateProfilePicture({required File image}) async {
    final currentUser = _auth.currentUser;
    try {
      if(currentUser!=null){
        //mendapatkan path dari storage berdasarkan user id user
        final path = _storage
            .ref(StorageFolderNames.profilePics)
            .child(currentUser.uid);

        //mengupload foto profile baru ke firebase storage
        final taskSnapshot = await path.putFile(image);

        //mendapatkan link download dari foto profile
        final downloadUrl = await taskSnapshot.ref.getDownloadURL();

        //mengupdate linkfotoprofile pada collection user
        await _firestore
            .collection(FirebaseCollectionNames.users)
            .doc(currentUser.uid)
            .update({FirebaseFieldNames.profilePicUrl: downloadUrl});

        //menampilkan pesan bahwa sukses update photo profile
        showToastMessage(text: AppMessage.successUpdateProfilePic);
      }
    } catch(e){
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }

  //function ini untuk mengubah nama dari user
  Future<void> updateProfileName({required String name}) async{
    try{
      //mengupdate nama user pada collection user di firestore
      await _firestore.collection(FirebaseCollectionNames.users).doc(_auth.currentUser!.uid).update(
          {FirebaseFieldNames.name:name});
    }catch(e){
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }

  //function ini untuk mengubah password user
  Future<void> changePassword({required String newPassword}) async{
    final currentUser = _auth.currentUser;
    try{
      if(currentUser!=null){
        //mendapatkan data email dan password user dari collection user pada firestore untuk mendapatkan kredensial ulang
        final userData = await _firestore
            .collection(FirebaseCollectionNames.users)
            .where("uid", isEqualTo: currentUser.uid)
            .get();
        final user = UserModel.fromMap(userData.docs.first.data());

        // mendapatkan kredensial ulang dengan email dan password
        final authCredential = EmailAuthProvider.credential(email: user.email, password: user.password);

        //menautentikasi ulang dengan kredensial yang sudah didapatkan sebelumnya
        await currentUser.reauthenticateWithCredential(authCredential);

        //mengupdate password user dengan password baru
        await currentUser.updatePassword(newPassword);

        //menyimpan password baru kedalaman collection user di firestore
        await _firestore.collection(FirebaseCollectionNames.users).doc(_auth.currentUser!.uid).update(
            {FirebaseFieldNames.password:newPassword});

        //menampilkan pesan bahwa berhasil update password
        showToastMessage(text: AppMessage.successUpdatePassword);
      }
    }catch (e){
      showToastMessage(text: e.toString());
    }
  }


}
