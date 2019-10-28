import 'dart:convert';

import 'package:arrancando/config/models/publicacion.dart';
import 'package:arrancando/config/services/fetcher.dart';
import 'package:arrancando/views/cards/card_publicacion.dart';
import 'package:arrancando/views/home/pages/_loading_widget.dart';
import 'package:flutter/material.dart';

class PublicacionesPage extends StatefulWidget {
  final String searchTerm;

  PublicacionesPage({
    this.searchTerm,
  });

  @override
  _PublicacionesPageState createState() => _PublicacionesPageState();
}

class _PublicacionesPageState extends State<PublicacionesPage> {
  List<Publicacion> _publicaciones;
  bool _fetching = false;

  _fetchPublicaciones() async {
    if (mounted)
      setState(() {
        _fetching = true;
      });

    ResponseObject resp = await Fetcher.get(
      url: widget.searchTerm != null && widget.searchTerm.isNotEmpty
          ? "/publicaciones/search?term=${widget.searchTerm}"
          : "/publicaciones",
    );

    if (resp != null)
      _publicaciones = (json.decode(resp.body) as List)
          // REMOVE THIS PART
          .map(
            (p) => json.decode(json.encode({
              ...p,
              "imagenes": [
                "https://info135.com.ar/wp-content/uploads/2019/08/macri-gato-1170x600-678x381.jpg"
              ],
            })),
          )
          // REMOVE THIS PART
          .map(
            (p) => Publicacion.fromJson(p),
          )
          .toList();

    _fetching = false;
    if (mounted) setState(() {});
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
