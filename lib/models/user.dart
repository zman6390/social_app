import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  User(
      {required this.id,
      required this.name,
      required this.type,
      required this.email,
      required this.bio,
      required this.created});

  factory User.fromMap(String id, Map<String, dynamic> data) {
    return User(
        id: id,
        name: data['name'],
        type: data['type'],
        email: data['email'],
        created: data['created'],
        bio: data['bio']);
  }
  Map<String, dynamic> toJson() => {
        'name': name,
        'type': type,
        'email': email,
        'created': created,
        'bio': bio
      };

  final String id;
  final String name;
  final String type;
  final String email;
  final Timestamp created;
  final String bio;
}
