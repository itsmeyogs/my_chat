import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_chat/core/providers/chat_provider.dart';
import 'package:my_chat/core/providers/get_all_messages_provider.dart';
import 'package:my_chat/features/homepage/screen/widget/received_message.dart';
import 'package:my_chat/features/homepage/screen/widget/sent_message.dart';

import '../../../utils/error_screen.dart';
import '../../../utils/loader.dart';

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
    _scrollController=ScrollController();
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.extentTotal,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final messagesList = ref.watch(getAllMessagesProvider(widget.chatroomId));
    return messagesList.when(
      data: (messages) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _scrollToBottom();
        });
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

