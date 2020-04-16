import 'package:flutter/material.dart';

class TituloCabecera extends StatelessWidget {
  final String titulo;

  TituloCabecera({
    @required this.titulo,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.5,
      child: Text(
        titulo,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
