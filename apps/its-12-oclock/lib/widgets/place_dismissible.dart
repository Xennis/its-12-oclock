import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class PlaceRecommendationDismissible extends StatelessWidget {
  const PlaceRecommendationDismissible(
      {@required key, this.child, this.onDismissed})
      : assert(key != null),
        super(key: key);

  final Widget child;
  final DismissDirectionCallback onDismissed;

  Widget build(BuildContext context) {
    return Dismissible(
        key: key,
        background: Container(
          alignment: AlignmentDirectional.centerStart,
          color: Theme.of(context).primaryColor,
          child: Padding(
              padding: EdgeInsets.fromLTRB(20.0, 0, 0, 0),
              child: Icon(Icons.thumb_up, color: Colors.white)),
        ),
        secondaryBackground: Container(
          alignment: AlignmentDirectional.centerEnd,
          color: Colors.red,
          child: Padding(
              padding: EdgeInsets.fromLTRB(0.0, 0.0, 20.0, 0),
              child: Icon(Icons.thumb_down, color: Colors.white)),
        ),
        onDismissed: onDismissed,
        child: child);
  }
}
