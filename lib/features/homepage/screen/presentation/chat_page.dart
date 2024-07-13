import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_chat/core/providers/chat_provider.dart';
import 'package:my_chat/features/homepage/screen/widget/user_widget.dart';
import 'package:my_chat/features/utils/loader.dart';

import '../widget/message_list.dart';

class ChatPage extends ConsumerStatefulWidget {
  const ChatPage({super.key, required this.userId});

  final String userId;

  static const routeName = '/chat_page';

  @override
  ConsumerState<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends ConsumerState<ChatPage> {
  late final TextEditingController messageController;
  late final String chatroomId;

  @override
  void initState() {
    messageController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: ref.watch(chatProvider).createChatroom(userId: widget.userId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Loader();
          }

          chatroomId = snapshot.data ?? 'No chatroom Id';

          return Scaffold(
            backgroundColor: Colors.blueGrey[100],
            appBar: AppBar(
              backgroundColor: Colors.blueGrey[600],
              foregroundColor: Colors.white,
              title: UserWidget(userId: widget.userId),
              centerTitle: true,
            ),
            body: Column(
              children: [
                Expanded(child: MessagesList(chatroomId: chatroomId)),
                _buildMessageInput()
              ],
            ),
          );
        });
  }

  // Chat Text Field
  Widget _buildMessageInput() {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(width: 0.2, color: Colors.blueGrey)
        )
      ),
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          // Text Field
          Expanded(
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white70,
                borderRadius: BorderRadius.circular(15),
              ),
              child: TextField(
                controller: messageController,
                decoration: const InputDecoration(
                  hintText: 'Aa',
                  hintStyle: TextStyle(),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.only(
                    left: 20,
                    bottom: 10,
                  ),
                ),
                textInputAction: TextInputAction.done,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(
              Icons.send,
              color: Colors.blueGrey,
            ),
            onPressed: () async {
              // mengirimkan pesan ketika ditekan icon send
              if(messageController.text.isNotEmpty){
                await ref.read(chatProvider).sendMessage(
                  message: messageController.text,
                  chatroomId: chatroomId,
                  receiverId: widget.userId,
                );
              }
              messageController.clear();
            },
          ),
        ],
      ),
    );
  }
}
