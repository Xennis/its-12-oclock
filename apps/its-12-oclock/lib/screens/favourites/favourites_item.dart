import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:its_12_oclock/types/place.dart';
import 'package:its_12_oclock/widgets/place_leading.dart';

class FavouritePlaceCard extends StatelessWidget {
  const FavouritePlaceCard({Key key, @required this.place, this.score})
      : assert(place != null),
        super(key: key);

  final Place place;
  final num score;

  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Card(
            child: ListTile(
                leading: PlaceLeading(place: place),
                title: Text(place.name),
                subtitle: Row(children: <Widget>[
                  Text('Score: $score'),
                ]))),
      ],
    );
  }
}

