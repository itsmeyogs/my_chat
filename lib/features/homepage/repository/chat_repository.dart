import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:my_chat/core/constants/firebase_collection_names.dart';
import 'package:my_chat/core/constants/firebase_field_names.dart';
import 'package:my_chat/features/homepage/models/chatroom.dart';
import 'package:my_chat/features/homepage/models/message.dart';
import 'package:uuid/uuid.dart';

import '../../auth/models/user.dart';

@immutable
class ChatRepository {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  final _storage = FirebaseStorage.instance;

  //func search user
  Future<UserModel?> searchUser({required String email}) async {
    if (email != _auth.currentUser!.email) {
      final userData = await _firestore
          .collection(FirebaseCollectionNames.users)
          .where("email", isEqualTo: email)
          .get();
      final user = UserModel.fromMap(userData.docs.first.data());
      return user;
    }
    return null;
  }

  Future<String> createChatroom({
    required String userId,
  }) async {
    try {
      CollectionReference chatrooms = FirebaseFirestore.instance.collection(
        FirebaseCollectionNames.chatrooms,
      );
      // sorted members
      final sortedMembers = [_auth.currentUser!.uid, userId]
        ..sort((a, b) => a.compareTo(b));

      // existing chatrooms
      QuerySnapshot existingChatrooms = await chatrooms
          .where(
            FirebaseFieldNames.members,
            isEqualTo: sortedMembers,
          )
          .get();

      if (existingChatrooms.docs.isNotEmpty) {
        return existingChatrooms.docs.first.id;
      } else {
        final chatroomId = const Uuid().v1();
        final now = DateTime.now();

        Chatroom chatroom = Chatroom(
          chatroomId: chatroomId,
          lastMessage: '',
          lastMessageTs: now,
          members: sortedMembers,
          createdAt: now,
        );

        await FirebaseFirestore.instance
            .collection(FirebaseCollectionNames.chatrooms)
            .doc(chatroomId)
            .set(chatroom.toMap());

        return chatroomId;
      }
    } catch (e) {
      return e.toString();
    }
  }

  // Send message
  Future<String?> sendMessage({
    required String message,
    required String chatroomId,
    required String receiverId,
  }) async {
    try {
      final messageId = const Uuid().v1();
      final now = DateTime.now();

      Message newMessage = Message(
        message: message,
        messageId: messageId,
        senderId: _auth.currentUser!.uid,
        receiverId: receiverId,
        timestamp: now,
        seen: false,
        messageType: 'text',
      );

      DocumentReference myChatroomRef = FirebaseFirestore.instance
          .collection(FirebaseCollectionNames.chatrooms)
          .doc(chatroomId);

      await myChatroomRef
          .collection(FirebaseCollectionNames.messages)
          .doc(messageId)
          .set(newMessage.toMap());

      await myChatroomRef.update({
        FirebaseFieldNames.lastMessage: message,
        FirebaseFieldNames.lastMessageTs: now.millisecondsSinceEpoch,
      });

      return null;
    } catch (e) {
      return e.toString();
    }
  }

// Send message
  Future<String?> sendFileMessage({
    required File file,
    required String chatroomId,
    required String receiverId,
    required String messageType,
  }) async {
    try {
      final messageId = const Uuid().v1();
      final now = DateTime.now();

      // Save to storage
      Reference ref = _storage.ref(messageType).child(messageId);
      TaskSnapshot snapshot = await ref.putFile(file);
      final downloadUrl = await snapshot.ref.getDownloadURL();

      Message newMessage = Message(
        message: downloadUrl,
        messageId: messageId,
        senderId: _auth.currentUser!.uid,
        receiverId: receiverId,
        timestamp: now,
        seen: false,
        messageType: messageType,
      );

      DocumentReference myChatroomRef = FirebaseFirestore.instance
          .collection(FirebaseCollectionNames.chatrooms)
          .doc(chatroomId);

      await myChatroomRef
          .collection(FirebaseCollectionNames.messages)
          .doc(messageId)
          .set(newMessage.toMap());

      await myChatroomRef.update({
        FirebaseFieldNames.lastMessage: 'send a $messageType',
        FirebaseFieldNames.lastMessageTs: now.millisecondsSinceEpoch,
      });

      return null;
    } catch (e) {
      return e.toString();
    }
  }

  Future<String?> seenMessage({
    required String chatroomId,
    required String messageId,
  }) async {
    try {
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

  Future<String> getPicReceivedMessage({required String userId}) async {
    final userData = await _firestore.collection(FirebaseCollectionNames.users).where("uid", isEqualTo: userId).get();
    final pic = UserModel.fromMap(userData.docs.first.data()).profilePicUrl;
    return pic;
  }
}
