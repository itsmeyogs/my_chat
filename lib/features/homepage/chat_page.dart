import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:my_chat/features/homepage/home_page.dart';
import 'package:my_chat/features/homepage/providers/chat_provider.dart';
import 'package:my_chat/features/homepage/widget/user_widget.dart';
import 'package:my_chat/features/loader.dart';

import '../../core/utils/utils.dart';
import 'message_list.dart';

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

          return PopScope(
            canPop: false,
            onPopInvoked: (pop) async {
              // Navigate back to HomePage when back button is pressed
              Navigator.of(context).pushNamedAndRemoveUntil(
                HomePage.routeName,
                (route) => false,
              );
            },
            child: Scaffold(
              appBar: AppBar(
                title: UserWidget(userId: widget.userId),
                centerTitle: true,
              ),
              body: Column(
                children: [
                  Expanded(child: MessagesList(chatroomId: chatroomId)),
                  const Divider(),
                  _buildMessageInput()
                ],
              ),
            ),
          );
        });
  }

  // Chat Text Field
  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(
              Icons.image,
              color: Colors.grey,
            ),
            onPressed: () async {
              final image = await pickImage();
              if (image == null) return;
              await ref.read(chatProvider).sendFileMessage(
                    file: image,
                    chatroomId: chatroomId,
                    receiverId: widget.userId,
                    messageType: 'image',
                  );
            },
          ),
          IconButton(
            icon: const Icon(
              FontAwesomeIcons.video,
              color: Colors.grey,
              size: 20,
            ),
            onPressed: () async {
              final video = await pickVideo();
              if (video == null) return;
              await ref.read(chatProvider).sendFileMessage(
                    file: video,
                    chatroomId: chatroomId,
                    receiverId: widget.userId,
                    messageType: 'video',
                  );
            },
          ),
          // Text Field
          Expanded(
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                color: Colors.grey,
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
              color: Colors.grey,
            ),
            onPressed: () async {
              // Add functionality to handle send button press
              await ref.read(chatProvider).sendMessage(
                    message: messageController.text,
                    chatroomId: chatroomId,
                    receiverId: widget.userId,
                  );
              messageController.clear();
            },
          ),
        ],
      ),
    );
  }
}
