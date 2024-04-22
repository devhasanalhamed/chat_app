import 'package:chat_app/app/view/screen/homepage.dart';
import 'package:chat_app/app/view/screen/login_screen.dart';
import 'package:chat_app/app/view/screen/register_screen.dart';
import 'package:flutter/material.dart';

class NavigationService {
  late GlobalKey<NavigatorState> _navigatorKey;

  GlobalKey<NavigatorState> get navigatorKey => _navigatorKey;

  final Map<String, Widget Function(BuildContext)> _routes = {
    "/login": (context) => const LoginScreen(),
    "/register": (context) => const RegisterScreen(),
    "/homepage": (context) => const Homepage(),
  };

  Map<String, Widget Function(BuildContext)> get routes => _routes;

  NavigationService() {
    _navigatorKey = GlobalKey<NavigatorState>();
  }

  void push(MaterialPageRoute route) => _navigatorKey.currentState?.push(route);

  void pushNamed(String routeName) =>
      _navigatorKey.currentState?.pushNamed(routeName);

  void pushReplacementNamed(String routeName) =>
      _navigatorKey.currentState?.pushReplacementNamed(routeName);

  void goBack() => _navigatorKey.currentState?.pop();
}
