import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:its_12_oclock/types/place.dart';
import 'package:its_12_oclock/widgets/place_leading.dart';

class PlaceCard extends StatelessWidget {
  const PlaceCard(
      {Key key, this.onTap, @required this.place, this.trailing, this.subtitle})
      : assert(place != null),
        super(key: key);

  final GestureTapCallback onTap;
  final Place place;
  final Widget trailing;
  final Widget subtitle;

  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Card(
            child: ListTile(
                onTap: onTap,
                leading: PlaceLeading(place: place),
                title: Text(place.name),
                trailing: trailing,
                subtitle: subtitle)),
      ],
    );
  }
}
