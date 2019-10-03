import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:its_12_oclock/screens/login/login.dart';
import 'package:its_12_oclock/screens/main/main.dart';
import 'package:its_12_oclock/services/sign_in.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'It\'s 12 o\'clock',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: _firstScreen(),
    );
  }

  Widget _firstScreen() {
    return FutureBuilder<FirebaseUser>(
      future: FirebaseAuth.instance.currentUser(),
      builder: (BuildContext context, AsyncSnapshot<FirebaseUser> snapshot) {
        if (snapshot.hasData) {
          fbUser = snapshot.data;
          return MainScreen();
        }
        return LoginScreen();
      },
    );
  }
}
