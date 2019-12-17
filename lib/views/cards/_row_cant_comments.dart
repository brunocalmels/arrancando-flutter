import 'package:arrancando/config/models/content_wrapper.dart';
import 'package:flutter/material.dart';

class RowCantComments extends StatelessWidget {
  final ContentWrapper content;
  final Color textColor;

  RowCantComments({
    @required this.content,
    this.textColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text(
          "${content.comentarios != null ? content.comentarios.length : 0}",
          style: TextStyle(
            color: textColor,
          ),
        ),
        SizedBox(
          width: 4,
        ),
        Icon(
          Icons.chat_bubble,
          color: textColor,
          size: 20,
        ),
      ],
    );
  }
}
