import 'package:chat_app/core/services/auth_service.dart';
import 'package:chat_app/core/services/navigation_service.dart';
import 'package:chat_app/core/utils/firebase_utils.dart';
import 'package:chat_app/core/utils/service_locator_utils.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  await setup();
  runApp(MyApp());
}

Future<void> setup() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setUpFirebase();
  await registerServices();
}

class MyApp extends StatelessWidget {

  final GetIt _getIt = GetIt.instance;

  late NavigationService _navigationService;
  late AuthService _authService;

  MyApp({super.key}) {
    _navigationService = _getIt<NavigationService>();
    _authService = _getIt<AuthService>();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: _navigationService.navigatorKey,
      title: 'Chat-app',
      theme: ThemeData(
        textTheme: GoogleFonts.montserratTextTheme(),
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
        ),
        useMaterial3: true,
      ),
      initialRoute: _authService.user != null ? '/homepage' : '/login',
      routes: _navigationService.routes,
    );
  }
}
