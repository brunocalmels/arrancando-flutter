import 'dart:convert';

import 'package:arrancando/config/models/publicacion.dart';
import 'package:arrancando/config/services/fetcher.dart';
import 'package:arrancando/views/cards/card_publicacion.dart';
import 'package:flutter/material.dart';

class PublicacionesPage extends StatelessWidget {
  _fetchPublicaciones() {
    return Fetcher.get(
      url: "/v2/deportes",
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ResponseObject>(
      future: _fetchPublicaciones(),
      builder: (context, AsyncSnapshot<ResponseObject> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data != null) {
            List<Publicacion> publicaciones =
                (json.decode(snapshot.data.body) as List)
                    // REMOVE THIS PART
                    .map(
                      (p) => {
                        "id": p['id'],
                        "titulo": p['nombre'],
                        "cuerpo": (p['nombre'] + " ") * 15,
                        "imagenes": [p["icon"]],
                      },
                    )
                    // REMOVE THIS PART
                    .map(
                      (p) => Publicacion.fromJson(p),
                    )
                    .toList();

            return Column(
              children: publicaciones
                  .map(
                    (p) => CardPublicacion(
                      publicacion: p,
                    ),
                  )
                  .toList(),
            );
          } else {
            return Text("Ocurrió un error");
          }
        } else {
          return Center(
            child: SizedBox(
              width: 25,
              height: 25,
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}
