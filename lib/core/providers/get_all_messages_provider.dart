import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_chat/core/constants/firebase_field_names.dart';
import 'package:my_chat/core/models/message.dart';

import '../constants/firebase_collection_names.dart';

//provider untuk mengambil data semua message yang ada di firestore
final getAllMessagesProvider =
StreamProvider.autoDispose.family<Iterable<Message>, String>((ref, String chatroomId) {

  final controller = StreamController<Iterable<Message>>();

  final sub = FirebaseFirestore.instance
      .collection(FirebaseCollectionNames.chatrooms)
      .doc(chatroomId)
      .collection(FirebaseCollectionNames.messages)
      .orderBy(FirebaseFieldNames.timestamp)
      .snapshots()
      .listen((snapshot) {
    final messages = snapshot.docs.map(
          (messageData) => Message.fromMap(
        messageData.data(),
      ),
    );
    controller.sink.add(messages);
  });

  ref.onDispose(() {
    controller.close();
    sub.cancel();
  });

  return controller.stream;
});