import 'package:arrancando/config/fonts/arrancando_icons_icons.dart';
import 'package:flutter/material.dart';

class RowIconos extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          width: 50,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.timer,
                color: Theme.of(context).accentColor,
              ),
              Text(
                "40 minutos",
                textAlign: TextAlign.center,
                overflow: TextOverflow.visible,
                softWrap: false,
                style: TextStyle(
                  fontSize: 9,
                ),
              ),
            ],
          ),
        ),
        Container(
          width: 50,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.crop_square,
                color: Theme.of(context).accentColor,
              ),
              Text(
                "Horno",
                textAlign: TextAlign.center,
                overflow: TextOverflow.visible,
                softWrap: false,
                style: TextStyle(
                  fontSize: 9,
                ),
              ),
            ],
          ),
        ),
        Container(
          width: 50,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.add_box,
                color: Theme.of(context).accentColor,
              ),
              Text(
                "Facil",
                textAlign: TextAlign.center,
                overflow: TextOverflow.visible,
                softWrap: false,
                style: TextStyle(
                  fontSize: 9,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
