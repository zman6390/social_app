import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  Post(
      {required this.id,
      required this.message,
      required this.type,
      required this.display_name,
      required this.owner,
      required this.created});

  factory Post.fromMap(String id, Map<String, dynamic> data) {
    return Post(
      id: id,
      message: data['message'],
      type: data['type'],
      display_name: data['display_name'],
      owner: data['owner'],
      created: data['created'],
    );
  }
  Map<String, dynamic> toJson() => {
        'message': message,
        'type': type,
        'owner': owner,
        'display_name': display_name,
        'created': created,
      };

  final String id;
  final String message;
  final String display_name;
  final int type;
  final String owner;
  final Timestamp created;
}
