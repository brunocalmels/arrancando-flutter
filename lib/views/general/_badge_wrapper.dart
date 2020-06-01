import 'package:flutter/material.dart';

class BadgeWrapper extends StatelessWidget {
  final bool showBadge;
  final Widget child;

  BadgeWrapper({
    @required this.showBadge,
    @required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.passthrough,
      children: <Widget>[
        child,
        if (showBadge)
          Positioned(
            right: 0,
            top: 0,
            child: Padding(
              padding: const EdgeInsets.all(3),
              child: Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: Theme.of(context).accentColor,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          )
      ],
    );
  }
}
