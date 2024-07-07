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

class MessagesList extends ConsumerStatefulWidget {
  const MessagesList({
    super.key,
    required this.chatroomId,
  });

  final String chatroomId;

  @override
  ConsumerState<MessagesList> createState() => _MessagesListState();
}

class _MessagesListState extends ConsumerState<MessagesList> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        setState(() {
          _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
        });

      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final messagesList = ref.watch(getAllMessagesProvider(widget.chatroomId));

    return messagesList.when(
      data: (messages) {
        _scrollToBottom();
        return ListView.builder(
          controller: _scrollController,
          itemCount: messages.length,
          itemBuilder: (context, index) {
            final message = messages.elementAt(index);
            final isMyMessage = message.senderId == FirebaseAuth.instance.currentUser!.uid;

            if (!isMyMessage) {
              ref.read(chatProvider).seenMessage(
                chatroomId: widget.chatroomId,
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

