import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:my_chat/features/homepage/screen/presentation/add_chat_page.dart';
import 'package:my_chat/features/homepage/screen/presentation/chat_list.dart';
import 'package:my_chat/features/profile/screen/presentation/profile_page.dart';

//widget untuk meanmpilkan home page
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
      //menambahkan floating action button yang jika diklik maka akan berpindah ke halaman add chat
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueGrey,
        foregroundColor: Colors.white,
        onPressed: () {
          Navigator.of(context).pushNamed(AddChatPage.routeName);
        },
        child: const FaIcon(FontAwesomeIcons.plus),
      ),
      body: CustomScrollView(
        slivers: [
          //menampilkan app bar
          SliverAppBar(
            backgroundColor: Colors.blueGrey[600],
            foregroundColor: Colors.white,
            floating: true,
            title: const Text("MyChat", style: TextStyle(fontWeight: FontWeight.w700,fontSize: 20)),
            actions: [
              //menambahkan icon button di bagian kanan appbar yang digunakan untuk berpindah ke halaman profile
              IconButton(onPressed: (){
                Navigator.of(context).pushNamed(ProfilePage.routeName);
              }, icon: const Icon(Icons.person))
            ],
          ),
          //menampilkan chatlist
          const ChatList()
        ],
      ),
    );
  }
}
