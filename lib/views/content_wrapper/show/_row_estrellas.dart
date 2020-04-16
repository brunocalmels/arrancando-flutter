import 'package:arrancando/config/models/content_wrapper.dart';
import 'package:flutter/material.dart';

class RowEstrellas extends StatelessWidget {
  final ContentWrapper content;

  RowEstrellas({
    @required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [1, 2, 3, 4, 5]
          .map(
            (p) => Icon(
              content.puntajePromedio >= p
                  ? Icons.star
                  : content.puntajePromedio > p - 1
                      ? Icons.star_half
                      : Icons.star_border,
              color: Theme.of(context).accentColor,
            ),
          )
          .toList(),
    );
  }
}
