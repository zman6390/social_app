import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:social_app/pages/profile_page.dart';
import 'package:social_app/services/database.dart';

class ProfileLoader extends StatelessWidget {
  final DatabaseService _db = DatabaseService();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final String user_uid;

  ProfileLoader({
    required this.user_uid,
  });

  @override
  Widget build(BuildContext context) {
    getUser(context, user_uid);

    return SizedBox();
  }

  Future<dynamic> getUser(context, user_uid) async {
    var user = await _db.getUser(user_uid);
    Navigator.pop(context);
    return Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ProfilePage(
                name: user.name,
                email: user.email,
                bio: user.bio,
                rating: user.rating_average,
                user_uid: user_uid)));
  }
}
