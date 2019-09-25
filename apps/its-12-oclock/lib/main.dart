import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'view/home/home_page.dart';
import 'view/login/login_page.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'It\'s 12 o\'clock',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: _firstPage(),
    );
  }

  Widget _firstPage() {
    return FutureBuilder<FirebaseUser>(
      future: FirebaseAuth.instance.currentUser(),
      builder: (BuildContext context, AsyncSnapshot<FirebaseUser> snapshot) {
          if (snapshot.hasData) {
            return HomePage(title: 'It\'s 12 o\'clock');
          }
          return LoginPage();
      },
    );
  }
}
