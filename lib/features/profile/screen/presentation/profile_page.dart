import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:my_chat/core/utils/utils.dart';
import 'package:my_chat/features/auth/screen/widget/round_button.dart';
import 'package:my_chat/features/profile/screen/widget/pick_image_widget.dart';
import 'package:my_chat/core/providers/user_provider.dart';
import 'package:my_chat/features/profile/screen/presentation/change_password_page.dart';
import 'package:my_chat/features/utils/loader.dart';
import 'package:my_chat/features/profile/screen/widget/bottom_sheet_edit_name.dart';


//widget ini digunakan untuk menampilkan profile user saat ini
class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  static const routeName = '/profile';

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  //variabel image untuk menampung gambar jika terjadi perubahan foto profil
  File? image;
  //variabel isloading untuk mengatur loading
  bool isLoading = false;

  //controller untuk name
  final TextEditingController _nameController = TextEditingController();


  //function untuk update foto profile
  Future<void> updateProfilePicture(File? image) async {
    //mengecek apakah image tidak sama dengan null
    if (image != null) {
      //mengatur loading = true
      setState(() => isLoading = true);
      //menjalankan fungsi update foto profile di userRepository
      await ref.read(userProvider).updateProfilePicture(image: image);
      ////mengatur loading = false
      setState(() => isLoading = false);
    }
  }

  //function untuk update nama profil
  Future<void> updateProfileName(String name) async {
    //mengatur loading = true
    setState(() => isLoading = true);
    //menjalankan fungsi update nama di userRepository
    await ref.read(userProvider).updateProfileName(name: name);
    //mengatur loading = false
    setState(() => isLoading = false);
    //menekan tombol kembali untuk menutup bottomsheet
    Navigator.pop(context);

  }

  @override
  Widget build(BuildContext context) {
    //mendapatkan size dari screen
    final screen = MediaQuery.of(context).size;
    return FutureBuilder(
        //mendapatkan data dari function getUserInfo di userRepository
        future: ref.read(userProvider).getUserInfo(),
        builder: (context, snapshot) {
          //jika data tidak kosong
          if (snapshot.hasData) {
            final user = snapshot.data!;
            //mengisi controller name dengan nama saat ini
            _nameController.text = user.name;
            //menampilkan scaffold
            return Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.blueGrey[600],
                foregroundColor: Colors.white,
                title: const Text("Profile", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),),
                centerTitle: true,
              ),
              //jika isloading true menampilkan loading
              body: isLoading? const Loader():
                  //jika false maka menampilkan SingleChildScrollview untuk menampiklan data
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 30,
                    ),
                    //meanmpilkan foto profil
                    Center(
                      child: PickImageWidget(
                          onPressed: () async {
                            //jika diklik maka akan membuka galeri
                            image = await pickImage();
                            //kemudian dijalankan fungsi untuk update foto profile
                            await updateProfilePicture(image);
                          },
                          image: image,
                          currentImage: user.profilePicUrl),
                    ),
                    const SizedBox(
                      height: 32,
                    ),
                    //menampilkan nama user, yang mana jika diklik maka akan menampilkan bottom sheet edit nama
                    InkWell(
                      onTap: () {
                        showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius
                                  .zero, // Set all corner radii to zero
                            ),
                            builder: (BuildContext context) {
                              return Container(
                                  padding: EdgeInsets.only(
                                    bottom: MediaQuery.of(context)
                                        .viewInsets
                                        .bottom,
                                  ),
                                  //menampilkan bottom sheet edit nama
                                  child: BottomSheetEditName(
                                      nameController: _nameController,
                                      onCancelPressed: (){
                                        //jika diklik cancel maka akan kembali untuk menutup bottomsheet
                                        Navigator.pop(context);
                                      },
                                      onSavePressed: () async {
                                        //jika diklik save
                                        final name = _nameController.text;
                                        //dicek apakah nama tidak sama dengan nama saat ini
                                        if (name != user.name) {
                                          //jika true maka dijalankan fungsi update nama
                                          updateProfileName(name);
                                          //jika false maka akan kembali untuk menutup bottomsheet
                                        } else {
                                          Navigator.pop(context);
                                        }
                                      }));
                            });
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8, bottom: 8),
                        child: Row(
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(left: 24, right: 16),
                              child: FaIcon(
                                FontAwesomeIcons.user,
                                color: Colors.blueGrey,
                                size: 21,
                              ),
                            ),
                            const SizedBox(width: 16.0),
                            //menampilkan nama user
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Name",
                                  style: TextStyle(
                                      fontSize: 14.0, color: Colors.blueGrey),
                                ),
                                Text(
                                  user.name,
                                  style: const TextStyle(fontSize: 18.0),
                                ),
                              ],
                            ),
                            const Spacer(),
                            const Padding(
                              padding: EdgeInsets.only(right: 24),
                              child: FaIcon(
                                FontAwesomeIcons.pencil,
                                color: Colors.blueGrey,
                                size: 21,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    //meanmpilkan email user
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Row(
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(left: 24, right: 16),
                            child: FaIcon(
                              FontAwesomeIcons.envelope,
                              color: Colors.blueGrey,
                              size: 21,
                            ),
                          ),
                          const SizedBox(width: 16.0),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Email",
                                style: TextStyle(
                                    fontSize: 14.0, color: Colors.blueGrey),
                              ),
                              Text(
                                user.email,
                                style: const TextStyle(fontSize: 18.0),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 200,
                    ),
                    //button untuk mengganti password dan akan berpindah ke halaman ganti password
                    SizedBox(
                        width: screen.width,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 24, right:24),
                          child: RoundButton(
                              onPressed: () {
                                Navigator.of(context).pushNamed(
                                  ChangePasswordPage.routeName,
                                  arguments: {
                                    'currentPassword': user.password,
                                  },
                                );
                              },
                              label: "Change Password",
                              labelSize: 16),
                        )),
                    const SizedBox(height: 10,),
                    //button untuk logout
                    SizedBox(
                        width: screen.width,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 24, right:24),
                          child: RoundButton(
                              onPressed: () async{
                                setState(()=>isLoading=true);
                                await ref.read(userProvider).logout();
                                setState(()=>isLoading=true);
                                Navigator.pop(context);
                              },
                              label: "Log Out",
                              labelSize: 16),
                        )),
                  ],
                ),
              )
            );
          }
          return const Loader();
        }
    );
  }
}
