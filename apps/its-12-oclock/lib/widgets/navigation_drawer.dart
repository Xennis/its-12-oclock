import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:its_12_oclock/routes/routes.dart';
import 'package:its_12_oclock/services/sign_in.dart';

class NavigationDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          _createHeader(Auth.fbUser),
          _createItem(
              icon: Icons.place,
              text: 'Places',
              onTap: () => Navigator.popAndPushNamed(context, Routes.places)),
          _createItem(
              icon: Icons.history,
              text: 'History',
              onTap: () => Navigator.popAndPushNamed(context, Routes.history)),
          Divider(),
          _createItem(
              icon: Icons.settings,
              text: 'Settings',
              onTap: () => Navigator.popAndPushNamed(context, Routes.settings)),
          _createItem(
              icon: Icons.help_outline,
              text: 'Help & feedback',
              onTap: () => Navigator.popAndPushNamed(context, Routes.support)),
        ],
      ),
    );
  }

  Widget _createHeader(FirebaseUser user) {
    return UserAccountsDrawerHeader(
      accountName: Text(user.displayName),
      accountEmail: Text(user.email),
      currentAccountPicture: CircleAvatar(
        backgroundImage: CachedNetworkImageProvider(user.photoUrl),
      ),
    );
  }

  Widget _createItem({IconData icon, String text, GestureTapCallback onTap}) {
    Color color = Colors.grey[700];
    return ListTile(
      title: Row(
        children: <Widget>[
          Icon(icon, color: color),
          Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: Text(text, style: TextStyle(color: color)),
          )
        ],
      ),
      onTap: onTap,
    );
  }
}
