import 'dart:convert';
import 'dart:math';

import 'package:arrancando/config/globals/enums.dart';
import 'package:arrancando/config/globals/index.dart';
import 'package:arrancando/config/models/content_wrapper.dart';
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
          ? "/publicaciones/search.json?term=${widget.searchController.text}&limit=3"
          : "/publicaciones.json",
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
          .map(
            (p) => ContentWrapper.fromOther(p, SectionType.publicaciones),
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
          ? "/recetas/search.json?term=${widget.searchController.text}&limit=3"
          : "/recetas.json",
    );

    if (resp != null)
      _recetas = (json.decode(resp.body) as List)
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
            (p) => Receta.fromJson(p),
          )
          .map(
            (p) => ContentWrapper.fromOther(p, SectionType.recetas),
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
          ? "/pois/search.json?term=${widget.searchController.text}&limit=3"
          : "/pois.json",
    );

    if (resp != null)
      _pois = (json.decode(resp.body) as List)
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
            (p) => PointOfInterest.fromJson(p),
          )
          .map(
            (p) => ContentWrapper.fromOther(p, SectionType.pois),
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
