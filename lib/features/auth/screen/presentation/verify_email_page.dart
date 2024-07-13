import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_chat/core/providers/user_provider.dart';
import 'package:my_chat/features/auth/screen/widget/round_button.dart';
import 'package:my_chat/core/utils/utils.dart';
import 'package:my_chat/features/utils/loader.dart';

import '../../../../core/constants/app_message.dart';

//widget untuk halaman verifikasi email
class VerifyEmailPage extends ConsumerStatefulWidget {
  const VerifyEmailPage({super.key});

  static const routeName = '/verify_email';

  @override
  ConsumerState<VerifyEmailPage> createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends ConsumerState<VerifyEmailPage> {
  //variabel isloading untuk mengatur loading
  bool isLoading = false;

  //function send email verification
  Future<void> sendEmailVerification() async {
    //mengubah loading menjadi true
    setState(() => isLoading = true);
    //menjalankan function verifyEmail yang ada di userRepository
    await ref.read(userProvider).verifyEmail();
    //mengubah loading menjadi false ketika proses sudah selesai
    setState(() => isLoading = false);
  }

  //function untuk mengecek apakah email sudah diverifikasi
  Future<void> refreshVerify() async {
    //membuat instance current usser dari firebase auth
    final user = FirebaseAuth.instance.currentUser!;
    //mengubah loading menjadi true
    setState(() => isLoading = true);
    //merefresh sesi akun yang tersimpan saat ini
    await user.reload();
    //mengubah loading menjadi false ketika proses sudah selesai
    setState(()=>isLoading = false);
  }


  @override
  void initState() {
    //otomatis menjalankan function sendemailverification ketika halaman baru dibuka
    sendEmailVerification();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery
        .of(context)
        .size;
    return Scaffold(
        body: isLoading ? const Loader() : Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                AppMessage.emailVerificationHasBeenSent,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
              ),
              const Text(
                AppMessage.letsVerifyEmail,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
              ),
              const SizedBox(
                height: 30,
              ),
              SizedBox(
                width: screen.width,
                child: RoundButton(
                  onPressed: () async {
                    sendEmailVerification();
                    showToastMessage(
                        text: AppMessage.resentEmailVerification);
                  },
                  label: "Resend Email Verification",
                  labelSize: 18,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                width: screen.width,
                child: RoundButton(
                  onPressed: refreshVerify,
                  label: "Refresh",
                  labelSize: 18,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                width: screen.width,
                child: RoundButton(
                  onPressed: () async {
                    setState(() => isLoading = true);
                    await ref.read(userProvider).changeAccountFromVerify();
                    setState(() => isLoading = false);
                  },
                  label: "Change Email",
                  labelSize: 18,
                ),
              ),
            ],
          ),
        )
    );
  }
}
