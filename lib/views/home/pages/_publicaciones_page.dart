import 'dart:convert';

import 'package:arrancando/config/models/publicacion.dart';
import 'package:arrancando/config/services/fetcher.dart';
import 'package:arrancando/views/cards/card_publicacion.dart';
import 'package:arrancando/views/home/pages/_loading_widget.dart';
import 'package:flutter/material.dart';

class PublicacionesPage extends StatelessWidget {
  Future<List<Publicacion>> _fetchPublicaciones() async {
    List<Publicacion> publicaciones;

    ResponseObject resp = await Fetcher.get(
      url: "/v2/deportes",
    );

    if (resp != null)
      publicaciones = (json.decode(resp.body) as List)
          // REMOVE THIS PART
          .map(
            (p) => {
              "id": p['id'],
              "created_at": p['created_at'],
              "titulo": p['nombre'],
              "cuerpo":
                  "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nam imperdiet nulla et aliquam convallis. Proin elementum enim non magna sollicitudin, id sollicitudin dui tincidunt. Aliquam maximus quam lectus, ut tempor dolor rhoncus eu. Donec quis diam lectus. Proin accumsan ac ipsum et congue. Mauris vitae lorem odio. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aenean tincidunt eros at purus ultricies aliquet. Curabitur viverra metus venenatis quam ultricies, sit amet efficitur magna elementum.",
              "imagenes": [p["get_icono"]],
            },
          )
          // REMOVE THIS PART
          .map(
            (p) => Publicacion.fromJson(p),
          )
          .toList();

    return publicaciones;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Publicacion>>(
      future: _fetchPublicaciones(),
      builder: (context, AsyncSnapshot<List<Publicacion>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return LoadingWidget();
        } else {
          if (snapshot.data != null) {
            if (snapshot.data.length > 0) {
              return Column(
                children: snapshot.data
                    .map(
                      (p) => CardPublicacion(
                        publicacion: p,
                      ),
                    )
                    .toList(),
              );
            } else {
              return Text("No hay publicaciones para mostrar");
            }
          } else {
            return Text("Ocurrió un error");
          }
        }
      },
    );
  }
}
