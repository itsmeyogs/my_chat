
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:my_chat/core/constants/firebase_collection_names.dart';
import 'package:my_chat/core/constants/firebase_field_names.dart';
import 'package:my_chat/core/models/chatroom.dart';
import 'package:my_chat/core/models/message.dart';
import 'package:uuid/uuid.dart';

import '../models/user_model.dart';


//class ini digunakan untuk memanajemen data(function) yang berhubungan dengan chat
@immutable
class ChatRepository {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  //function untuk mencari user berdasarkan email(untuk add chat baru)
  Future<UserModel?> searchUser({required String email}) async {
    try{
      //mengecek jika tidak sama dengan email user saat ini
      if (email != _auth.currentUser!.email) {
        final userData = await _firestore
            .collection(FirebaseCollectionNames.users)
            .where("email", isEqualTo: email)
            .get();
        final data = userData.docs.first.data();
        //mengecek apakah hasil tidak kosong
        if(data.isNotEmpty){
          final user = UserModel.fromMap(userData.docs.first.data());
          return user;
        }
      }
      //jika tidak maka direturn null
      return null;
    }catch(e){
      return null;
    }

  }

  //function untuk membuat chatroom baru
  Future<String> createChatroom({
    required String userId,
  }) async {
    try {
      //membuat instance firestore dari collection chatrooms
      CollectionReference chatrooms = FirebaseFirestore.instance.collection(
        FirebaseCollectionNames.chatrooms,
      );

      //mengurutkan id user yang ada di chatrooms
      final sortedMembers = [_auth.currentUser!.uid, userId]
        ..sort((a, b) => a.compareTo(b));

      //mengecek apakah chatrooms dengan id user yang sama sudah ada
      QuerySnapshot existingChatrooms = await chatrooms
          .where(
            FirebaseFieldNames.members,
            isEqualTo: sortedMembers,
          ).get();
      if (existingChatrooms.docs.isNotEmpty) {
        //jika sudah ada maka akan mereturn id dari chatrooms
        return existingChatrooms.docs.first.id;
      } else {
        //jika belum ada maka dibuat id chatrooms baru dengan id yang dibuat dari library Uuid()
        final chatroomId = const Uuid().v1();
        final now = DateTime.now();

        //membuat objek baru dari model class Chatrooms
        Chatroom chatroom = Chatroom(
          chatroomId: chatroomId,
          lastMessage: '',
          lastMessageTs: now,
          members: sortedMembers,
          createdAt: now,
        );

        //menambahkan data baru dari objek yang sudah dibuat pada collection chatrooms di firestore
        await FirebaseFirestore.instance
            .collection(FirebaseCollectionNames.chatrooms)
            .doc(chatroomId)
            .set(chatroom.toMap());

        //mengembalikan id chatroom
        return chatroomId;
      }
    } catch (e) {
      return e.toString();
    }
  }

  //function untuk mengirimkan pesan
  Future<String?> sendMessage({
    required String message,
    required String chatroomId,
    required String receiverId,
  }) async {
    try {
      //membuat id message yang dibuat dengan library Uuid
      final messageId = const Uuid().v1();
      final now = DateTime.now();

      //membuat objek baru dari model class Message
      Message newMessage = Message(
        message: message,
        messageId: messageId,
        senderId: _auth.currentUser!.uid,
        receiverId: receiverId,
        timestamp: now,
        seen: false,
      );

      //membuat instance dari collection chatrooms pada doc/field berdasarkan id chatroom
      DocumentReference myChatroomRef = FirebaseFirestore.instance
          .collection(FirebaseCollectionNames.chatrooms)
          .doc(chatroomId);

      //menambahkan collection message dan data message pada collection chatrooms firestore
      await myChatroomRef
          .collection(FirebaseCollectionNames.messages)
          .doc(messageId)
          .set(newMessage.toMap());

      //mengupdate lastMessageTime dan LastMessage TimeStamp pada collection chatrooms
      await myChatroomRef.update({
        FirebaseFieldNames.lastMessage: message,
        FirebaseFieldNames.lastMessageTs: now.millisecondsSinceEpoch,
      });

      return null;
    } catch (e) {
      return e.toString();
    }
  }

  //function untuk mengupdate bahwa pesan sudah dilihat
  Future<String?> seenMessage({
    required String chatroomId,
    required String messageId,
  }) async {
    try {
      //mengupdate seen menjadi true pada collection
      await FirebaseFirestore.instance
          .collection(FirebaseCollectionNames.chatrooms)
          .doc(chatroomId)
          .collection(FirebaseCollectionNames.messages)
          .doc(messageId)
          .update({
        FirebaseFieldNames.seen: true,
      });

      return null;
    } catch (e) {
      return e.toString();
    }
  }

  //function untuk mendapatkan foto profil dari pengirim pesan
  Future<String> getPicProfileSenderMessage({required String userId}) async {
    final userData = await _firestore.collection(FirebaseCollectionNames.users).where("uid", isEqualTo: userId).get();
    final pic = UserModel.fromMap(userData.docs.first.data()).profilePicUrl;
    return pic;
  }
}
