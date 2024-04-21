import 'package:chat_app/core/services/alert_service.dart';
import 'package:chat_app/core/services/auth_service.dart';
import 'package:chat_app/core/services/navigation_service.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final GetIt _getIt = GetIt.instance;

  late AuthService _authService;
  late NavigationService _navigationService;
  late AlertService _alertService;
  @override
  void initState() {
    _authService = _getIt.get<AuthService>();
    _navigationService = _getIt.get<NavigationService>();
    _alertService = _getIt.get<AlertService>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Messages'),
        actions: [
          IconButton(
            onPressed: () async {
              final bool result = await _authService.logOut();
              if (result) {
                _alertService.showToast(
                  text: 'Successfully logged out!',
                  icon: Icons.check,
                );
                _navigationService.pushReplacementNamed('/login');
                debugPrint('user has been signed out');
              } else {
                debugPrint('logout result is false');
              }
            },
            icon: const Icon(
              Icons.logout,
              color: Colors.red,
            ),
          ),
        ],
      ),
    );
  }
}
