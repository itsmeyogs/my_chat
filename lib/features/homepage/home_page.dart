import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:my_chat/features/auth/providers/auth_provider.dart';
import 'package:my_chat/features/homepage/add_chat_page.dart';
import 'package:my_chat/features/homepage/chat_list.dart';
import 'package:my_chat/features/homepage/widget/icon_button_app_bar.dart';
import 'package:my_chat/features/profile/profile_page.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  static const routeName = '/home';

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  late TextEditingController _searchController;
  late FocusNode _focusNode;
  bool _searchClicked = false;
  bool _pinnedAppBar = false;

  @override
  void initState() {
    _searchController = TextEditingController();
    _focusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

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
            pinned: _pinnedAppBar,
            title: _searchClicked ? TextField(
                    controller: _searchController,
                    focusNode: _focusNode,
                    onChanged: (value){
                      setState(()=>_searchController.text=value);
                    },
                    keyboardType: TextInputType.name,
                    decoration: InputDecoration(
                        hintText: "Search..",
                        contentPadding: const EdgeInsets.only(
                            left: 20, top: 10, bottom: 10),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(40)),
                        prefixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _searchClicked = false;
                                _pinnedAppBar = false;
                              });
                            },
                            icon: const Icon(Icons.arrow_back)
                        ),
                      suffixIcon: _searchController.text.isNotEmpty?IconButton(
                          onPressed: () {
                            setState(() {
                              _searchController.clear();
                            });
                          },
                          icon: const Icon(Icons.clear)
                      ):null
                    )
            ) : const Text("My Chat"),
            actions: [
              _searchClicked
                  ? Container()
                  : Row(
                      children: [
                        IconButtonAppBar(
                            onPressed: () {}, icon: Icons.camera_alt_outlined),
                        const SizedBox(width: 16),
                        IconButtonAppBar(
                            onPressed: () {
                              setState(() {
                                _searchClicked = true;
                                _pinnedAppBar = true;
                                _focusNode.requestFocus();
                              });
                            },
                            icon: Icons.search),
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
                                    onTap: () {
                                      ref.read(authProvider).logout();
                                    },
                                    child: const Text('Log Out'))
                              ];
                            })
                      ],
                    )
            ],
          ),
          const ChatList()
        ],
      ),
    );
  }
}
