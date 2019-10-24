import 'dart:convert';

import 'package:arrancando/config/models/publicacion.dart';
import 'package:arrancando/config/services/fetcher.dart';
import 'package:arrancando/views/cards/card_publicacion.dart';
import 'package:arrancando/views/home/pages/_loading_widget.dart';
import 'package:flutter/material.dart';

class PublicacionesPage extends StatefulWidget {
  @override
  _PublicacionesPageState createState() => _PublicacionesPageState();
}

class _PublicacionesPageState extends State<PublicacionesPage> {
  List<Publicacion> _publicaciones;
  bool _fetching = false;

  _fetchPublicaciones() async {
    setState(() {
      _fetching = true;
    });

    ResponseObject resp = await Fetcher.get(
      url: "/v2/deportes",
    );

    if (resp != null)
      _publicaciones = (json.decode(resp.body) as List)
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

    _fetching = false;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _fetchPublicaciones();
  }

  @override
  Widget build(BuildContext context) {
    return _fetching
        ? LoadingWidget()
        : _publicaciones != null
            ? _publicaciones.length > 0
                ? Column(
                    children: [
                      ..._publicaciones
                          .map(
                            (p) => CardPublicacion(
                              publicacion: p,
                            ),
                          )
                          .toList(),
                      Container(
                        height: 100,
                        color: Color(0x05000000),
                      ),
                    ],
                  )
                : Text("No hay publicaciones para mostrar")
            : Text("Ocurrió un error");
  }
}
