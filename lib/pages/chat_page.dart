import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:social_app/pages/rating_page.dart';
import 'package:social_app/services/database.dart';
import 'package:social_app/models/message.dart';
import '../widgets/Loading.dart';

class Chat_page extends StatefulWidget {
  final String Thread_ID;
  final List<String> uids;

  @override
  State<Chat_page> createState() => Chat_pageState();

  Chat_page({required this.Thread_ID, required this.uids});
}

class Chat_pageState extends State<Chat_page> {
  final _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late DatabaseService db;
  final TextEditingController _message = TextEditingController();

  @override
  initState() {
    super.initState();
    db = DatabaseService.getMessages(widget.Thread_ID);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Group'),
        ),
        body: Form(
            key: _formKey,
            child: Column(children: [
              TextButton.icon(
                onPressed: () {
                  openRatingDialog(context);
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                    Colors.blue.withOpacity(0.2),
                  ),
                ),
                icon: Icon(Icons.star),
                label: Text(
                  'Rate this user convo',
                  style: Theme.of(context).textTheme.headline6,
                ),
              ),
              Text(widget.Thread_ID),
              Expanded(
                child: StreamBuilder<List<Message>>(
                  stream: db.messages,
                  builder: (BuildContext context,
                      AsyncSnapshot<List<Message>> snapshot) {
                    if (snapshot.hasError) {
                      return const Center(
                        child: Text("An error has occured!"),
                      );
                    } else if (snapshot.hasData) {
                      var messages = snapshot.data ?? [];
                      return messages.isEmpty
                          ? const Center(child: Text("NO Post"))
                          : ListView.builder(
                              itemCount: messages.length,
                              itemBuilder: (BuildContext context, int index) {
                                var colorTile;
                                if (messages[index].from ==
                                    _auth.currentUser!.uid) {
                                  colorTile = Colors.orange;
                                } else {
                                  colorTile = Colors.blue;
                                }

                                return ListTile(
                                  title: Text(messages[index].message),
                                  tileColor: colorTile,
                                );
                              });
                    }
                    return Loading();
                  },
                ),
              ),

              TextFormField(
                controller: _message,
                decoration: InputDecoration(
                    labelText: "Type A Message",
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
                      String now = DateTime.now().toString();

                      db.addNewMessage2(
                        widget.Thread_ID,
                        _message.text,
                        now,
                        _auth.currentUser!.uid,
                      );
                      _message.clear();
                    }
                  },
                  child: Text("SEND")),
            ])));
  }

  openRatingDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            child: RatingPage(uids: widget.uids),
          );
        });
  }
}
