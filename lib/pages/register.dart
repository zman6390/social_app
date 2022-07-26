import 'package:social_app/pages/home.dart';
import 'package:social_app/forms/registerform.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({Key? key}) : super(key: key);

  static const String routeName = '/register';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [Colors.teal, Colors.purple])),
      child: Column(
        children: <Widget>[
          RegisterForm(onTap: () => _successfulSignUp(context)),
        ],
      ),
    ));
  }

  static void _successfulSignUp(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (BuildContext context) => const HomePage()),
      ModalRoute.withName('/'),
    );
  }
}
