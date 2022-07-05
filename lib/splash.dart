import 'package:flutter/material.dart';
import 'package:social_app/pages/home.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    _navigatetohome();
  }

  _navigatetohome() async {
    await Future.delayed(Duration(milliseconds: 1500), () {});
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const HomePage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(children: [
        Container(
          height: 120,
          width: 120,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images.icons.png"),
              fit: BoxFit.fill,
            ),
            shape: BoxShape.circle,
          ),
          child: Text(
            "Social Zone",
            style: TextStyle(
              fontSize: 40,
              fontFamily: 'Signatra',
            ),
          ),
        ),
      ]),
    ));
  }
}
