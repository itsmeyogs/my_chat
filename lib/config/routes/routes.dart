import 'package:flutter/cupertino.dart';
import 'package:my_chat/features/auth/verify_email_page.dart';
import 'package:my_chat/features/error_screen.dart';
import 'package:my_chat/features/homepage/add_chat_page.dart';
import 'package:my_chat/features/homepage/chat_page.dart';
import 'package:my_chat/features/homepage/home_page.dart';
import 'package:my_chat/features/profile/profile_page.dart';

import '../../features/auth/login_page.dart';
import '../../features/auth/register_page.dart';

class Routes{
  static Route onGenerateRoute(RouteSettings settings){
    switch(settings.name){
      case RegisterPage.routeName:
        return _cupertinoRoute(
          const RegisterPage()
        );
      case LoginPage.routeName:
        return _cupertinoRoute(
            const LoginPage()
        );

      case VerifyEmailPage.routeName:
        return _cupertinoRoute(
            const VerifyEmailPage()
        );

      case HomePage.routeName:
        return _cupertinoRoute(
          const HomePage()
        );

      case AddChatPage.routeName:
        return _cupertinoRoute(
            const AddChatPage()
        );

      case ChatPage.routeName:
        final arguments = settings.arguments as Map<String, dynamic>;
        final userId = arguments['userId'] as String;
        return _cupertinoRoute(
            ChatPage(userId: userId)
        );

      case ProfilePage.routeName:
        return _cupertinoRoute(
            const ProfilePage()
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