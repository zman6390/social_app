import 'package:social_app/driver.dart';
import 'package:flutter/material.dart';

class Provider extends InheritedWidget {
  final Driver auth;

  const Provider({Key? key, required Widget child, required this.auth})
      : super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return true;
  }

  static Provider of(BuildContext context) =>
      (context.dependOnInheritedWidgetOfExactType<Provider>() as Provider);
}
