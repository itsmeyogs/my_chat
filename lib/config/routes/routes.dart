import 'package:flutter/cupertino.dart';
import 'package:my_chat/features/auth/screen/presentation/verify_email_page.dart';
import 'package:my_chat/features/profile/screen/presentation/change_password_page.dart';
import 'package:my_chat/features/utils/error_screen.dart';
import 'package:my_chat/features/homepage/screen/presentation/add_chat_page.dart';
import 'package:my_chat/features/homepage/screen/presentation/chat_page.dart';
import 'package:my_chat/features/homepage/screen/presentation/home_page.dart';
import 'package:my_chat/features/profile/screen/presentation/profile_page.dart';

import '../../features/auth/screen/presentation/login_page.dart';
import '../../features/auth/screen/presentation/register_page.dart';

//class ini digunakan untuk mengatur route dari apps
class Routes{
  static Route onGenerateRoute(RouteSettings settings){
    switch(settings.name){

      //route dari Register Page
      case RegisterPage.routeName:
        return _cupertinoRoute(
          const RegisterPage()
        );

      //route dari Login Page
      case LoginPage.routeName:
        return _cupertinoRoute(
            const LoginPage()
        );

      //route dari Verify Email Page
      case VerifyEmailPage.routeName:
        return _cupertinoRoute(
            const VerifyEmailPage()
        );

      //route dari Home Page
      case HomePage.routeName:
        return _cupertinoRoute(
          const HomePage()
        );
      //route dari Add Chat Page
      case AddChatPage.routeName:
        return _cupertinoRoute(
            const AddChatPage()
        );
      //route dari Chat Page
      case ChatPage.routeName:
        final arguments = settings.arguments as Map<String, dynamic>;
        final userId = arguments['userId'] as String;
        return _cupertinoRoute(
            ChatPage(userId: userId)
        );
      //route dari Profile Page
      case ProfilePage.routeName:
        return _cupertinoRoute(
            const ProfilePage()
        );
      //route dari Change Password Page
      case ChangePasswordPage.routeName:
        final arguments = settings.arguments as Map<String, dynamic>;
        final currentPassword = arguments['currentPassword'] as String;
        return _cupertinoRoute(
            ChangePasswordPage(currentPassword: currentPassword)
        );

      default:
        return _cupertinoRoute(
          ErrorScreen(error: 'Wrong Route provided ${settings.name}')
        );
    }
  }

  static Route _cupertinoRoute(Widget view) => CupertinoPageRoute(
    builder: (_) => view,
  );

  Routes._();
}