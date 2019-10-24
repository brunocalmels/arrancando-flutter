import 'dart:convert';

import 'package:arrancando/config/models/receta.dart';
import 'package:arrancando/config/services/fetcher.dart';
import 'package:arrancando/views/cards/card_receta.dart';
import 'package:arrancando/views/home/pages/_loading_widget.dart';
import 'package:flutter/material.dart';

class RecetasPage extends StatelessWidget {
  Future<List<Receta>> _fetchPublicaciones() async {
    List<Receta> recetas;

    ResponseObject resp = await Fetcher.get(
      url: "/v2/deportes",
    );

    if (resp != null)
      recetas = (json.decode(resp.body) as List)
          // REMOVE THIS PART
          .map(
            (r) => {
              "id": r['id'],
              "created_at": r['created_at'],
              "titulo": r['nombre'],
              "cuerpo":
                  "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nam imperdiet nulla et aliquam convallis. Proin elementum enim non magna sollicitudin, id sollicitudin dui tincidunt. Aliquam maximus quam lectus, ut tempor dolor rhoncus eu. Donec quis diam lectus. Proin accumsan ac ipsum et congue. Mauris vitae lorem odio. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aenean tincidunt eros at purus ultricies aliquet. Curabitur viverra metus venenatis quam ultricies, sit amet efficitur magna elementum.",
              "imagenes": [r["get_icono"]],
            },
          )
          // REMOVE THIS PART
          .map(
            (r) => Receta.fromJson(r),
          )
          .toList();

    return recetas;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Receta>>(
      future: _fetchPublicaciones(),
      builder: (context, AsyncSnapshot<List<Receta>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return LoadingWidget();
        } else {
          if (snapshot.data != null) {
            if (snapshot.data.length > 0) {
              return Column(
                children: snapshot.data
                    .map(
                      (r) => CardReceta(
                        receta: r,
                      ),
                    )
                    .toList(),
              );
            } else {
              return Text("No hay recetas para mostrar");
            }
          } else {
            return Text("Ocurrió un error");
          }
        }
      },
    );
  }
}
