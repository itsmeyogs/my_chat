import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_chat/features/auth/screen/presentation/login_page.dart';
import 'package:my_chat/features/auth/screen/presentation/verify_email_page.dart';
import 'package:my_chat/features/homepage/screen/presentation/home_page.dart';
import 'package:my_chat/features/utils/loader.dart';

import 'config/routes/routes.dart';
import 'firebase_options.dart';

void main() async {
  //memastikan bahwa widget sudah di inisialisasi kan semua
  WidgetsFlutterBinding.ensureInitialized();
  //menginisialisasi firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    //menjalankan MyApp dengan ProviderScope(flutter riverpod)
      const ProviderScope(
          child: MyApp())
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        //mengatur font ke OpenSans
        fontFamily: "OpenSans",
        //mengatur warna colorScheme berupa bluegrey
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
        //mengaktifkan material3
        useMaterial3: true,
      ),
      //mengatur on generate route, ke route yang sudah dibuat
      onGenerateRoute: Routes.onGenerateRoute,
      //stream builder
      home: StreamBuilder(
        //mendapatkan data perubahan user dari firebase auth
        stream: FirebaseAuth.instance.userChanges(),
        builder: (context, snapshot) {
          //jika koneksi waiting maka menampilkan loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Loader();
          }
          //jika data terseda
          if (snapshot.hasData) {
            final user = snapshot.data;
            //dicek jika email dari user sudah diverifikasi, maka ditampilkan halaman homepage
            if (user!.emailVerified) {
              return const HomePage();
              //jika email user belum di verifikasi, maka ditampikan halaman verify email page
            } else {
              return const VerifyEmailPage();
            }
          }

          //default menampilkan halaman login
          return const LoginPage();
        },
      ),
    );
  }
}
