import 'dart:math';

import 'package:flutter/material.dart';

import '../services/database.dart';

class RatingPage extends StatefulWidget {
  //const RatingPage({Key? key}) : super(key: key);
  final List<String> uids;

  RatingPage({
    required this.uids,
  });

  @override
  State<RatingPage> createState() => _RatingPageState();
}

class _RatingPageState extends State<RatingPage> {
  var _ratingPageController = PageController();
  var _starPosition = 200.0;
  var _rating = 0;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(children: [
        Container(
            height: max(300, MediaQuery.of(context).size.height * 0.3),
            child: PageView(
                controller: _ratingPageController,
                physics: NeverScrollableScrollPhysics(),
                children: [
                  _ThanksNote(),
                  _ratingCause(),
                ])),
        Center(
            child: Text(
          _rating.toString(),
          style: TextStyle(
            fontSize: 70,
            color: Colors.red,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        )),
        Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              color: Colors.red,
              child: MaterialButton(
                onPressed: () {
                  DatabaseService().rateConvo(widget.uids, _rating);
                  Navigator.pop(context);
                },
                child: Text('Done'),
                textColor: Colors.white,
              ),
            )),
        AnimatedPositioned(
          top: _starPosition,
          left: 0,
          right: 0,
          duration: const Duration(seconds: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
                5,
                (index) => IconButton(
                      icon: index < _rating
                          ? Icon(Icons.star, size: 32)
                          : Icon(Icons.star_border, size: 32),
                      color: Colors.blue,
                      onPressed: () {
                        setState(() {
                          _starPosition = 20.0;
                          _rating = index + 1;
                        });
                      },
                    )),
          ),
        ),
      ]),
    );
  }

  _ThanksNote() {
    return Column(
      children: [
        Text(
          "Thanks for chatting!",
          style: TextStyle(
            fontSize: 23,
            color: Colors.green,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        Text("How was the convo?")
      ],
    );
  }

  _ratingCause() {
    return Container();
  }
}
