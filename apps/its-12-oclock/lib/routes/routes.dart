import 'package:flutter/widgets.dart';
import 'package:its_12_oclock/screens/favourites.dart';
import 'package:its_12_oclock/screens/history.dart';
import 'package:its_12_oclock/screens/login/login.dart';
import 'package:its_12_oclock/screens/main/home.dart';
import 'package:its_12_oclock/screens/settings.dart';
import 'package:its_12_oclock/screens/support.dart';

class Routes {
  static const String favourites = FavouritesScreen.routeName;
  static const String login = LoginScreen.routeName;
  static const String history = HistoryScreen.routeName;
  static const String home = HomeScreen.routeName;
  static const String settings = SettingsScreen.routeName;
  static const String support = SupportScreen.routeName;

  static Map<String, WidgetBuilder> get(BuildContext context) {
    return {
      home: (context) => HomeScreen(),
      login: (context) => LoginScreen(),
      favourites: (context) => FavouritesScreen(),
      history: (context) => HistoryScreen(),
      settings: (context) => SettingsScreen(),
      support: (context) => SupportScreen(),
    };
  }
}
