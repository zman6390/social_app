import 'package:social_app/routes/router.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'driver.dart';
import 'widgets/loading.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(social_app());
}

class social_app extends StatelessWidget {
  social_app({Key? key}) : super(key: key);
  final Future<FirebaseApp> _initializer = Firebase.initializeApp();

  @override
  Widget build(
    BuildContext context,
  ) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        onGenerateRoute: AppRouter.generateRoute,
        home: FutureBuilder(
            future: _initializer,
            builder: (context, AsyncSnapshot<FirebaseApp> snapshot) {
              if (snapshot.hasError) {
                print(snapshot.error);
                return SizedBox();
              } else if (snapshot.connectionState == ConnectionState.done &&
                  snapshot.data != null) {
                return Driver();
              }
              return const Loading();
            }));
  }
}
