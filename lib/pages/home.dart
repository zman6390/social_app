import 'package:social_app/forms/postform.dart';
import 'package:social_app/models/post.dart';
import 'package:social_app/pages/register.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:social_app/services/database.dart';
import 'package:intl/intl.dart';
import '../services/database.dart';

class HomePage extends StatefulWidget {
  static const String routeName = '/home';

  const HomePage({
    Key? key,
  }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool loading = false;
  bool admin = false;
  final DatabaseService db = DatabaseService();
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(actions: [
          IconButton(
            onPressed: () {
              setState(() {
                loading = true;
                logout();
              });
            },
            icon: const Icon(Icons.logout),
          ),
        ]),
        body: StreamBuilder<List<Post>>(
          stream: db.posts,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Center(
                child: Text("An error has occured!"),
              );
            } else {
              var posts = snapshot.data ?? [];

              return posts.isNotEmpty
                  ? ListView.builder(
                      itemCount: posts.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Card(
                            elevation: 5.0,
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text(posts[index].message +
                                  "\n" +
                                  (new DateTime.fromMillisecondsSinceEpoch(
                                          posts[index]
                                              .created
                                              .millisecondsSinceEpoch)
                                      .toString()) +
                                  " " +
                                  posts[index].owner),
                            ));
                      })
                  : const Center(
                      child: Text("No post have been made yet."),
                    );
            }
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: messagePopUp,
          tooltip: 'Post Message',
          child: const Icon(Icons.add),
        ));
  }

  void logout() async {
    await auth.signOut();
    // ignore: use_build_context_synchronously
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
          builder: (BuildContext context) => const RegisterPage()),
      ModalRoute.withName('/'),
    );
  }

  void messagePopUp() {
    showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext context) {
          return const Padding(
              padding: EdgeInsets.all(30.0), child: PostForm());
        });
  }
}
