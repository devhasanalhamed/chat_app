import 'package:firebase_core/firebase_core.dart' show Firebase;
import 'package:chat_app/firebase_options.dart';

Future<void> setUpFirebase() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}
