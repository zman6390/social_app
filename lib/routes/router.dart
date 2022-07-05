import 'package:social_app/driver.dart';
import 'package:social_app/pages/home.dart';
import 'package:social_app/pages/register.dart';
import 'package:flutter/material.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.home:
        return MaterialPageRoute(builder: (_) => HomePage());
      case Routes.driver:
        return MaterialPageRoute(builder: (_) => Driver());
      case Routes.signup:
        return MaterialPageRoute(
          builder: (_) => RegisterPage(),
        );
      default:
        return MaterialPageRoute(builder: (_) => Driver());
    }
  }
}

class Routes {
  static const String home = HomePage.routeName;
  static const String signup = RegisterPage.routeName;
  static const String driver = '/';
}
