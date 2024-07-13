import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_chat/core/providers/user_provider.dart';
import 'package:my_chat/core/utils/utils.dart';
import 'package:my_chat/features/auth/screen/widget/edit_text.dart';
import 'package:my_chat/features/auth/screen/widget/round_button.dart';
import 'package:my_chat/features/utils/loader.dart';

import '../../../../core/constants/app_message.dart';
import '../../../../core/utils/validator.dart';

//formkey untuk change password
final _changePasswordFormKey = GlobalKey<FormState>();

//widget ini digunakan untuk halaman ganti password
class ChangePasswordPage extends ConsumerStatefulWidget {
  const ChangePasswordPage({super.key, required this.currentPassword});

  final String currentPassword;

  static const routeName = "/change_password";

  @override
  ConsumerState<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends ConsumerState<ChangePasswordPage> {
  //controller untuk current password dan new password
  late TextEditingController _currentPasswordController;
  late TextEditingController _newPasswordController;

  //mengatur show password
  bool hideCurrentPassword = true;
  bool hideNewPassword = true;

  //mengatur loading
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

  //function change password
  Future<void> changePassword() async {
    //validasi form key saat ini
    if (_changePasswordFormKey.currentState!.validate()) {
      //menyimpan isi form pada state saat ini
      _changePasswordFormKey.currentState!.save();
      //mengubah loading menjadi true
      setState(() => isLoading = true);

      //mengecek apakah current password yang dimasukkan tidak benar
      if (_currentPasswordController.text != widget.currentPassword) {
        //mengubah loading menjadi false ketika proses sudah selesai
        setState(() => isLoading = false);
        //menampilkan pesan bahwa current password salah
        showToastMessage(text: AppMessage.errorCurrentPasswordIncorrect);

        //mengecek apakah new password sama dengan current password
      } else if (_newPasswordController.text ==
          _currentPasswordController.text) {
        //mengubah loading menjadi false ketika proses sudah selesai
        setState(() => isLoading = false);
        //meanmpilkan pesan bahwa new password sama dengan current password
        showToastMessage(text: AppMessage.errorNewPasswordSameCurrentPassword);
      } else {
        //menjalankan function pada userRepository untuk mengubah password dengan mengirimkan parameter new password
        await ref
            .read(userProvider)
            .changePassword(newPassword: _newPasswordController.text);
        //mengubah loading menjadi false ketika proses sudah selesai
        setState(() => isLoading = false);
        //kembali ke halaman sebelumnya
        Navigator.pop(context);
      }
      //mengubah loading menjadi false ketika proses sudah selesai
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey[600],
        foregroundColor: Colors.white,
        title: const Text("Change Password", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20)),
        centerTitle: true,
      ),
      //awal form
      body: Form(
        key: _changePasswordFormKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              //custom textformfield untuk current password
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
              //custom textformfield untuk new password
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
              //jika isloading
              isLoading
              //maka ditampilkan loading
                  ? const Loader()
              //jika false maka ditampilkan button save
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
