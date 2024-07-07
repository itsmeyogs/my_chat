import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_chat/features/homepage/providers/chat_provider.dart';

import 'message_contents.dart';
import 'models/message.dart';

class ReceivedMessage extends ConsumerStatefulWidget {
  final Message message;

  const ReceivedMessage({
    super.key,
    required this.message,
  });

  @override
  ConsumerState<ReceivedMessage> createState() => _ReceivedMessageState();
}
class _ReceivedMessageState extends ConsumerState<ReceivedMessage> {
  String profilePic="";

  Future<void> getProfilePic(String userId) async{
    final pic = await ref.read(chatProvider).getPicReceivedMessage(userId: userId);
    setState(()=>profilePic=pic );
  }

  @override
  void initState() {
    getProfilePic(widget.message.receiverId);
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 8.0,
            ),
            child: CircleAvatar(
              radius: 20,
              backgroundColor: Colors.grey,
              backgroundImage: NetworkImage(profilePic),
            ),
          ),
          const SizedBox(width: 15),
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(12.0),
              decoration: const BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: MessageContents(message: widget.message),
            ),
          ),
        ],
      ),
    );
  }
}