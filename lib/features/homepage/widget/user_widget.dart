import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_chat/features/auth/providers/get_user_info_by_id_provider.dart';

import '../../error_screen.dart';
import '../../loader.dart';

class UserWidget extends ConsumerWidget {
  const UserWidget({super.key, required this.userId});

  final String userId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userInfo = ref.watch(getUserInfoByIdProvider(userId));

    return userInfo.when(data: (user) {
      return Row(
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(user.profilePicUrl),
            radius: 24,
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                user.name,
                style: const TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                user.email,
                style: const TextStyle(
                  fontSize: 14.0,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ],
      );
    }, error: (error, stackTrace) {
      return ErrorScreen(error: error.toString());
    }, loading: () {
      return const Loader();
    });
  }
}
