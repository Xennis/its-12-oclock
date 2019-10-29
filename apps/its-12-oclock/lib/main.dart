import 'package:flutter/material.dart';
import 'package:its_12_oclock/routes/routes.dart';
import 'package:its_12_oclock/screens/history.dart';
import 'package:its_12_oclock/screens/login/login.dart';
import 'package:its_12_oclock/screens/main/home.dart';
import 'package:its_12_oclock/screens/settings.dart';
import 'package:its_12_oclock/screens/support.dart';
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
        '/': (context) => _firstScreen(context),
        Routes.home: (context) => HomeScreen(),
        Routes.login: (context) => LoginScreen(),
        Routes.history: (context) => HistoryScreen(),
        Routes.settings: (context) => SettingsScreen(),
        Routes.support: (context) => SupportScreen(),
      },
    );
  }

  Widget _firstScreen(BuildContext context) {
    Auth.getSignedInUser().then((user) {
      Navigator.pushReplacementNamed(context, Routes.home);
    }).catchError((onError) {
      Navigator.pushReplacementNamed(context, Routes.login);
    });
    return Center(child: CircularProgressIndicator());
  }
}
