import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_chat/features/auth/providers/auth_provider.dart';
import 'package:my_chat/core/widget/auth_button.dart';
import 'package:my_chat/core/widget/edit_text.dart';
import 'package:my_chat/features/auth/verify_email_page.dart';
import 'package:my_chat/features/homepage/home_page.dart';

import 'login_page.dart';

final _formKey = GlobalKey<FormState>();

class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  static const routeName = '/register';

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  bool isLoading = false;

  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _passController;

  @override
  void initState() {
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _passController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passController.dispose();
    super.dispose();
  }

  Future<void> register() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() => isLoading = true);
      await ref
          .read(authProvider)
          .register(
              name: _nameController.text,
              email: _emailController.text,
              password: _passController.text)
          .then((credential) {
        if (credential!.user!.emailVerified) {
          Navigator.of(context).pushReplacementNamed(HomePage.routeName);
        }else{
          Navigator.of(context).pushReplacementNamed(VerifyEmailPage.routeName);
        }
      }).catchError((_) {
        setState(() => isLoading = false);
      });

      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.of(context).size;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 50),
              Center(
                child: SizedBox(
                    width: 300, child: Image.asset("images/register.png")),
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                "Register",
                style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey),
              ),
              const SizedBox(
                height: 16,
              ),
              Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      EditText(
                        controller: _nameController,
                        hint: "Name",
                        action: TextInputAction.next,
                        keyboardType: TextInputType.name,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      EditText(
                        controller: _emailController,
                        hint: "Email",
                        action: TextInputAction.next,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      EditText(
                        controller: _passController,
                        hint: "Password",
                        action: TextInputAction.done,
                        keyboardType: TextInputType.visiblePassword,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      isLoading
                          ? const Center(
                              child: CircularProgressIndicator(),
                            )
                          : Center(
                              child: SizedBox(
                                width: screen.width/2,
                                child: AuthButton(
                                    onPressed: register,
                                    label: "Register",
                                    labelSize: 20,
                                ),
                              ),
                            ),
                    ],
                  )),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Already have account?"),
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pushReplacementNamed(LoginPage.routeName);
                      },
                      child: const Text("Login"))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
