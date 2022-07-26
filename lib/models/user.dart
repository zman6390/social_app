import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  User(
      {required this.id,
      required this.name,
      required this.type,
      required this.email,
      required this.bio,
      required this.created,
      required this.rating_total,
      required this.rating_count,
      required this.rating_average});

  factory User.fromMap(String id, Map<String, dynamic> data) {
    return User(
        id: id,
        name: data['name'],
        type: data['type'],
        email: data['email'],
        created: data['created'],
        bio: data['bio'],
        rating_total: data['rating_total'],
        rating_count: data['rating_count'],
        rating_average: data['rating_average']);
  }
  Map<String, dynamic> toJson() => {
        'name': name,
        'type': type,
        'email': email,
        'created': created,
        'bio': bio,
        'rating_total': rating_total,
        'rating_count': rating_count,
        'rating_average': rating_average
      };

  final String id;
  final String name;
  final String type;
  final String email;
  final Timestamp created;
  final String bio;
  final int rating_total;
  final int rating_count;
  final double rating_average;
}
