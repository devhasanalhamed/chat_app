import 'package:chat_app/app/data/model/chat.dart';
import 'package:chat_app/app/data/model/message.dart';
import 'package:chat_app/app/data/model/user_profile.dart';
import 'package:chat_app/core/services/auth_service.dart';
import 'package:chat_app/core/utils/generate_chat_id.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';

class DatabaseService {
  final GetIt _getIt = GetIt.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  CollectionReference? _usersCollection;
  CollectionReference? _chatCollection;
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

    _chatCollection =
        _firebaseFirestore.collection('chats').withConverter<Chat>(
              fromFirestore: (snapshot, options) => Chat.fromJson(
                snapshot.data()!,
              ),
              toFirestore: (chat, options) => chat.toJson(),
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

  Future<bool> checkChatExists(String uid1, String uid2) async {
    String chatId = generateChatId(uid1: uid1, uid2: uid2);
    final result = await _chatCollection?.doc(chatId).get();
    if (result != null) {
      return result.exists;
    } else {
      return false;
    }
  }

  Future<void> createNewChat(String uid1, String uid2) async {
    String chatId = generateChatId(uid1: uid1, uid2: uid2);
    final docRef = _chatCollection!.doc(chatId);
    final chat = Chat(
      id: chatId,
      participants: [uid1, uid2],
      messages: [],
    );

    await docRef.set(chat);
  }

  Future<void> sendChatMessage(
      String uid1, String uid2, Message message) async {
    final String chatId = generateChatId(uid1: uid1, uid2: uid2);
    final docRef = _chatCollection!.doc(chatId);

    docRef.update(
      {
        "messages": FieldValue.arrayUnion(
          [
            message.toJson(),
          ],
        ),
      },
    );
  }

  Stream<DocumentSnapshot<Chat>> getChatData(String uid1, String uid2) {
    final String chatId = generateChatId(uid1: uid1, uid2: uid2);
    return _chatCollection?.doc(chatId).snapshots()
        as Stream<DocumentSnapshot<Chat>>;
  }
}
