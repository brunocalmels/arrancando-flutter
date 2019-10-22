import 'package:arrancando/config/models/publicacion.dart';
import 'package:arrancando/config/my_globals.dart';
import 'package:flutter/material.dart';

class CardPublicacion extends StatelessWidget {
  final Publicacion publicacion;

  CardPublicacion({
    this.publicacion,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      height: 250,
      child: Card(
        child: Stack(
          fit: StackFit.passthrough,
          children: <Widget>[
            Positioned(
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Image.network(
                    "${MyGlobals.SERVER_URL}${publicacion.imagenes.first}"),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(publicacion.titulo),
                Text(publicacion.cuerpo),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
