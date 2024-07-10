import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
// ignore: unnecessary_import
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_chat/features/utils/error_screen.dart';
import 'package:my_chat/core/providers/get_all_chats_provider.dart';
import 'package:my_chat/features/utils/loader.dart';

import '../../../../core/constants/app_message.dart';
import '../widget/chat_tile.dart';

class ChatList extends ConsumerStatefulWidget {
  const ChatList({super.key});

  @override
  ConsumerState<ChatList> createState() => _ChatListState();
}

class _ChatListState extends ConsumerState<ChatList> {
  @override
  Widget build(BuildContext context) {
    final chatsList = ref.watch(getAllChatsProvider);
    final myUid = FirebaseAuth.instance.currentUser!.uid;

    return chatsList.when(
      data: (chats) {
        if(chats.isNotEmpty){
          return SliverList.builder(
              itemCount: chats.length,
              itemBuilder: (context, index){
                final reservedIndex = chats.length -1 - index;
                final chat = chats.elementAt(reservedIndex);
                final userId =
                chat.members.firstWhere((userId) => userId != myUid);
                return ChatTile(
                    userId: userId,
                    lastMessage: chat.lastMessage,
                    lastMessageTs: chat.lastMessageTs,
                    chatroomId: chat.chatroomId);
              });
        }
        return const SliverToBoxAdapter(
          child:(
              Column(
                children: [
                  SizedBox(height:30,),
                  Text(AppMessage.noChatMessage)
                ],
              )
          ),
        );

      },
      error: (error, stackTrace) {
        return SliverToBoxAdapter(child: ErrorScreen(error: error.toString()));
      },
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
