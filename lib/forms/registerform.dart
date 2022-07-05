import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social_app/forms/loginform.dart';
import 'package:social_app/shared.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({Key? key, required this.onTap}) : super(key: key);
  final Function onTap;

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  bool loading = false;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _username = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _bio = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Column(children: <Widget>[
          Positioned(
              top: 50,
              child: SizedBox(
                  height: 120,
                  width: 200,
                  child: Image.asset(
                    'assets/images/spongebob.png',
                  ))),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const <Widget>[
              Text(
                "Social Zone",
                style: TextStyle(fontSize: 40, fontFamily: "Signatra"),
              )
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 18),
              TextFormField(
                controller: _email,
                textAlign: TextAlign.center,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Email',
                    hintText: 'Enter valid email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Email cannot be empty";
                  }
                  if (!value.contains('@')) {
                    return "Email in wrong format";
                  }
                  return null;
                },
              ),
              TextFormField(
                textAlign: TextAlign.center,
                controller: _password,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Password',
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Password cannot be empty";
                  }
                  if (value.length < 7) {
                    return "Password too short.";
                  }
                  return null;
                },
              ),
              TextFormField(
                textAlign: TextAlign.center,
                controller: _username,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Username',
                    hintText: 'Enter the name you want your friends to see'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Username cannot be empty";
                  }
                  return null;
                },
              ),
              TextFormField(
                textAlign: TextAlign.center,
                controller: _bio,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Bio',
                    hintText: 'Tell us about yourself'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Bio cannot be empty";
                  }

                  return null;
                },
              ),
              OutlinedButton(
                  onPressed: () {
                    setState(() {
                      loading = true;
                      register();
                    });
                  },
                  child: const Text("REGISTER")),
              verticalSpaceSmall,
              TextButton(
                  onPressed: showLogin,
                  child: const Text(
                    'Already have an account? Log in here.',
                    style: TextStyle(color: Colors.blue, fontSize: 15),
                  ))
            ],
          ),
        ]));
  }

  Future<void> register() async {
    if (_formKey.currentState!.validate()) {
      try {
        UserCredential registerResponse =
            await _auth.createUserWithEmailAndPassword(
                email: _email.text, password: _password.text);

        _db
            .collection("users")
            .doc(registerResponse.user!.uid)
            .set({"name": _username.text, "bio": _bio.text})
            .then((value) => snackBar(context, "User registered successfully."))
            .catchError((error) => snackBar(context, "FAILED. $error"));

        registerResponse.user!.sendEmailVerification();
        setState(() {
          loading = false;
        });
      } catch (e) {
        setState(() {
          snackBar(context, e.toString());
          loading = false;
        });
      }
    }
  }

  void showLogin() {
    showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext context) {
          return Padding(
              padding: const EdgeInsets.all(50.0),
              child: LogInForm(onTap: widget.onTap));
        });
  }
}
