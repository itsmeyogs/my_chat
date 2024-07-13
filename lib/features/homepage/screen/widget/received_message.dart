import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_chat/core/providers/chat_provider.dart';

import 'message_contents.dart';
import '../../../../core/models/message.dart';

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
            child: FutureBuilder(future: ref.read(chatProvider).getPicProfileSenderMessage(userId: message.senderId),builder: (context, snapshot){
              if(snapshot.hasData){
                final receivedProfile = snapshot.data!;
                return CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.white70,
                  backgroundImage: NetworkImage(receivedProfile),
                );
              }
              return const CircleAvatar(
                radius: 20,
                backgroundColor: Colors.white70,
                backgroundImage: AssetImage('images/profile_default.png'),
              );
            },),
          ),
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(6.0),
              decoration: const BoxDecoration(
                color: Colors.white70,
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