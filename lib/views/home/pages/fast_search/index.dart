import 'dart:convert';
import 'dart:math';

import 'package:arrancando/config/globals/enums.dart';
import 'package:arrancando/config/globals/index.dart';
import 'package:arrancando/config/models/point_of_interest.dart';
import 'package:arrancando/config/models/publicacion.dart';
import 'package:arrancando/config/models/receta.dart';
import 'package:arrancando/config/services/fetcher.dart';
import 'package:arrancando/views/home/pages/fast_search/_content_tile.dart';
import 'package:arrancando/views/home/pages/fast_search/_data_group.dart';
import 'package:flutter/material.dart';

class FastSearchPage extends StatefulWidget {
  final bool sent;
  final TextEditingController searchController;

  FastSearchPage({
    this.sent,
    this.searchController,
  });

  @override
  _FastSearchPageState createState() => _FastSearchPageState();
}

class _FastSearchPageState extends State<FastSearchPage> {
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
    if (mounted)
      setState(() {
        _fetching["publicaciones"] = true;
      });

    ResponseObject resp = await Fetcher.get(
      url: widget.searchController.text != null &&
              widget.searchController.text.isNotEmpty
          ? "/v2/deportes/search/${widget.searchController.text}?limit=3"
          : "/v2/deportes",
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
              type: SectionType.publicaciones,
            ),
          )
          .toList();

    _fetching["publicaciones"] = false;
    if (mounted) setState(() {});
  }

  _fetchRecetas() async {
    if (mounted)
      setState(() {
        _fetching["recetas"] = true;
      });

    ResponseObject resp = await Fetcher.get(
      url: widget.searchController.text != null &&
              widget.searchController.text.isNotEmpty
          ? "/v2/deportes/search/${widget.searchController.text}?limit=3"
          : "/v2/deportes",
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
              type: SectionType.recetas,
            ),
          )
          .toList();

    _fetching["recetas"] = false;
    if (mounted) setState(() {});
  }

  _fetchPois() async {
    if (mounted)
      setState(() {
        _fetching["pois"] = true;
      });

    ResponseObject resp = await Fetcher.get(
      url: widget.searchController.text != null &&
              widget.searchController.text.isNotEmpty
          ? "/v2/deportes/search/${widget.searchController.text}?limit=3"
          : "/v2/deportes",
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
              type: SectionType.pois,
            ),
          )
          .toList();

    _fetching["pois"] = false;
    if (mounted) setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _fetchPublicaciones();
    _fetchRecetas();
    _fetchPois();
    widget.searchController.addListener(() {
      if (widget.searchController.text.isNotEmpty) {
        _fetchPublicaciones();
        _fetchRecetas();
        _fetchPois();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        DataGroup(
          fetching: _fetching["publicaciones"],
          icon: MyGlobals.ICONOS_CATEGORIAS[SectionType.publicaciones],
          title: "Publicaciones",
          items: _publicaciones,
          type: SectionType.publicaciones,
          searchController: widget.searchController,
        ),
        DataGroup(
          fetching: _fetching["recetas"],
          icon: MyGlobals.ICONOS_CATEGORIAS[SectionType.recetas],
          title: "Recetas",
          items: _recetas,
          type: SectionType.recetas,
          searchController: widget.searchController,
        ),
        DataGroup(
          fetching: _fetching["pois"],
          icon: MyGlobals.ICONOS_CATEGORIAS[SectionType.pois],
          title: "Ptos. Interés",
          items: _pois,
          type: SectionType.pois,
          searchController: widget.searchController,
        ),
        Container(
          height: 130,
          color: Color(0x05000000),
        ),
      ],
    );
  }
}
