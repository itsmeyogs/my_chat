import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_chat/core/providers/chat_provider.dart';
import 'package:my_chat/features/homepage/screen/widget/user_widget.dart';
import 'package:my_chat/features/utils/loader.dart';

import '../../../../core/models/user_model.dart';
import 'chat_page.dart';

//widget untuk halaman add chat
class AddChatPage extends ConsumerStatefulWidget {
  const AddChatPage({super.key});

  static const routeName = '/add_chat';

  @override
  ConsumerState<AddChatPage> createState() => _AddChatState();
}

class _AddChatState extends ConsumerState<AddChatPage> {
  //controller search user
  late TextEditingController _searchUserController;

  //mengatur loading pada halaman
  bool isLoading = false;

  //variabel untuk menampung hasil pencarian
  UserModel? searchResult;

  //mengatur apakah sudah dicari atau belum
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

  //function untuk search user berdasarkan email
  Future<void> searchUser(String email) async {
    //mengecek apakah email tidak kosong
    if (email.isNotEmpty) {
      //mengatur loading menjadi true
      setState(() => isLoading = true);
      //memanggil function search user pada chatRepository dengan parameter email
      final search =
          await ref.read(chatProvider).searchUser(email: email.toLowerCase());
      setState(() {
        //mengatur loading menjadi false
        isLoading = false;
        //mengatur isSearched menjadi true, untuk penanda jika sudah dilakukan pencarian
        isSearched = true;
        //menambahkan hasil pencarian ke searchResult
        searchResult = search;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey[600],
        foregroundColor: Colors.white,
        title: const Text(
          'Add Chat',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
        ),
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
                    //mengatur ketika terjadi perubahan pada textfield maka akan otomatis dilakukan pencarian
                    searchUser(value);
                    //jika value dari textfield berupa ""
                    if (value == "") {
                      setState(() {
                        //maka dihapus isi dari controller search user
                        _searchUserController.clear();
                        //dan isSearched diubah menjadi false
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
                      //megatur ikon jika textfield tidak kosong
                      suffixIcon: _searchUserController.text.isNotEmpty
                          // maka icon yang akan ditampilkan berupa iconbutton untuk menghapus isi dari textfield
                          ? IconButton(
                              onPressed: () {
                                setState(() {
                                  _searchUserController.clear();
                                  isSearched = false;
                                });
                              },
                              icon: const Icon(Icons.clear))
                          //dan jika false maka akan menampilkan icon berupa search
                          : const Icon(Icons.search)
                  )
              ),
              //menambahkan jarak vertical sebanyak 20
              const SizedBox(height: 20),
              //jika loading berupa true
              isLoading
                  //maka ditampilkan loading
                  ? const Padding(
                      padding: EdgeInsets.only(top: 45),
                      child: Loader(),
                    )
                  //jika false, maka dicek lagi apakah isSearched = true
                  : isSearched
                      //jika iya maka akan menampilkan teks berupa result
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
                            //dicek lagi jika searchResult tidak sama dengan null
                            searchResult != null
                                //jika iya maka akan ditampilkan nama user, dan jika diklik maka akan berpindah ke halaman chat page
                                ? Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: InkWell(
                                        onTap: () {
                                          Navigator.of(context).pushNamed(
                                            ChatPage.routeName,
                                            arguments: {
                                              'userId': searchResult!.uid,
                                            },
                                          );
                                        },
                                        child: UserWidget(
                                            userId: searchResult!.uid)),
                                  )
                                //jika data searchResult =  null, maka ditampilkan teks berupa users not found
                                : const Padding(
                                    padding: EdgeInsets.only(top: 20),
                                    child:
                                        Center(child: Text("User not found!")),
                                  )
                          ],
                        )
                      //jika isSearched = false maka ditampilkan container(kosong)
                      : Container(),
            ],
          ),
        ),
      ),
    );
  }
}
