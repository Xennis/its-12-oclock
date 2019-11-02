import 'package:flutter/material.dart';

class Event {
  static final Event liked = Event(
    name: 'liked',
    score: 1,
    iconData: Icons.thumb_up,
  );
  static final Event disliked = Event(
    name: 'disliked',
    score: -1,
    iconData: Icons.thumb_down,
  );
  static final Event launchMaps = Event(
    name: 'launch_maps',
    score: 2,
    iconData: Icons.map,
  );
  static final Event clicked =
      Event(name: 'clicked', score: 3, iconData: Icons.check_circle);

  final String name;
  final num score;
  final IconData iconData;

  Event({this.name, this.score, this.iconData});

  factory Event.fromName(String name) {
    switch (name) {
      case 'liked':
        return liked;
      case 'disliked':
        return disliked;
      case 'launch_maps':
        return launchMaps;
      case 'clicked':
        return clicked;
    }
    throw Exception('Event with name $name does not exist');
  }
}
