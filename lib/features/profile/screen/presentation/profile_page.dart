import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:my_chat/core/utils/utils.dart';
import 'package:my_chat/features/auth/screen/widget/round_button.dart';
import 'package:my_chat/features/auth/screen/widget/pick_image_widget.dart';
import 'package:my_chat/core/providers/user_provider.dart';
import 'package:my_chat/features/utils/loader.dart';
import 'package:my_chat/features/profile/screen/widget/bottom_sheet_edit_name.dart';

import '../../../../core/constants/app_message.dart';

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
    navigatePop();
    setState(() => isLoading = false);
  }

  void navigatePop() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        centerTitle: true,
      ),
      body: isLoading
          ? const Loader()
          : FutureBuilder(
              future: ref.read(userProvider).getUserInfo(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Loader();
                }
                if (snapshot.hasData) {
                  final user = snapshot.data!;
                  _nameController.text = user.name;

                  return SingleChildScrollView(
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
                                          onCancelPressed: navigatePop,
                                          onSavePressed: () async {
                                            final name = _nameController.text;
                                            if (name != user.name) {
                                              updateProfileName(name);
                                            } else {
                                              navigatePop();
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
                          height: 100,
                        ),
                        SizedBox(
                            width: screen.width,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 24, right:24),
                              child: RoundButton(
                                  onPressed: () {
                                    showToastMessage(text: AppMessage.comingSoon);
                                  },
                                  label: "Change Email",
                                  labelSize: 16),
                            )
                        ),
                        const SizedBox(height: 16,),
                        SizedBox(
                            width: screen.width,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 24, right:24),
                              child: RoundButton(
                                  onPressed: () {
                                    showToastMessage(text: AppMessage.comingSoon);
                                  },
                                  label: "Change Password",
                                  labelSize: 16),
                            )),
                        const SizedBox(height: 16,),
                        SizedBox(
                            width: screen.width,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 24, right:24),
                              child: RoundButton(
                                  onPressed: () async{
                                    setState(()=>isLoading=true);
                                    await ref.read(userProvider).deleteAccount();
                                    setState(()=>isLoading=false);
                                    navigatePop();
                                    setState(() {});
                                  },
                                  label: "Delete Account",
                                  labelSize: 16),
                            ))
                      ],
                    ),
                  );
                }
                return Container();
              },
            ),
    );
  }
}
