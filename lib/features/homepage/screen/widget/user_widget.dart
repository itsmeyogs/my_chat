import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_chat/core/providers/get_user_info_by_id_provider.dart';

import '../../../utils/error_screen.dart';
import '../../../utils/loader.dart';

//widget untuk menampilkan info dari user(untuk hasil dari halaman add chat dan untuk judul appbar di chatpage)
class UserWidget extends ConsumerWidget {
  const UserWidget({super.key, required this.userId});

  final String userId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //mendapatkan data user by id dari provider
    final userInfo = ref.watch(getUserInfoByIdProvider(userId));

    //jika data ada
    return userInfo.when(data: (user) {
      return Row(
        children: [
          //ditampilkan foto profile
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
                //ditampilkan nama
                user.name,
                style: const TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              //dan ditampilkan email
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
      //menampilkan error
    }, error: (error, stackTrace) {
      return ErrorScreen(error: error.toString());
    }, loading: () {
      //menampilkan loading
      return const Loader();
    });
  }
}
