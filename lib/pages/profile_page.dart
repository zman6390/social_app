import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:social_app/widgets/provider.dart';
import 'package:social_app/driver.dart';
import '../models/post.dart';
import '../services/database.dart';
import 'package:firebase_core/firebase_core.dart';

class ProfilePage extends StatelessWidget {
  final String name;
  final String bio;
  final String email;
  final String user_uid;

  ProfilePage(
      {required this.name,
      required this.bio,
      required this.email,
      required this.user_uid});

  static const String routeName = '/profile';
  // final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseService db = DatabaseService();

  //final User user = getUser();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text("User Profile",
                style: TextStyle(fontSize: 40, fontFamily: "Signatra")),
            backgroundColor: Colors.greenAccent),
        body: Column(children: <Widget>[
          Expanded(child: UserInfo()),
          Expanded(child: UserPosts()),
        ]));
  }

  Widget UserInfo() {
    return ListView.builder(
        itemCount: 3,
        itemBuilder: (BuildContext context, int index) {
          String text = "none";
          switch (index) {
            case 0:
              // ignore: prefer_interpolation_to_compose_strings
              text = "user name: " +
                  name; //+_db.collection('users').doc(User.user).get(user).toString();   ('uid': = user.uid);
              break;
            case 1:
              text =
                  "email: $email"; //${_auth.currentUser!.email}"; //${user.email}";
              break;
            case 2:
              text = "bio: $bio"; // + DatabaseService(_auth.currentUser!.uid);
              break;
          }
          return Card(
              elevation: 15.0,
              color: Colors.redAccent,
              child: Padding(
                  padding: const EdgeInsets.all(10.0), child: Text(text)));
        });
  }

  Widget UserPosts() {
    return StreamBuilder<List<Post>>(
      stream: db.posts,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(
            child: Text("An error has occured!"),
          );
        } else {
          var all_posts = snapshot.data ?? [];
          var posts =
              all_posts.where((element) => element.owner == user_uid).toList();
          return posts.isNotEmpty
              ? ListView.builder(
                  itemCount: posts.length,
                  itemBuilder: (BuildContext context, int index) {
                    String user_uid = posts[index].owner;
                    String user_name = posts[index].display_name;
                    String date = DateTime.fromMillisecondsSinceEpoch(
                            posts[index].created.millisecondsSinceEpoch)
                        .toString();
                    return Card(
                        elevation: 5.0,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                              "${posts[index].message}\n$date\n$user_name"),
                        ));
                  })
              : const Center(
                  child: Text("No post have been made yet."),
                );
        }
      },
    );
  }
}