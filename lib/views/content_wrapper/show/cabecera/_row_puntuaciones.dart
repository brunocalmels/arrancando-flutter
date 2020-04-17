import 'package:arrancando/config/models/content_wrapper.dart';
import 'package:flutter/material.dart';

class RowPuntuaciones extends StatelessWidget {
  final ContentWrapper content;

  RowPuntuaciones({
    @required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text(
          "${content.puntajePromedio.toStringAsFixed(1)}",
        ),
        SizedBox(
          width: 5,
        ),
        Text(
          "${content.puntajes != null ? content.puntajes.length : ''}",
        ),
        Icon(
          Icons.person,
          size: 20,
          color: Theme.of(context).accentColor,
        ),
      ],
    );
  }
}
