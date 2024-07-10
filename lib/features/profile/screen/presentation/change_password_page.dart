import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_chat/core/providers/user_provider.dart';
import 'package:my_chat/core/utils/utils.dart';
import 'package:my_chat/features/auth/screen/widget/edit_text.dart';
import 'package:my_chat/features/auth/screen/widget/round_button.dart';
import 'package:my_chat/features/utils/loader.dart';

import '../../../../core/constants/app_message.dart';
import '../../../../core/utils/validator.dart';

final _changePasswordFormKey = GlobalKey<FormState>();

class ChangePasswordPage extends ConsumerStatefulWidget {
  const ChangePasswordPage({super.key, required this.currentPassword});

  final String currentPassword;

  static const routeName = "/change_password";

  @override
  ConsumerState<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends ConsumerState<ChangePasswordPage> {
  late TextEditingController _currentPasswordController;
  late TextEditingController _newPasswordController;

  bool hideCurrentPassword = true;
  bool hideNewPassword = true;
  bool isLoading = false;

  @override
  void initState() {
    _currentPasswordController = TextEditingController();
    _newPasswordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    super.dispose();
  }

  Future<void> changePassword() async {
    if (_changePasswordFormKey.currentState!.validate()) {
      _changePasswordFormKey.currentState!.save();
      setState(() => isLoading = true);
      if (_currentPasswordController.text != widget.currentPassword) {
        setState(() => isLoading = false);
        showToastMessage(text: AppMessage.errorCurrentPasswordIncorrect);
      } else if (_newPasswordController.text ==
          _currentPasswordController.text) {
        setState(() => isLoading = false);
        showToastMessage(text: AppMessage.errorNewPasswordSameCurrentPassword);
      } else {
        await ref
            .read(userProvider)
            .changePassword(newPassword: _newPasswordController.text);
        setState(() => isLoading = false);
        Navigator.pop(context);
      }
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Change Password"),
        centerTitle: true,
      ),
      body: Form(
        key: _changePasswordFormKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              EditText(
                controller: _currentPasswordController,
                hint: "Current Password",
                isPassword: hideCurrentPassword,
                action: TextInputAction.done,
                keyboardType: TextInputType.visiblePassword,
                validator: (value) => validatePassword(value),
                suffixIcon: hideCurrentPassword
                    ? IconButton(
                        onPressed: () {
                          setState(() => hideCurrentPassword = false);
                        },
                        icon: const Icon(Icons.remove_red_eye_outlined))
                    : IconButton(
                        onPressed: () {
                          setState(() => hideCurrentPassword = true);
                        },
                        icon: const Icon(Icons.remove_red_eye)),
              ),
              const SizedBox(
                height: 10,
              ),
              EditText(
                controller: _newPasswordController,
                hint: "New Password",
                isPassword: hideNewPassword,
                action: TextInputAction.done,
                keyboardType: TextInputType.visiblePassword,
                validator: (value) => validatePassword(value),
                suffixIcon: hideNewPassword
                    ? IconButton(
                        onPressed: () {
                          setState(() => hideNewPassword = false);
                        },
                        icon: const Icon(Icons.remove_red_eye_outlined))
                    : IconButton(
                        onPressed: () {
                          setState(() => hideNewPassword = true);
                        },
                        icon: const Icon(Icons.remove_red_eye)),
              ),
              const SizedBox(
                height: 20,
              ),
              isLoading
                  ? const Loader()
                  : SizedBox(
                      width: MediaQuery.of(context).size.width / 1.7,
                      child: RoundButton(
                          onPressed: changePassword, label: "Save", labelSize: 16))
            ],
          ),
        ),
      ),
    );
  }
}
