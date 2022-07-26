import 'package:flutter/material.dart';

class Chat_blueprint {
  //The name the user displays to other users
  final String chat_ID;
  final String thread_ID;

  final Set<String> users;

//constructor
  Chat_blueprint({
    required this.chat_ID,
    required this.thread_ID,
    required this.users,
  });

  factory Chat_blueprint.fromMap(String id, Map<String, dynamic> data) {
    return Chat_blueprint(
      chat_ID: id,
      users: {},
      thread_ID: data['thread_ID'],
    );
  }

  Map<String, dynamic> toJson() =>
      {'conversation_ID': chat_ID, 'users': users, 'thread_ID': thread_ID};
}
