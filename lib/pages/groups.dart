import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:social_app/services/database.dart';
import 'package:social_app/widgets/chatting.dart';
import 'package:social_app/models/chat.dart';
import '../widgets/Loading.dart';
import 'package:social_app/pages/NewChat_page.dart';

class Groups_page extends StatefulWidget {
  Groups_page({Key? key}) : super(key: key);

  State<Groups_page> createState() => GroupState();
}

class GroupState extends State<Groups_page> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseService db = DatabaseService();
  final TextEditingController post = TextEditingController();
  late String user_name;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => NewChat_page()));
              },
            ),
          ],
          title: const Text('chats'),
        ),
        body: Column(children: [
          Text('Chat Groups',
              style: TextStyle(
                  fontFamily: 'Signatra', fontSize: 24, color: Colors.black)),
          Expanded(
            child: StreamBuilder<List<Chat_blueprint>>(
              stream: db.chats,
              builder: (BuildContext context,
                  AsyncSnapshot<List<Chat_blueprint>> snapshot) {
                if (snapshot.hasError) {
                  return const Center(
                    child: Text("An error has occured!"),
                  );
                } else if (snapshot.hasData) {
                  var all_chats = snapshot.data ?? [];
                  var chats = all_chats
                      .where((chat) => chat.users
                          .where(
                              (name) => name.contains(_auth.currentUser!.uid))
                          .isNotEmpty)
                      .toList();
                  //print(chats.join(", "));
                  return chats.isEmpty
                      ? const Center(child: Text("Click + to start Chat"))
                      : ListView.builder(
                          itemCount: chats.length,
                          itemBuilder: (BuildContext context, int index) {
                            var rawUsers = chats[index].users;
                            var user_names = getUsers(rawUsers);
                            return ChatView(
                                chat_ident: chats[index].chat_ID,
                                thread_ID: chats[index].thread_ID,
                                user_ids: user_names,
                                id: "");
                          });
                }
                return Loading();
              },
            ),
          ),
        ]));
  }

  List<String> getUsers(Set<String> users) {
    List<String> user_ids = [];

    users.forEach((u) {
      var user_id_without_brackets =
          u.replaceAll(RegExp(r"\p{P}", unicode: true), "");
      if (user_id_without_brackets != _auth.currentUser!.uid) {
        user_ids.add(user_id_without_brackets.toString());
      }
    });
    return user_ids;
  }
}
