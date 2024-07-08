import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_chat/core/constants/extensions.dart';
import 'package:my_chat/features/homepage/chat_page.dart';

import '../../auth/providers/get_user_info_by_id_provider.dart';


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
    final userInfo = ref.watch(getUserInfoByIdProvider(widget.userId));

    return userInfo.when(
      data: (user) {
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
                // Profile Pic
                CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage(user.profilePicUrl),
                ),
                const SizedBox(width: 10),
                // Column (Name + Last Message + Last Message Timetstamp)
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Name
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            user.name,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            widget.lastMessageTs.jm(),
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      // Last Message + Ts
                      Text(
                        widget.lastMessage,
                        style: const TextStyle(
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
      loading: () {
        return Container();
      },
    );
  }
}