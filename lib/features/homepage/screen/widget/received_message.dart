import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_chat/core/providers/chat_provider.dart';

import 'message_contents.dart';
import '../../../../core/models/message.dart';

//widget ini digunakan untuk mengatur tampilan dari pesan yang diterima
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
            child: FutureBuilder(
              //dialankan fungsi untuk mengambil foto profil dari pengirim pesan
              future: ref
                  .read(chatProvider)
                  .getPicProfileSenderMessage(userId: message.senderId),
              builder: (context, snapshot) {
                //jika data foto ada
                if (snapshot.hasData) {
                  final receivedProfile = snapshot.data!;
                  //ditampilkan foto dari pengirim pesan
                  return CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.white70,
                    backgroundImage: NetworkImage(receivedProfile),
                  );
                }
                //jika tidak ada maka akan ditampilkan foto profile default dari images
                return const CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.white70,
                  backgroundImage: AssetImage('images/profile_default.png'),
                );
              },
            ),
          ),
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(6.0),
              decoration: const BoxDecoration(
                color: Colors.white70,
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
              //menampilkan isi dari pesan
              child: MessageContents(message: message),
            ),
          ),
        ],
      ),
    );
  }
}
