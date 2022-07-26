import 'package:social_app/pages/home.dart';
import 'package:social_app/pages/register.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Driver extends StatelessWidget {
  Driver({Key? key}) : super(key: key);
  static const String routeName = '/driver';
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    var stream = _auth.idTokenChanges();
    stream.listen((event) {
      User;
    });
    if (_auth.currentUser != null) {
      return const HomePage();
    } else {
      return const RegisterPage();
    }
  }

  Future getCurrentUser() async {
    return _auth.currentUser;
  }
}
