import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_chat/core/utils/validator.dart';
import 'package:my_chat/core/providers/user_provider.dart';
import 'package:my_chat/features/auth/screen/presentation/register_page.dart';
import 'package:my_chat/features/auth/screen/widget/round_button.dart';
import 'package:my_chat/features/auth/screen/widget/edit_text.dart';

//membuat key untuk form login
final _loginFormKey = GlobalKey<FormState>();


//widget untuk halaman login
class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  static const routeName = '/login';

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  //variabel isloading untuk mengatur loading
  bool isLoading = false;

  //variabel hidepassword untuk mengatur showpassword
  bool hidePassword = true;

  //controller untuk email dan password
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

  //function login
  Future<void> login() async {
    //validasi form key saat ini
    if (_loginFormKey.currentState!.validate()) {
      //menyimpan isi form pada state saat ini
      _loginFormKey.currentState!.save();
      //mengubah loading menjadi true
      setState(() => isLoading = true);
      //menjalankan function login yang ada di userRepository dengan mengirimkan parameter berupa email dan password
      await ref
          .read(userProvider)
          .login(email: _emailController.text, password: _passController.text);
      //mengubah loading menjadi false ketika proses sudah selesai
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    //mendapatkan size dari screen
    final screen = MediaQuery.of(context).size;
    //menampilkan scaffold
    return Scaffold(
      //menambahkan padding sebesar 16
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        //menambahkan singleChildcrollview
        child: SingleChildScrollView(
          //menambahkan kolom
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //menambahkan jarak vertical sebanyak 50
              const SizedBox(height: 50),
              //mengatur posisi agar ditengah
              Center(
                //menambahkan sizebox untuk mengatur ukuran width gambar sebesar 300
                child: SizedBox(
                    width: 300, child: Image.asset("images/login.png")),
              ),
              //menambahkan jarak vertical sebanyak 20
              const SizedBox(
                height: 20,
              ),
              //menambahkan teks login
              const Text(
                "Login",
                style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey),
              ),
              //menambahkan jarak vertical sebanyak 16
              const SizedBox(
                height: 16,
              ),
              //membuat form
              Form(
                  key: _loginFormKey,
                  //menambahkan column pada form
                  child: Column(
                    children: [
                      //custom textformfield untuk email
                      EditText(
                        controller: _emailController,
                        hint: "Email",
                        action: TextInputAction.next,
                        keyboardType: TextInputType.name,
                        validator: (value)=>validateEmail(value),
                      ),
                      //menambahkan jarak vertical sebanyak 10
                      const SizedBox(
                        height: 10,
                      ),
                      //custom textfield untuk password
                      EditText(
                        controller: _passController,
                        hint: "Password",
                        isPassword: hidePassword,
                        action: TextInputAction.done,
                        keyboardType: TextInputType.visiblePassword,
                        validator: (value)=>validatePassword(value),
                        //megatur icon dan action untuk iconbutton showpassword
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
                      //menambahkan jarak vertical sebanyak 20
                      const SizedBox(
                        height: 20,
                      ),
                      ///jika isloading=true maka akan menampilkan loading
                      ///dan jika false maka akan menampilkan button login
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
              //menambahkan jarak vertical sebanyak 20
              const SizedBox(
                height: 20,
              ),
              ///menambahkan text dan textbutton jika belum mempunyai akun
              ///dan ketika diklik maka akan berpindah ke halaman register
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
