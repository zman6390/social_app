import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social_app/models/chat.dart';
import 'package:social_app/models/message.dart';
import 'package:social_app/models/post.dart';
import 'package:social_app/models/user.dart';

class DatabaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Map<String, User> userMap = <String, User>{};

  final StreamController<Map<String, User>> _usersController =
      StreamController<Map<String, User>>();

  final StreamController<List<Post>> _postsController =
      StreamController<List<Post>>();
  final StreamController<List<Message>> _messagesController =
      StreamController<List<Message>>();
  final StreamController<List<Chat_blueprint>> _chatsController =
      StreamController<List<Chat_blueprint>>();

  DatabaseService() {
    _firestore.collection('users').snapshots().listen(_usersUpdated);
    _firestore.collection('posts').snapshots().listen(_postsUpdated);
    _firestore.collection('chats').snapshots().listen(_chatsUpdated);
  }

  DatabaseService.getMessages(String thread_id) {
    _firestore
        .collection('messages')
        .where('to', isEqualTo: thread_id)
        .snapshots()
        .listen(_messagesUpdated);
  }

  Stream<Map<String, User>>? get users => _usersController.stream;
  Stream<List<Post>>? get posts => _postsController.stream;
  Stream<List<Chat_blueprint>>? get chats => _chatsController.stream;
  Stream<List<Message>>? get messages => _messagesController.stream;

  void _usersUpdated(QuerySnapshot<Map<String, dynamic>> snapshot) {
    var users = _getUsersFromSnapshot(snapshot);
    _usersController.add(users);
  }

  void _postsUpdated(QuerySnapshot<Map<String, dynamic>> snapshot) {
    var posts = _getPostsFromSnapshot(snapshot);
    _postsController.add(posts);
  }

  void _chatsUpdated(QuerySnapshot<Map<String, dynamic>> snapshot) {
    List<Chat_blueprint> chats = _getChatsFromSnapshot(snapshot);
    _chatsController.add(chats);
  }

  void _messagesUpdated(QuerySnapshot<Map<String, dynamic>> snapshot) {
    List<Message> messages = _getMessagesFromSnapshot(snapshot);
    _messagesController.add(messages);
  }

  Map<String, User> _getUsersFromSnapshot(
      QuerySnapshot<Map<String, dynamic>> snapshot) {
    for (var element in snapshot.docs) {
      User user = User.fromMap(element.id, element.data());
      userMap[user.id] = user;
    }

    return userMap;
  }

  List<Post> _getPostsFromSnapshot(
      QuerySnapshot<Map<String, dynamic>> snapshot) {
    List<Post> posts = [];
    for (var element in snapshot.docs) {
      Post post = Post.fromMap(element.id, element.data());
      posts.add(post);
    }
    posts.sort((a, b) => a.created.compareTo(b.created));
    return posts;
  }

  List<Message> _getMessagesFromSnapshot(
      QuerySnapshot<Map<String, dynamic>> snapshot) {
    List<Message> messages = [];

    for (var element in snapshot.docs) {
      Message post = Message.fromMap(element.id, element.data());

      messages.add(post);
    }
    messages.sort((a, b) => a.time.compareTo(b.time));
    return messages;
  }

  List<Chat_blueprint> _getChatsFromSnapshot(
      QuerySnapshot<Map<String, dynamic>> snapshot) {
    List<Chat_blueprint> conversations = [];
    for (var element in snapshot.docs) {
      Chat_blueprint conversation =
          Chat_blueprint.fromMap(element.id, element.data());
      final List<String> split_users = element.data()['users'].split(' ');
      for (var e in split_users) {
        conversation.users.add(e);
      }
      conversations.add(conversation);
    }

    return conversations;
  }

  Future<User> getUser(String uid) async {
    var snapshot = await _firestore.collection("users").doc(uid).get();
    return User.fromMap(snapshot.id, (snapshot.data()!));
  }

  Future<void> setUser(
      String uid, String displayName, String email, String bio) async {
    await _firestore.collection("users").doc(uid).set({
      "bio": bio,
      "name": displayName,
      "type": "USER",
      "email": email,
      "created": DateTime.now(),
      'rating_total': 0,
      'rating_count': 0,
      'rating_average': 0.0
    });
    return;
  }

  Future<void> rateConvo(List<String> uids, int rating) async {
    uids.forEach((uid) async {
      var user = await getUser(uid);
      int new_total = user.rating_total + rating;
      int new_count = user.rating_count + 1;
      print("tot: $new_total count: $new_count");
      double new_average = new_total.toDouble() / new_count;
      print("average: $new_average");
      _firestore.collection("users").doc(uid).update({
        "rating_total": new_total,
        "rating_count": new_count,
        "rating_average": new_average
      });
    });
    return;
  }

  Future<void> addPost(String uid, String message, String display_name) async {
    await _firestore.collection("posts").add({
      'message': message,
      'display_name': display_name,
      'type': 0,
      'owner': uid,
      "created": DateTime.now()
    });
    return;
  }

  Future<void> addNewMessage(
    Set<String> users,
    String user_uid,
    String message,
  ) async {
    print("Users: " + users.toString());
    String now = DateTime.now().toString();
    var rng = Random();
    var code = (rng.nextInt(900000) + 100000).toString();
    try {
      print("chats");
      await _firestore
          .collection('chats')
          .add({'users': users.toString(), 'thread_ID': code}).whenComplete(
              () => addNewMessage2(
                    code,
                    message,
                    now,
                    user_uid,
                  ));
    } on Exception catch (e) {
      print(e.toString() + "<================");
    }

    return;
  }

  Future<void> addNewMessage2(
      String code, String message, String now, String user_uid) async {
    print("Code: " + code);

    try {
      print("messages");

      await _firestore.collection('messages').add({
        'to': code,
        'from': user_uid,
        'message': message,
        'time': now,
      }).whenComplete(() => print("===============>>" + "Complete message"));
    } on Exception catch (e) {
      print(e.toString() + "<================");
    }

    return;
  }
}
