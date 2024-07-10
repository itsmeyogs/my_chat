import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:my_chat/core/providers/user_provider.dart';
import 'package:my_chat/features/homepage/screen/presentation/add_chat_page.dart';
import 'package:my_chat/features/homepage/screen/presentation/chat_list.dart';
import 'package:my_chat/features/profile/screen/presentation/profile_page.dart';


class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  static const routeName = '/home';

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed(AddChatPage.routeName);
        },
        child: const FaIcon(FontAwesomeIcons.plus),
      ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            toolbarHeight: 70,
            floating: true,
            title: const Text("My Chat"),
            actions: [
              PopupMenuButton(
                  offset: const Offset(0, 45.0),
                  itemBuilder: (BuildContext context) {
                    return [
                      PopupMenuItem(
                          onTap: () {
                            Navigator.of(context)
                                .pushNamed(ProfilePage.routeName);
                          },
                          child: const Text('Profile')),
                      PopupMenuItem(
                          onTap: () async {
                            await ref.read(userProvider).logout();
                          },
                          child: const Text('Log Out'))
                    ];
                  })
            ],
          ),
          const ChatList()
        ],
      ),
    );
  }
}
