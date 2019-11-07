import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:its_12_oclock/locales/locales.dart';
import 'package:its_12_oclock/routes/routes.dart';
import 'package:its_12_oclock/services/shared_prefs.dart';
import 'package:its_12_oclock/services/sign_in.dart';

void main() => runApp(App());

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();

  static void setLocale(BuildContext context, Locale newLocale) {
    _AppState state = context.ancestorStateOfType(TypeMatcher<_AppState>());
    state.locale = newLocale;
  }
}

class _AppState extends State<App> {
  Locale locale;

  @override
  void initState() {
    super.initState();
    SharedPrefs.getLocale().then((locale) {
      setState(() {
        this.locale = locale;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (this.locale == null) {
      return CircularProgressIndicator();
    }
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
      locale: locale,
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: Locales.supported.keys,
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
