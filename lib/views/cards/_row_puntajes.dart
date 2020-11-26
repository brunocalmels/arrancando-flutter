import 'package:arrancando/config/models/content_wrapper.dart';
import 'package:flutter/material.dart';

class RowPuntajes extends StatelessWidget {
  final ContentWrapper content;
  final Color textColor;

  RowPuntajes({
    @required this.content,
    this.textColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Icon(
          Icons.star,
          color: Colors.yellow,
          size: 20,
        ),
        SizedBox(
          width: 3,
        ),
        Text(
          '${content.puntajePromedio.toStringAsFixed(1)}',
          style: TextStyle(
            color: textColor,
          ),
        ),
        SizedBox(
          width: 7,
        ),
        Text(
          '(',
          style: TextStyle(
            color: textColor,
          ),
        ),
        Text(
          '${content.puntajes != null ? content.puntajes.length : ''}',
          style: TextStyle(
            color: textColor,
          ),
        ),
        Icon(
          Icons.person,
          color: textColor,
          size: 20,
        ),
        Text(
          ')',
          style: TextStyle(
            color: textColor,
          ),
        ),
      ],
    );
  }
}
