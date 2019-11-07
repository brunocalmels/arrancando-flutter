import 'dart:convert';
import 'dart:math';

import 'package:arrancando/config/globals/enums.dart';
import 'package:arrancando/config/globals/index.dart';
import 'package:arrancando/config/models/point_of_interest.dart';
import 'package:arrancando/config/services/fetcher.dart';
import 'package:arrancando/config/state/index.dart';
import 'package:arrancando/views/cards/tile_poi.dart';
import 'package:arrancando/views/home/pages/_loading_widget.dart';
import 'package:arrancando/views/home/pages/_pois_map.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:latlong/latlong.dart';
import 'package:provider/provider.dart';

class PoiPage extends StatefulWidget {
  final String searchTerm;

  PoiPage({
    this.searchTerm,
  });

  @override
  _PoiPageState createState() => _PoiPageState();
}

class _PoiPageState extends State<PoiPage> {
  double _latitud = -38.950249;
  double _longitud = -68.059095;
  final double _zoom = 15;
  MapController _mapController;
  List<PointOfInterest> _pois;
  bool _fetching = true;

  Future<void> _fetchPois() async {
    // if (mounted)
    //   setState(() {
    //     _fetching = true;
    //   });

    int categoriaPoiId = Provider.of<MyState>(context, listen: false)
                .selectedCategoryHome[SectionType.pois] !=
            null
        ? Provider.of<MyState>(context, listen: false)
            .selectedCategoryHome[SectionType.pois]
        : Provider.of<MyState>(context, listen: false)
            .preferredCategories[SectionType.pois];

    ResponseObject resp = await Fetcher.get(
      url: widget.searchTerm != null && widget.searchTerm.isNotEmpty
          ? "/pois/search.json?term=${widget.searchTerm}"
          : "/pois.json${categoriaPoiId != null ? '?categoria_poi_id=' + "$categoriaPoiId" : ''}",
    );

    if (resp != null)
      _pois = (json.decode(resp.body) as List)
          // // REMOVE THIS PART
          // .map(
          //   (p) => {
          //     "id": p['id'],
          //     "created_at": p['created_at'],
          //     "titulo": p['nombre'],
          //     "cuerpo":
          //         "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nam imperdiet nulla et aliquam convallis. Proin elementum enim non magna sollicitudin, id sollicitudin dui tincidunt. Aliquam maximus quam lectus, ut tempor dolor rhoncus eu. Donec quis diam lectus. Proin accumsan ac ipsum et congue. Mauris vitae lorem odio. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aenean tincidunt eros at purus ultricies aliquet. Curabitur viverra metus venenatis quam ultricies, sit amet efficitur magna elementum.",
          //     "imagenes": [p["get_icono"]],
          //     "latitud": double.parse("-38.95${(Random().nextInt(99))}"),
          //     "longitud": double.parse("-68.05${(Random().nextInt(99))}"),
          //   },
          // )
          // // REMOVE THIS PART
          .map(
            (p) => PointOfInterest.fromJson(p),
          )
          .toList();
    _fetching = false;
    if (mounted) setState(() {});
  }

  _changeListener() {
    if (Provider.of<MyState>(context, listen: false)
            .selectedCategoryHome[SectionType.pois] !=
        null) _fetchPois();
  }

  @override
  void initState() {
    super.initState();
    _fetchPois();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<MyState>(MyGlobals.mainNavigatorKey.currentContext)
          .addListener(_changeListener);
    });
  }

  @override
  void dispose() {
    Provider.of<MyState>(MyGlobals.mainNavigatorKey.currentContext)
        .removeListener(_changeListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _fetchPois,
      child: ListView(
        children: <Widget>[
          PoisMap(
            height: MediaQuery.of(context).size.height * 0.33,
            latitud: _latitud,
            longitud: _longitud,
            zoom: _zoom,
            buildCallback: (MapController controller) {
              _mapController = controller;
            },
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.66,
            child: _fetching
                ? LoadingWidget()
                : _pois != null
                    ? _pois.length > 0
                        ? ListView.builder(
                            padding: const EdgeInsets.all(0),
                            itemCount: _pois.length,
                            itemBuilder: (BuildContext context, int index) {
                              PointOfInterest p = _pois[index];
                              Widget item = TilePoi(
                                poi: p,
                                onTap: () {
                                  if (_mapController != null) {
                                    _mapController.move(
                                        LatLng(
                                          p.latitud,
                                          p.longitud,
                                        ),
                                        _zoom);
                                    _latitud = p.latitud;
                                    _longitud = p.longitud;
                                    if (mounted) setState(() {});
                                  }
                                },
                              );
                              if (index == _pois.length - 1)
                                return Column(
                                  children: <Widget>[
                                    item,
                                    Container(
                                      height: 200,
                                      color: Color(0x05000000),
                                    ),
                                  ],
                                );
                              else
                                return item;
                            },
                          )
                        : Text("No hay puntos para mostrar")
                    : Text("Ocurrió un error"),
          ),
        ],
      ),
    );
  }
}
