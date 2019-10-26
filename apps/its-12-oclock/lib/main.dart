import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:its_12_oclock/routes/routes.dart';
import 'package:its_12_oclock/screens/history.dart';
import 'package:its_12_oclock/screens/login/login.dart';
import 'package:its_12_oclock/screens/main/main.dart';
import 'package:its_12_oclock/screens/settings.dart';
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
      initialRoute: '/',
      routes: {
        '/': (context) => _firstScreen(),
        Routes.main: (context) => MainScreen(),
        Routes.login: (context) => LoginScreen(),
        Routes.history: (context) => HistoryScreen(),
        Routes.settings: (context) => SettingsScreen(),
      },
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
