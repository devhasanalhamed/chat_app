import 'package:firebase_core/firebase_core.dart';

Future<void> setUpFirebase() async {
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey:
          "AIzaSyBsofrrkxylGOmoglvyEWPp2gjuBDIq-TA", // paste your api key here
      appId:
          "1:567490514774:android:b07f4df8b44d68597410f7", //paste your app id here
      messagingSenderId: "567490514774", //paste your messagingSenderId here
      projectId: "chat-app-fced7", //paste your project id here
    ),
  );
}
