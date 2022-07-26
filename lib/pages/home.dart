import 'package:social_app/forms/postform.dart';
import 'package:social_app/models/post.dart';
import 'package:social_app/pages/groups.dart';
import 'package:social_app/pages/profile_loading_page.dart';
import 'package:social_app/pages/register.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:social_app/services/database.dart';
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
    final size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
            title: Text("Post Stream!",
                style: TextStyle(fontSize: 40, fontFamily: "Signatra")),
            backgroundColor: Colors.redAccent,
            actions: [
              IconButton(
                  icon: Icon(Icons.message_outlined),
                  onPressed: () async {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => Groups_page()));
                  }),
              IconButton(
                icon: Icon(Icons.account_circle),
                onPressed: () async {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => ProfileLoader(
                                user_uid: auth.currentUser!.uid,
                              )));
                },
              ),
              IconButton(
                  icon: Icon(Icons.logout_rounded),
                  onPressed: () async {
                    setState(() {
                      loading = true;
                      logout();
                    });
                  }),
            ]),
        backgroundColor: Colors.lightBlueAccent,
        body: (StreamBuilder<List<Post>>(
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
                        String user_uid = posts[index].owner;
                        String user_name = posts[index].display_name;
                        String date = DateTime.fromMillisecondsSinceEpoch(
                                posts[index].created.millisecondsSinceEpoch)
                            .toString();

                        return Card(
                            elevation: 5.0,
                            child: InkWell(
                              onTap: () async {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            ProfileLoader(
                                              user_uid: user_uid,
                                            )));
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text(
                                    "${posts[index].message}\n$date\n$user_name"),
                              ),
                            ));
                      })
                  : const Center(
                      child: Text("No post have been made yet."),
                    );
            }
          },
        )),
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

  void messagePopUp() async {
    showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext context) {
          return const Padding(
              padding: EdgeInsets.all(30.0), child: PostForm());
        });
  }
}
