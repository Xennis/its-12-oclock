import 'package:flutter/widgets.dart';
import 'package:its_12_oclock/screens/favourites.dart';
import 'package:its_12_oclock/screens/visits.dart';
import 'package:its_12_oclock/screens/login/login.dart';
import 'package:its_12_oclock/screens/main/home.dart';
import 'package:its_12_oclock/screens/settings.dart';
import 'package:its_12_oclock/screens/support.dart';

class Routes {
  static const String favourites = FavouritesScreen.routeName;
  static const String login = LoginScreen.routeName;
  static const String visits = VisitsScreen.routeName;
  static const String home = HomeScreen.routeName;
  static const String settings = SettingsScreen.routeName;
  static const String support = SupportScreen.routeName;

  static Map<String, WidgetBuilder> get(BuildContext context) {
    return {
      home: (context) => HomeScreen(),
      login: (context) => LoginScreen(),
      favourites: (context) => FavouritesScreen(),
      visits: (context) => VisitsScreen(),
      settings: (context) => SettingsScreen(),
      support: (context) => SupportScreen(),
    };
  }
}
