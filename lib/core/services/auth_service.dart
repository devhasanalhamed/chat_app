import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final _firebaseAuth = FirebaseAuth.instance;

  //User is a class from firebase auth
  User? _user;

  User? get user => _user;

  AuthService();

  Future<bool> login(String email, String password) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user != null) {
        _user = credential.user;
        return true;
      }
    } catch (e) {
      print('login error: $e');
    }
    return false;
  }
}
