import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_chat/core/providers/chat_provider.dart';
import 'package:my_chat/features/homepage/screen/widget/user_widget.dart';
import 'package:my_chat/features/utils/loader.dart';

import '../widget/message_list.dart';

//widget untuk menampilkan chat page
class ChatPage extends ConsumerStatefulWidget {
  const ChatPage({super.key, required this.userId});

  final String userId;

  static const routeName = '/chat_page';

  @override
  ConsumerState<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends ConsumerState<ChatPage> {
  // controller untuk message
  late final TextEditingController messageController;

  // id chatroom
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
        //menjalankan fungsi future untuk membuat chatroom
        future: ref.watch(chatProvider).createChatroom(userId: widget.userId),
        builder: (context, snapshot) {
          // Tampilkan loading saat waiting
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Loader();
          }

          // mendapatkan id chatroom dari hasil pembuatan
          chatroomId = snapshot.data ?? 'No chatroom Id';

          return Scaffold(
            backgroundColor: Colors.blueGrey[100],
            appBar: AppBar(
              backgroundColor: Colors.blueGrey[600],
              foregroundColor: Colors.white,
              //menampilkan informasi orang yang sedang dichat
              title: UserWidget(userId: widget.userId),
              centerTitle: true,
            ),
            body: Column(
              children: [
                //menampilkan daftar pesan yang ada di chatroom
                Expanded(child: MessagesList(chatroomId: chatroomId)),
                //menampilkan bagian untuk input kirim pesan
                _buildMessageInput()
              ],
            ),
          );
        });
  }

  //widget menampilkan bagian untuk input kirim pesan
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
          // Text Field untuk memasukkan pesan
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
                textInputAction: TextInputAction.done, // Aksi saat menekan enter
              ),
            ),
          ),
          //icon button untuk mengirim pesan
          IconButton(
            icon: const Icon(
              Icons.send,
              color: Colors.blueGrey,
            ),
            onPressed: () async {
              // Kirim pesan ketika tombol send ditekan
              if(messageController.text.isNotEmpty){ // Periksa apakah pesan tidak kosong
                await ref.read(chatProvider).sendMessage( // Kirim pesan menggunakan provider
                  message: messageController.text,
                  chatroomId: chatroomId,
                  receiverId: widget.userId,
                );
              }
              messageController.clear(); // Kosongkan text field setelah kirim pesan
            },
          ),
        ],
      ),
    );
  }
}
