import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:my_chat/core/utils/utils.dart';
import 'package:my_chat/features/auth/screen/widget/round_button.dart';
import 'package:my_chat/features/auth/screen/widget/pick_image_widget.dart';
import 'package:my_chat/core/providers/user_provider.dart';
import 'package:my_chat/features/profile/screen/presentation/change_password_page.dart';
import 'package:my_chat/features/utils/loader.dart';
import 'package:my_chat/features/profile/screen/widget/bottom_sheet_edit_name.dart';


class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  static const routeName = '/profile';

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  File? image;
  bool isLoading = false;
  final TextEditingController _nameController = TextEditingController();

  Future<void> updateProfilePicture(File? image) async {
    if (image != null) {
      setState(() => isLoading = true);
      await ref.read(userProvider).updateProfilePicture(image: image);
      setState(() => isLoading = false);
    }
  }

  Future<void> updateProfileName(String name) async {
    setState(() => isLoading = true);
    await ref.read(userProvider).updateProfileName(name: name);
    setState(() => isLoading = false);
    Navigator.pop(context);

  }

  Future<void> deleteAccount() async{
    setState(() => isLoading = true);
    await ref.read(userProvider).changeAccountFromVerify();
    setState(() => isLoading = false);
    Navigator.pop(context);
  }


  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.of(context).size;
    return FutureBuilder(
        future: ref.read(userProvider).getUserInfo(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final user = snapshot.data!;
            _nameController.text = user.name;
            return Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.blueGrey[600],
                foregroundColor: Colors.white,
                title: const Text("Profile", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),),
                centerTitle: true,
              ),
              body: isLoading? const Loader():
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 30,
                    ),
                    Center(
                      child: PickImageWidget(
                          onPressed: () async {
                            image = await pickImage();
                            await updateProfilePicture(image);
                          },
                          image: image,
                          currentImage: user.profilePicUrl),
                    ),
                    const SizedBox(
                      height: 32,
                    ),
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
                                  child: BottomSheetEditName(
                                      nameController: _nameController,
                                      onCancelPressed: (){
                                        Navigator.pop(context);
                                      },
                                      onSavePressed: () async {
                                        final name = _nameController.text;
                                        if (name != user.name) {
                                          updateProfileName(name);
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
