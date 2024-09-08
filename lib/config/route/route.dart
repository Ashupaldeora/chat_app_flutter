import 'package:chat_app_flutter/config/route/route_names.dart';
import 'package:chat_app_flutter/features/chat/page/chat_page.dart';

import 'package:chat_app_flutter/features/home/pages/home_page.dart';
import 'package:chat_app_flutter/features/profile/page/profile_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../features/authentication_screen/model/user_model.dart';
import '../../features/authentication_screen/page/login_page.dart';
import '../../features/authentication_screen/page/sign_up.dart';
import '../../features/search/page/search_page.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RoutesName.signUp:
        return MaterialPageRoute(
          builder: (context) => const SignUp(),
        );
      case RoutesName.logIn:
        return MaterialPageRoute(
          builder: (context) => const LoginPage(),
        );

      case RoutesName.home:
        return MaterialPageRoute(
          builder: (context) => HomePage(),
        );
      case RoutesName.chat:
        Map<String, dynamic> args = settings.arguments as Map<String, dynamic>;
        final String hero = args['hero'];
        final String receiverUser = args['receiverId'];
        final String receiverName = args['receiverName'];
        return MaterialPageRoute(
          builder: (context) => ChatScreen(
            hero: hero,
            receiverUser: receiverUser,
            receiverName: receiverName,
          ),
        );
      case RoutesName.search:
        return MaterialPageRoute(builder: (context) => const SearchPage());

      case RoutesName.profile:
        return MaterialPageRoute(builder: (context) => ProfilePage());

      default:
        return MaterialPageRoute(
          builder: (context) => const SignUp(),
        );
    }
  }
}
