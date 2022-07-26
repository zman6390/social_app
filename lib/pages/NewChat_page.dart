import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:social_app/services/database.dart';
import '../widgets/Loading.dart';
import 'groups.dart';
import 'package:social_app/models/user.dart' as internal;

class NewChat_page extends StatefulWidget {
  NewChat_page({Key? key}) : super(key: key);

  State<NewChat_page> createState() => _NewChat_PageState();
}

class _NewChat_PageState extends State<NewChat_page> {
  final _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseService db = new DatabaseService();

  bool loading = false;
  TextEditingController _message = TextEditingController();
  final TextEditingController _search = TextEditingController();
  final _to = <String>{}; // NEW
  final _biggerFont = TextStyle(fontSize: 18);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Start New Chat"),
        titleSpacing: 10,
      ),
      body:
          // Column(
          //     children: [

          Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: size.height / 20,
                  ),
                  Container(
                    height: size.height / 14,
                    width: size.width,
                    child: Container(
                      height: size.height / 14,
                      width: size.width / 1.4,
                      child: TextField(
                        controller: _search,
                        onChanged: (text) {
                          setState(() {});
                        },
                        decoration: InputDecoration(
                          hintText: "Search",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: size.height / 30,
                  ),

                  Expanded(
                    child: StreamBuilder<Map<String, internal.User>>(
                      stream: db.users,
                      builder: (BuildContext context,
                          AsyncSnapshot<Map<String, internal.User>> snapshot) {
                        if (snapshot.hasError) {
                          return const Center(
                            child: Text("error fetching users!"),
                          );
                        } else if (snapshot.hasData) {
                          List<internal.User> users = [];
                          (snapshot.data ?? Map()).forEach((k, v) {
                            if (k != _auth.currentUser!.uid &&
                                v.name.startsWith(_search.text)) users.add(v);
                          });
                          var count = 0;
                          return users.isEmpty
                              ? const Center(child: Text("NO USERS"))
                              : ListView.builder(
                                  itemCount: users.length,
                                  itemBuilder: (BuildContext context, int i) {
                                    final alreadySaved =
                                        _to.contains(users[i].id);
                                    return Column(children: [
                                      ListTile(
                                        title: Text(
                                          users[i].name,
                                          style: _biggerFont,
                                        ),
                                        trailing: Icon(
                                          // NEW from here ...
                                          alreadySaved
                                              ? Icons.check_box
                                              : Icons.check_box_outline_blank,
                                          color:
                                              alreadySaved ? Colors.red : null,
                                          semanticLabel: alreadySaved
                                              ? 'Remove from saved'
                                              : 'Save',
                                        ),
                                        onTap: () {
                                          // NEW from here ...
                                          setState(() {
                                            if (alreadySaved) {
                                              _to.remove(users[i].id);
                                            } else {
                                              _to.add(users[i].id);
                                              print("NewChat_page====> _to: " +
                                                  _to.toString());
                                            }
                                          });
                                        },
                                      ),
                                      const Divider()
                                    ]);
                                  });
                        }
                        return Loading();
                      },
                    ),
                  ),

                  TextFormField(
                    controller: _message,
                    decoration: InputDecoration(
                        labelText: "message",
                        labelStyle: TextStyle(
                            fontSize: 20,
                            fontFamily: 'Signatra',
                            color: Colors.black)),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Message can not be empty";
                      }

                      return null;
                    },
                  ),

                  //Send button
                  OutlinedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          var users = <String>{};

                          for (var element in _to) {
                            users.add(element);
                          }
                          users.add(_auth.currentUser!.uid);
                          db
                              .addNewMessage(
                                  users, _auth.currentUser!.uid, _message.text)
                              .whenComplete(() => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Groups_page())));
                        }
                      },
                      child: Text("SEND")),
                ],
              )),
    );
  }
}
