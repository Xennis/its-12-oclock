import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:its_12_oclock/services/google_maps/maps_places.dart';
import 'package:its_12_oclock/types/place.dart';

class PlaceLeading extends StatelessWidget {
  const PlaceLeading({Key key, @required this.place})
      : assert(place != null),
        super(key: key);

  final Place place;

  Widget build(BuildContext context) {
    if (place.photo == null) {
      return CircleAvatar(
        backgroundColor: Theme.of(context).primaryColor,
        child: Text(_placeAbbr(place.name)),
      );
    }

    final String photoUrl =
        MapsPlaces.photoUrl(placePhoto: place.photo, maxHeight: 100);

    return GestureDetector(
      onTap: () {
        // TODO: Display in the UI
        place.photo.htmlAttributions?.forEach((a) => print(a));
      },
      child: CircleAvatar(
        backgroundImage: CachedNetworkImageProvider(photoUrl),
      ),
    );
  }

  String _placeAbbr(String name) {
    List<String> split = name.split(' ');
    if (split.length == 0) {
      return '';
    } else if (split.length == 1) {
      return split[0][0];
    }
    return split[0][0] + split[1][0];
  }
}
