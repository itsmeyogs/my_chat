import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:my_chat/core/utils/utils.dart';
import 'package:my_chat/core/widget/pick_image_widget.dart';
import 'package:my_chat/features/auth/providers/auth_provider.dart';
import 'package:my_chat/features/loader.dart';
import 'package:my_chat/features/profile/bottom_sheet_edit_name.dart';

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
      await ref.read(authProvider).updateProfilePicture(image: image);
      setState(() => isLoading = false);
    }
  }

  Future<void> updateProfileName(String name) async{
    setState(() => isLoading = true);
    await ref.read(authProvider).updateProfileName(name: name);
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        centerTitle: true,
      ),
      body: isLoading
          ? const Loader()
          : FutureBuilder(
              future: ref.read(authProvider).getUserInfo(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Loader();
                }
                if (snapshot.hasData) {
                  final user = snapshot.data!;
                  _nameController.text = user.name;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 30,
                      ),
                      Center(
                        child: PickImageWidget(
                            onPressed: () async {
                              image = await pickImage();
                              updateProfilePicture(image);
                            },
                            image: image,
                            currentImage: user.profilePicUrl),
                      ),
                      const SizedBox(
                        height: 20,
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
                                        onCancelPressed: () =>Navigator.pop(context),
                                        onSavePressed: () {
                                          if(_nameController.text!=user.name){
                                            updateProfileName(_nameController.text);
                                            Navigator.pop(context);
                                          }else{
                                            Navigator.pop(context);
                                          }
                                        }));
                              });
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(top: 16, bottom: 16),
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
                      Text("id : ${user.uid}")
                    ],
                  );
                }
                return const Loader();
              },
            ),
    );
  }
}
