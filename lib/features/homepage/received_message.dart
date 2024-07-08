import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_chat/features/homepage/providers/chat_provider.dart';

import 'message_contents.dart';
import 'models/message.dart';

class ReceivedMessage extends ConsumerWidget {
  const ReceivedMessage({
    super.key,
    required this.message,
  });

  final Message message;


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 8.0,
            ),
            child: FutureBuilder(future: ref.read(chatProvider).getPicReceivedMessage(userId: message.receiverId),builder: (context, snapshot){
              if(snapshot.hasData){
                final receivedProfile = snapshot.data!;
                return CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.grey,
                  backgroundImage: NetworkImage(receivedProfile),
                );
              }
              return const CircleAvatar(
                radius: 20,
                backgroundColor: Colors.grey,
                backgroundImage: AssetImage('images/profile_default.png'),
              );
            },),
          ),
          const SizedBox(width: 15),
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(6.0),
              decoration: const BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
              child: MessageContents(message: message),
            ),
          ),
        ],
      ),
    );
  }
}