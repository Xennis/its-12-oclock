import 'package:flutter/material.dart';

void main() => runApp(App());

class App extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'It\'s 12 o\'clock',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: HomePage(title: 'It\'s 12 o\'clock'),
    );
  }
}

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
              onPressed: _saveCurrentRestaurant,
              color: Theme.of(context).primaryColor,
              textColor: Colors.white,
              child: Text("Save restaurant"),
            ),
          ],
        ),
      ),
    );
  }

  _saveCurrentRestaurant() {

  }
}
