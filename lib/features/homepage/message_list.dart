import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_chat/features/homepage/providers/chat_provider.dart';
import 'package:my_chat/features/homepage/providers/get_all_messages_provider.dart';
import 'package:my_chat/features/homepage/received_message.dart';
import 'package:my_chat/features/homepage/sent_message.dart';

import '../error_screen.dart';
import '../loader.dart';

class MessagesList extends ConsumerWidget {
  const MessagesList({
    super.key,
    required this.chatroomId,
  });

  final String chatroomId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final messagesList = ref.watch(getAllMessagesProvider(chatroomId));

    return messagesList.when(
      data: (messages) {
        debugPrint("data: $messages ");
        return ListView.builder(
          reverse: true,
          itemCount: messages.length,
          itemBuilder: (context, index) {
            final message = messages.elementAt(index);
            final isMyMessage = message.senderId == FirebaseAuth.instance.currentUser!.uid;

            if (!isMyMessage) {
              ref.read(chatProvider).seenMessage(
                chatroomId: chatroomId,
                messageId: message.messageId,
              );
            }

            if (isMyMessage) {
              return SentMessage(message: message);
            } else {
              return ReceivedMessage(message: message);
            }
          },
        );
      },
      error: (error, stackTrace) {
        return ErrorScreen(error: error.toString());
      },
      loading: () {
        return const Loader();
      },
    );
  }
}

