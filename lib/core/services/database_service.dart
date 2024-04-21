import 'package:chat_app/app/data/model/user_profile.dart';
import 'package:chat_app/core/services/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';

class DatabaseService {
  final GetIt _getIt = GetIt.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  CollectionReference? _usersCollection;
  late AuthService _authService;

  DatabaseService() {
    _setupCollectionReferences();
    _authService = _getIt.get<AuthService>();
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

  Stream<QuerySnapshot<UserProfile>> getUserProfile() {
    return _usersCollection
        ?.where(
          'uid',
          isNotEqualTo: _authService.user!.uid,
        )
        .snapshots() as Stream<QuerySnapshot<UserProfile>>;
  }
}
