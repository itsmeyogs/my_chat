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