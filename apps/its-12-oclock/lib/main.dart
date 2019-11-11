import 'package:flutter/material.dart';
import 'package:its_12_oclock/routes/routes.dart';
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
      routes: () {
        Map<String, WidgetBuilder> routes = Routes.get(context);
        routes['/'] = (context) => _firstScreen(context);
        return routes;
      }(),
    );
  }

  Widget _firstScreen(BuildContext context) {
    Auth.getSignedInUser().then((user) {
      Navigator.pushReplacementNamed(context, Routes.home);
    }).catchError((onError) {
      Navigator.pushReplacementNamed(context, Routes.login);
    });
    return Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
