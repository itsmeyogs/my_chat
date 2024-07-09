import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_chat/core/providers/chat_provider.dart';
import 'package:my_chat/features/homepage/screen/widget/user_widget.dart';
import 'package:my_chat/features/utils/loader.dart';

import '../../../../core/models/user_model.dart';
import 'chat_page.dart';

class AddChatPage extends ConsumerStatefulWidget {
  const AddChatPage({super.key});

  static const routeName = '/add_chat';

  @override
  ConsumerState<AddChatPage> createState() => _AddChatState();
}

class _AddChatState extends ConsumerState<AddChatPage> {
  late TextEditingController _searchUserController;
  bool isLoading = false;
  UserModel? searchResult;
  bool isSearched = false;

  @override
  void initState() {
    _searchUserController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _searchUserController.dispose();
    searchResult = null;
    super.dispose();
  }

  Future<void> searchUser(String email) async {
    if (email.isNotEmpty) {
      setState(() => isLoading = true);
      final search = await ref.read(chatProvider).searchUser(email: email);
      setState(() {
        isLoading = false;
        isSearched = true;
        searchResult = search;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Chat'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                  controller: _searchUserController,
                  onChanged: (value) async {
                    searchUser(value);
                    if (value == "") {
                      setState(() {
                        _searchUserController.clear();
                        isSearched = false;
                      });
                    }
                  },
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                      labelText: "Search Email Address",
                      contentPadding:
                          const EdgeInsets.only(left: 20, top: 15, bottom: 15),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(40)),
                      suffixIcon: _searchUserController.text.isNotEmpty
                          ? IconButton(
                              onPressed: () {
                                setState(() {
                                  _searchUserController.clear();
                                  isSearched = false;
                                });
                              },
                              icon: const Icon(Icons.clear))
                          : IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.search)
                      )
                  )
              ),
              const SizedBox(height: 20),
              isLoading
                  ? const Padding(
                      padding: EdgeInsets.only(top: 45),
                      child: Loader(),
                    )
                  : isSearched
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.all(4.0),
                              child: Text(
                                "Result",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ),
                            searchResult != null
                                ? InkWell(
                                    onTap: () {
                                      Navigator.of(context).pushNamed(
                                        ChatPage.routeName,
                                        arguments: {
                                          'userId': searchResult!.uid,
                                        },
                                      );
                                    },
                                    child:
                                        UserWidget(userId: searchResult!.uid))
                                : const Padding(
                                    padding: EdgeInsets.only(top: 20),
                                    child:
                                        Center(child: Text("User not found!")),
                                  )
                          ],
                        )
                      : Container(),
            ],
          ),
        ),
      ),
    );
  }
}
