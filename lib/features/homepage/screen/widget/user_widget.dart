import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_chat/core/providers/get_user_info_by_id_provider.dart';

import '../../../utils/error_screen.dart';
import '../../../utils/loader.dart';

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
            radius: 20,
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
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
