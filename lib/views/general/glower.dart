import 'dart:ui';

import 'package:flutter/material.dart';

class Glower extends StatelessWidget {
  final Widget child;
  final Color color;
  final bool glow;

  Glower({
    @required this.child,
    @required this.color,
    this.glow = false,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        // if (glow)
        Positioned.fill(
          child: child,
        ),
        child,
      ],
    );
  }
}
