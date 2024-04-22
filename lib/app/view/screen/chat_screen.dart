import 'dart:io';

import 'package:chat_app/app/data/model/chat.dart';
import 'package:chat_app/app/data/model/message.dart';
import 'package:chat_app/app/data/model/user_profile.dart';
import 'package:chat_app/core/services/auth_service.dart';
import 'package:chat_app/core/services/database_service.dart';
import 'package:chat_app/core/services/media_service.dart';
import 'package:chat_app/core/services/storage_service.dart';
import 'package:chat_app/core/utils/generate_chat_id.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class ChatScreen extends StatefulWidget {
  final UserProfile chatUser;
  const ChatScreen({
    super.key,
    required this.chatUser,
  });

  @override
  ChatScreenState createState() => ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> {
  final GetIt _getIt = GetIt.instance;
  ChatUser? _currentUser, _otherUser;
  late AuthService _authService;
  late DatabaseService _databaseService;
  late MediaService _mediaService;
  late StorageService _storageService;

  @override
  void initState() {
    _authService = _getIt.get<AuthService>();
    _databaseService = _getIt.get<DatabaseService>();
    _mediaService = _getIt.get<MediaService>();
    _storageService = _getIt.get<StorageService>();
    _currentUser = ChatUser(
      id: _authService.user!.uid,
      firstName: _authService.user!.displayName,
    );
    _otherUser = ChatUser(
      id: widget.chatUser.uid!,
      firstName: widget.chatUser.name,
      profileImage: widget.chatUser.pfpURL,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${widget.chatUser.name}',
        ),
      ),
      body: _buildUI(),
    );
  }

  Widget _buildUI() {
    return StreamBuilder(
      stream: _databaseService.getChatData(
        _currentUser!.id,
        _otherUser!.id,
      ),
      builder: (context, snapshot) {
        Chat? chat = snapshot.data?.data();
        List<ChatMessage> messages = [];
        if (chat != null && chat.messages != null) {
          messages = _generateChatMessagesList(chat.messages!);
        }
        return DashChat(
          currentUser: _currentUser!,
          onSend: _sendMessage,
          messages: messages,
          inputOptions: InputOptions(
            alwaysShowSend: true,
            trailing: [
              _mediaMessageButton(),
            ],
          ),
          messageOptions: const MessageOptions(
            showOtherUsersAvatar: true,
            showTime: true,
          ),
        );
      },
    );
  }

  Future<void> _sendMessage(ChatMessage chatMessage) async {
    if (chatMessage.medias?.isNotEmpty ?? false) {
      if (chatMessage.medias!.first.type == MediaType.image) {
        Message message = Message(
          senderID: _currentUser!.id,
          content: chatMessage.medias!.first.url,
          messageType: MessageType.image,
          sentAt: Timestamp.fromDate(
            chatMessage.createdAt,
          ),
        );

        await _databaseService.sendChatMessage(
          _currentUser!.id,
          _otherUser!.id,
          message,
        );
      }
    } else {
      Message message = Message(
        senderID: _currentUser!.id,
        content: chatMessage.text,
        messageType: MessageType.text,
        sentAt: Timestamp.fromDate(
          chatMessage.createdAt,
        ),
      );

      await _databaseService.sendChatMessage(
        _currentUser!.id,
        _otherUser!.id,
        message,
      );
    }
  }

  List<ChatMessage> _generateChatMessagesList(List<Message> messages) {
    List<ChatMessage> chatMessages = messages.map((m) {
      if (m.messageType == MessageType.image) {
        return ChatMessage(
          user: m.senderID == _currentUser!.id ? _currentUser! : _otherUser!,
          medias: [
            ChatMedia(
              url: m.content!,
              fileName: "",
              type: MediaType.image,
            ),
          ],
          createdAt: m.sentAt!.toDate(),
        );
      } else {
        return ChatMessage(
          user: m.senderID == _currentUser!.id ? _currentUser! : _otherUser!,
          text: m.content!,
          createdAt: m.sentAt!.toDate(),
        );
      }
    }).toList();
    chatMessages.sort(
      (a, b) => b.createdAt.compareTo(
        a.createdAt,
      ),
    );
    return chatMessages;
  }

  Widget _mediaMessageButton() {
    return IconButton(
      onPressed: () async {
        File? file = await _mediaService.getImageFromGallery();
        if (file != null) {
          String chatId = generateChatId(
            uid1: _currentUser!.id,
            uid2: _otherUser!.id,
          );
          String? downloadUrl = await _storageService.uploadImageToChat(
            file: file,
            chatId: chatId,
          );
          if (downloadUrl != null) {
            final chatMessage = ChatMessage(
              user: _currentUser!,
              createdAt: DateTime.now(),
              medias: [
                ChatMedia(
                  url: downloadUrl,

                  /// empty file name we don't need to display it
                  fileName: "",
                  type: MediaType.image,
                ),
              ],
            );

            _sendMessage(chatMessage);
          }
        }
      },
      icon: const Icon(Icons.image),
      color: Theme.of(context).colorScheme.primary,
    );
  }
}
