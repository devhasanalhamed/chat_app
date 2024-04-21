import 'package:chat_app/app/data/model/user_profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  CollectionReference? _usersCollection;

  DatabaseService() {
    _setupCollectionReferences();
  }

  void _setupCollectionReferences() {
    _usersCollection =
        _firebaseFirestore.collection('users').withConverter<UserProfile>(
              fromFirestore: (snapshot, options) => UserProfile.fromJson(
                snapshot.data()!,
              ),
              toFirestore: (userProfile, options) => userProfile.toJson(),
            );
  }

  Future<void> createUserProfile({
    required UserProfile userProfile,
  }) async {
    _usersCollection?.doc(userProfile.uid).set(userProfile);
  }
}
