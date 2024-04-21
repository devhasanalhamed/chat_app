import 'package:chat_app/app/data/model/user_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ChatTile extends StatelessWidget {
  final UserProfile userProfile;
  const ChatTile({
    super.key,
    required this.userProfile,
  });

  @override
  Widget build(BuildContext context) {
    return const ListTile(
      dense: false,
      leading: CircleAvatar(
        backgroundImage: NetworkImage('url'),
      ),
    );
  }
}
