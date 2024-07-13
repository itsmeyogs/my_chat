import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_chat/core/utils/validator.dart';
import 'package:my_chat/core/providers/user_provider.dart';
import 'package:my_chat/features/auth/screen/widget/round_button.dart';
import 'package:my_chat/features/auth/screen/widget/edit_text.dart';


//membuat key untuk form register
final _registerFormKey = GlobalKey<FormState>();

//widget untuk halaman register
class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  static const routeName = '/register';

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  //variabel isloading untuk mengatur loading
  bool isLoading = false;

  //variabel hidepassword untuk mengatur showpassword
  bool hidePassword = true;

  //controller untuk nama, email dan password
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

  //function register
  Future<void> register() async {
    //validasi form key saat ini
    if (_registerFormKey.currentState!.validate()) {
      //menyimpan isi form pada state saat ini
      _registerFormKey.currentState!.save();
      //mengubah loading menjadi true
      setState(() => isLoading = true);
      ///menjalankan function register yang ada di userRepository dengan mengirimkan
      ///parameter berupa name, email dan password
      await ref.read(userProvider).register(
              name: _nameController.text,
              email: _emailController.text.toLowerCase(),
              password: _passController.text)
          .then((credential) {
            //mengecek jika email belum diverifikasi
        if (!credential!.user!.emailVerified) {
          //maka akann menjalankan pop(kembali ke halaman sebelumnya)
          Navigator.pop(context);
        }
      }).catchError((_) {
        //mengubah loading menjadi false ketika proses sudah selesai
        setState(() => isLoading = false);
      });
      //mengubah loading menjadi false ketika proses sudah selesai
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
                  key: _registerFormKey,
                  child: Column(
                    children: [
                      EditText(
                        controller: _nameController,
                        hint: "Name",
                        action: TextInputAction.next,
                        keyboardType: TextInputType.name,
                        validator: (value)=>validateName(value),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      EditText(
                        controller: _emailController,
                        hint: "Email",
                        action: TextInputAction.next,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value)=>validateName(value),
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
                                width: screen.width/2,
                                child: RoundButton(
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
              //menampilkan teks already have account, jika diklik maka akan kembali kehalaman sebelumnya yaitu login
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Already have account?"),
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
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
