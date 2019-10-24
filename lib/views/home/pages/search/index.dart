import 'dart:convert';
import 'dart:math';

import 'package:arrancando/config/models/point_of_interest.dart';
import 'package:arrancando/config/models/publicacion.dart';
import 'package:arrancando/config/models/receta.dart';
import 'package:arrancando/config/services/fetcher.dart';
import 'package:arrancando/views/home/pages/_loading_widget.dart';
import 'package:arrancando/views/home/pages/search/_content_tile.dart';
import 'package:arrancando/views/home/pages/search/_data_group.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  final int activeItem;
  final bool sent;

  SearchPage({
    this.activeItem,
    this.sent,
  });

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final String _lorem =
      "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nam imperdiet nulla et aliquam convallis. Proin elementum enim non magna sollicitudin, id sollicitudin dui tincidunt. Aliquam maximus quam lectus, ut tempor dolor rhoncus eu. Donec quis diam lectus. Proin accumsan ac ipsum et congue. Mauris vitae lorem odio. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aenean tincidunt eros at purus ultricies aliquet. Curabitur viverra metus venenatis quam ultricies, sit amet efficitur magna elementum.";

  List<ContentWrapper> _publicaciones;
  List<ContentWrapper> _recetas;
  List<ContentWrapper> _pois;

  Map<String, bool> _fetching = {
    "publicaciones": false,
    "recetas": false,
    "pois": false,
  };

  _fetchPublicaciones() async {
    setState(() {
      _fetching["publicaciones"] = true;
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
              "cuerpo": _lorem,
              "imagenes": [p["get_icono"]],
            },
          )
          // REMOVE THIS PART
          .map(
            (p) => Publicacion.fromJson(p),
          )
          .map(
            (p) => ContentWrapper(
              id: p.id,
              title: p.titulo,
              image: p.imagenes.first,
              type: "publicacion",
            ),
          )
          .toList()
          .sublist(0, 3);

    _fetching["publicaciones"] = false;
    setState(() {});
  }

  _fetchRecetas() async {
    setState(() {
      _fetching["recetas"] = true;
    });

    ResponseObject resp = await Fetcher.get(
      url: "/v2/deportes123",
    );

    if (resp != null)
      _recetas = (json.decode(resp.body) as List)
          // REMOVE THIS PART
          .map(
            (p) => {
              "id": p['id'],
              "created_at": p['created_at'],
              "titulo": p['nombre'],
              "cuerpo": _lorem,
              "imagenes": [p["get_icono"]],
            },
          )
          // REMOVE THIS PART
          .map(
            (p) => Receta.fromJson(p),
          )
          .map(
            (p) => ContentWrapper(
              id: p.id,
              title: p.titulo,
              image: p.imagenes.first,
              type: "receta",
            ),
          )
          .toList()
          .sublist(0, 3);

    _fetching["recetas"] = false;
    setState(() {});
  }

  _fetchPois() async {
    setState(() {
      _fetching["pois"] = true;
    });

    ResponseObject resp = await Fetcher.get(
      url: "/v2/deportes",
    );

    if (resp != null)
      _pois = (json.decode(resp.body) as List)
          // REMOVE THIS PART
          .map(
            (p) => {
              "id": p['id'],
              "created_at": p['created_at'],
              "titulo": p['nombre'],
              "cuerpo": _lorem,
              "imagenes": [p["get_icono"]],
              "latitud": double.parse("-38.95${(Random().nextInt(99))}"),
              "longitud": double.parse("-68.05${(Random().nextInt(99))}"),
            },
          )
          // REMOVE THIS PART
          .map(
            (p) => PointOfInterest.fromJson(p),
          )
          .map(
            (p) => ContentWrapper(
              id: p.id,
              title: p.titulo,
              image: p.imagenes.first,
              type: "poi",
            ),
          )
          .toList()
          .sublist(0, 0);

    _fetching["pois"] = false;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _fetchPublicaciones();
    _fetchRecetas();
    _fetchPois();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        DataGroup(
          fetching: _fetching["publicaciones"],
          icon: Icons.public,
          title: "Publicaciones",
          items: _publicaciones,
        ),
        DataGroup(
          fetching: _fetching["recetas"],
          icon: Icons.book,
          title: "Recetas",
          items: _recetas,
        ),
        DataGroup(
          fetching: _fetching["pois"],
          icon: Icons.map,
          title: "Ptos. Interés",
          items: _pois,
        ),
        Container(
          height: 130,
          color: Color(0x05000000),
        ),
      ],
    );
  }
}
