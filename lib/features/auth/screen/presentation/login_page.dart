import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_chat/core/utils/validator.dart';
import 'package:my_chat/core/providers/user_provider.dart';
import 'package:my_chat/features/auth/screen/presentation/register_page.dart';
import 'package:my_chat/features/auth/screen/widget/round_button.dart';
import 'package:my_chat/features/auth/screen/widget/edit_text.dart';

final _formKey = GlobalKey<FormState>();

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  static const routeName = '/login';

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  bool isLoading = false;
  bool hidePassword = true;
  late final TextEditingController _emailController;
  late final TextEditingController _passController;

  @override
  void initState() {
    _emailController = TextEditingController();
    _passController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passController.dispose();
    super.dispose();
  }

  Future<void> login() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() => isLoading = true);
      await ref
          .read(userProvider)
          .login(email: _emailController.text, password: _passController.text);

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
                    width: 300, child: Image.asset("images/login.png")),
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                "Login",
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
                        controller: _emailController,
                        hint: "Email",
                        action: TextInputAction.next,
                        keyboardType: TextInputType.name,
                        validator: (value)=>validateEmail(value),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      EditText(
                        controller: _passController,
                        hint: "Password",
                        isPassword: hidePassword,
                        action: TextInputAction.done,
                        keyboardType: TextInputType.visiblePassword,
                        validator: (value)=>validatePassword(value),
                        suffixIcon: hidePassword
                            ? IconButton(
                                onPressed: () {
                                  setState(()=>hidePassword=false);
                                },
                                icon: const Icon(Icons.remove_red_eye_outlined))
                            : IconButton(
                                onPressed: () {
                                 setState(()=>hidePassword=true);
                                },
                                icon: const Icon(Icons.remove_red_eye)
                        ),
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
                                width: screen.width / 2,
                                child: RoundButton(
                                    onPressed: login,
                                    label: "Login",
                                    labelSize: 20),
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
                  const Text("Don't have account?"),
                  TextButton(
                      onPressed: () {
                        Navigator.of(context)
                            .pushNamed(RegisterPage.routeName);
                      },
                      child: const Text("Register"))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
