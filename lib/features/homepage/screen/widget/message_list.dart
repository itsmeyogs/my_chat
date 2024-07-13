import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_chat/core/providers/chat_provider.dart';
import 'package:my_chat/core/providers/get_all_messages_provider.dart';
import 'package:my_chat/features/homepage/screen/widget/received_message.dart';
import 'package:my_chat/features/homepage/screen/widget/sent_message.dart';

import '../../../utils/error_screen.dart';
import '../../../utils/loader.dart';

//widget ini digunakan untuk menampilkan semua list pesan
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
  //scroll controller untuk listbuilder
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

  //function agar otomatis scroll ke message paling bawah
  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
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
        //menjalankan function scrollbottom ketika halaman pertama kali dibuka, sehingga langsung scroll ke paling bawah
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _scrollToBottom();
        });
        //menampilkan list
        return ListView.builder(
          controller: _scrollController,
          itemCount: messages.length,
          itemBuilder: (context, index) {
            // Ambil data message pada index tertentu
            final message = messages.elementAt(index);

            //mengecek apakah id dari message sender sama dengan id user saat ini
            final isMyMessage = message.senderId == FirebaseAuth.instance.currentUser!.uid;

            //jika tidak maka dijalankan function untuk mengupdate collection agar seen = true
            if (!isMyMessage) {
              ref.read(chatProvider).seenMessage(
                chatroomId: widget.chatroomId,
                messageId: message.messageId,
              );
            }

            //jika id dari message sender sama dengan id user saat ini
            if (isMyMessage) {
              //maka ditampilkan halaman sent message dengan parameter data message
              return SentMessage(message: message);
            } else {
              //maka ditampilkan halaman received message dengan parameter data message
              return ReceivedMessage(message: message);
            }
          },
        );
      },
      //menampilkan error
      error: (error, stackTrace) {
        return ErrorScreen(error: error.toString());
      },
      //menampilkan loading
      loading: () {
        return const Loader();
      },
    );
  }
}

