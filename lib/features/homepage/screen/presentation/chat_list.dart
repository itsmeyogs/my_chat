import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_chat/features/utils/error_screen.dart';
import 'package:my_chat/core/providers/get_all_chats_provider.dart';
import 'package:my_chat/features/utils/loader.dart';

import '../../../../core/constants/app_message.dart';
import '../widget/chat_tile.dart';

// Widget ini untuk menampilkan list chat
class ChatList extends ConsumerStatefulWidget {
  const ChatList({super.key});

  @override
  ConsumerState<ChatList> createState() => _ChatListState();
}

class _ChatListState extends ConsumerState<ChatList> {
  @override
  Widget build(BuildContext context) {
    // mendapatkan data chat dari provider
    final chatsList = ref.watch(getAllChatsProvider);
    // mendapatkan UID pengguna saat ini
    final myUid = FirebaseAuth.instance.currentUser!.uid;

    return chatsList.when(
      // ketika data chat tersedia
      data: (chats) {
        // Periksa apakah chats tidak kosong
        if (chats.isNotEmpty) {
          //menampilkan list chat
          return SliverList.builder(
              itemCount: chats.length,
              itemBuilder: (context, index) {
                // mengakses data chat dengan discending(agar message terbaru posisinya diatas)
                final reservedIndex = chats.length - 1 - index;
                // Ambil data chat pada index tertentu
                final chat = chats.elementAt(reservedIndex);
                //mendapatkan chatrooms yang idnya tidak sama dengan id user saat ini
                final userId = chat.members.firstWhere((userId) => userId != myUid);
                //menampilkan chat tile
                return ChatTile(
                    userId: userId,
                    lastMessage: chat.lastMessage,
                    lastMessageTs: chat.lastMessageTs,
                    chatroomId: chat.chatroomId);
              });
        }

        // Jika tidak ada chat tampilkan pesan tidak ada chat
        return const SliverToBoxAdapter(
          child: (
              Column(
                children: [
                  SizedBox(height: 30,),
                  Text(AppMessage.noChatMessage)
                ],
              )
          ),
        );
      },
      //jika error maka akan menampilkan layar error
      error: (error, stackTrace) {
        return SliverToBoxAdapter(child: ErrorScreen(error: error.toString()));
      },
      //jika kondisi sedang loang, maka ditampilkan loading
      loading: () {
        return const SliverToBoxAdapter(child: Column(
          children: [
            SizedBox(height: 20,),
            Loader(),
          ],
        ));
      },
    );
  }
}
