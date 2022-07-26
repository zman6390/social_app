import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';
import 'package:social_app/pages/chat_page.dart';
import 'package:social_app/services/database.dart';

class ChatView extends StatefulWidget {
  final String chat_ident;
  final String thread_ID;
  List<String> user_ids;
  String chat_name = "";
  final String id;

  ChatView({
    required this.chat_ident,
    required this.thread_ID,
    required this.user_ids,
    required this.id,
  });
  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  late DatabaseService db;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  initState() {
    super.initState();
    db = DatabaseService();

    db.users!.first.then((key) {
      List<String> user_names = [];
      //var user_ids = widget.user.split(', ');
      widget.user_ids.forEach((id) {
        user_names.add(key.entries.firstWhere((e) => e.key == id).value.name);
      });
      setState(() {
        widget.chat_name = user_names.join(", ");
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        child: Column(
          //mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                GestureDetector(
                  onTap: (() => {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Chat_page(
                                      Thread_ID: widget.thread_ID,
                                      uids: widget.user_ids,
                                    )))
                      }),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      ProfilePicture(
                        name: widget.thread_ID,
                        radius: 20,
                        fontsize: 10,
                        random: true,
                      ),
                      const SizedBox(width: 0),
                      Text(
                        widget.chat_name,
                        style: TextStyle(
                            fontFamily: 'Lato',
                            fontSize: 20,
                            color: Colors.red),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Align(
              alignment: Alignment.topLeft,
              child: SizedBox(
                width: 500,
                height: 50,
                child: Text(
                  "Message ID: " + widget.thread_ID,
                  style: TextStyle(
                      fontFamily: 'Lato-Black',
                      fontSize: 17,
                      color: Colors.blue),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
