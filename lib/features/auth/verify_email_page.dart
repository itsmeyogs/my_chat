import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_chat/features/auth/providers/auth_provider.dart';
import 'package:my_chat/core/widget/auth_button.dart';
import 'package:my_chat/features/homepage/home_page.dart';
import 'package:my_chat/core/utils/utils.dart';

class VerifyEmailPage extends ConsumerWidget {
  const VerifyEmailPage({super.key});

  static const routeName = '/verify_email';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screen = MediaQuery.of(context).size;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: screen.width,
              child: AuthButton(
                onPressed: () async {
                  await ref.read(authProvider).verifyEmail().then((value) {
                    if (value == null) {
                      showToastMessage(
                          text: 'Email verification sent to your email');
                    }
                  });
                },
                label: "Verify Email",
                labelSize: 18,
              ),
            ),
            const SizedBox(height: 10,),
            SizedBox(
              width: screen.width,
              child: AuthButton(
                onPressed: () async {
                  await FirebaseAuth.instance.currentUser!.reload();
                  final emailVerified =
                      FirebaseAuth.instance.currentUser?.emailVerified;
                  if (emailVerified == true) {
                    Navigator.of(context).pushReplacementNamed(HomePage.routeName);
                  }
                },
                label: "Refresh",
                labelSize: 18,
              ),
            ),
            const SizedBox(height: 10,),
            SizedBox(
              width: screen.width,
              child: AuthButton(
                onPressed: () {
                  ref.read(authProvider).logout();
                },
                label: "Change Email",
                labelSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
