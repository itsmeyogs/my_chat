import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_chat/core/constants/extensions.dart';
import 'package:my_chat/features/homepage/screen/presentation/chat_page.dart';

import '../../../../core/providers/get_user_info_by_id_provider.dart';

//widget untuk menampilkan informasi chat list
class ChatTile extends ConsumerStatefulWidget {
  const ChatTile({
    super.key,
    required this.userId,
    required this.lastMessage,
    required this.lastMessageTs,
    required this.chatroomId,
  });

  final String userId;
  final String lastMessage;
  final DateTime lastMessageTs;
  final String chatroomId;

  @override
  ConsumerState<ChatTile> createState() => _ChatTileState();
}

class _ChatTileState extends ConsumerState<ChatTile> {
  @override
  Widget build(BuildContext context) {
    //mendapatkan data user by id dari provider
    final userInfo = ref.watch(getUserInfoByIdProvider(widget.userId));

    return userInfo.when(
      //ketika data user ada
      data: (user) {
        //ditambahkan inkwell agar ketika diklik maka akan berpindah ke halaman chat page
        return InkWell(
          onTap: () {
            Navigator.of(context).pushNamed(
              ChatPage.routeName,
              arguments: {
                'userId': widget.userId,
              },
            );
          },
          child: Padding(
            padding: const EdgeInsets.only(left: 12,right: 12, top: 8, bottom: 8),
            child: Row(
              children: [
                // menampilkan profile picture
                CircleAvatar(
                  radius: 25,
                  backgroundImage: NetworkImage(user.profilePicUrl),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Name
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          //menampilkan nama
                          Text(
                            user.name,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            //menampilkan waktu pesan terakhir
                            widget.lastMessageTs.jm(),
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                      // Last Message + Ts
                      Text(
                        //menampilkan pesan terakhir
                        widget.lastMessage,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
      //meanmpilkan error
      error: (error, stackTrace) {
        return Container(
          width: double.infinity,
          height: 50,
          color: Colors.grey,
          child: Center(
            child: Text(error.toString()),
          ),
        );
      },
      //menampilkan loading
      loading: () {
        return Container();
      },
    );
  }
}