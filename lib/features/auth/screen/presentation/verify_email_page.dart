import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_chat/core/providers/user_provider.dart';
import 'package:my_chat/features/auth/screen/widget/round_button.dart';
import 'package:my_chat/core/utils/utils.dart';
import 'package:my_chat/features/utils/loader.dart';

import '../../../../core/constants/app_message.dart';

class VerifyEmailPage extends ConsumerStatefulWidget {
  const VerifyEmailPage({super.key});

  static const routeName = '/verify_email';

  @override
  ConsumerState<VerifyEmailPage> createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends ConsumerState<VerifyEmailPage> {
  bool isLoading = false;

  Future<void> sendEmailVerification() async {
    setState(() => isLoading = true);
    await ref.read(userProvider).verifyEmail();
    setState(() => isLoading = false);
  }

  Future<void> refreshVerify() async {
    final user = FirebaseAuth.instance.currentUser!;
    setState(() => isLoading = true);
    await user.reload();
    if (user.emailVerified == true) {
      setState(()=>isLoading = false);
    }
    setState(()=>isLoading = false);
  }


  @override
  void initState() {
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
                    await ref.read(userProvider).deleteAccount();
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
