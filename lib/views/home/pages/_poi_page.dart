import 'dart:convert';

import 'package:arrancando/config/globals/enums.dart';
import 'package:arrancando/config/models/active_user.dart';
import 'package:arrancando/config/models/content_wrapper.dart';
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
  final bool sortByFecha;

  PoiPage({
    this.searchTerm,
    this.sortByFecha = true,
  });

  @override
  _PoiPageState createState() => _PoiPageState();
}

class _PoiPageState extends State<PoiPage> {
  double _latitud = -38.950249;
  double _longitud = -68.059095;
  final double _zoom = 15;
  MapController _mapController;
  List<ContentWrapper> _pois;
  bool _fetching = true;
  bool _locationDenied = false;
  int _limit = 20;
  bool _noMore = false;
  bool _loadingMore = false;
  Map<int, double> _calculatedDistance = {};

  Future<void> _fetchPois() async {
    int lastLength = _pois != null ? _pois.length : 0;

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
          : "/pois.json?limit=$_limit${categoriaPoiId != null && categoriaPoiId != -1 ? '&categoria_poi_id=$categoriaPoiId' : ''}",
    );

    if (resp != null) {
      _pois = (json.decode(resp.body) as List).map(
        (p) {
          var content = ContentWrapper.fromJson(p);
          content.type = SectionType.pois;
          return content;
        },
      ).toList();

      _locationDenied = await ActiveUser.locationPermissionDenied();

      if (widget.sortByFecha)
        _sortByDistance();
      else
        _pois.sort((a, b) => a.puntajePromedio > b.puntajePromedio ? -1 : 1);

      _limit += 20;
      _noMore = lastLength == _pois.length ? true : false;
      _loadingMore = false;
    }
    _fetching = false;
    if (mounted) setState(() {});
  }

  // _changeListener() {
  //   if (Provider.of<MyState>(context, listen: false)
  //           .selectedCategoryHome[SectionType.pois] !=
  //       null) _fetchPois();
  // }

  _sortByDistance() async {
    if (!_locationDenied && _pois != null) {
      await Future.wait(
        _pois.map(
          (i) async {
            if (_calculatedDistance[i.id] == null) {
              double localDistance = await i.distancia;
              _calculatedDistance[i.id] = localDistance;
            } else
              i.localDistance = _calculatedDistance[i.id];
            return null;
          },
        ),
      );
      _pois?.sort((a, b) => a.localDistance != null &&
              b.localDistance != null &&
              a.localDistance < b.localDistance
          ? -1
          : 1);
      if (mounted) setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    _resetLimit();
    _fetchPois();
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   Provider.of<MyState>(MyGlobals.mainNavigatorKey.currentContext)
    //       .addListener(_changeListener);
    // });
  }

  // @override
  // void dispose() {
  //   Provider.of<MyState>(MyGlobals.mainNavigatorKey.currentContext)
  //       .removeListener(_changeListener);
  //   super.dispose();
  // }

  _resetLimit() {
    _pois = null;
    _fetching = true;
    _noMore = false;
    _limit = 20;
    if (mounted) setState(() {});
  }

  @override
  void didUpdateWidget(PoiPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    _resetLimit();
    _fetchPois();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () {
        _resetLimit();
        return _fetchPois();
      },
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
                              // if (index == _pois.length - 1 && !_noMore) {
                              //   print('aca');
                              //   _fetchPois();
                              // }
                              ContentWrapper p = _pois[index];
                              Widget item = TilePoi(
                                poi: p,
                                locationDenied: _locationDenied,
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
                              if (index == _pois.length - 1) {
                                if (!_noMore)
                                  return Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      item,
                                      // Center(
                                      //   child: CircularProgressIndicator(),
                                      // ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 10,
                                        ),
                                        child: Column(
                                          children: <Widget>[
                                            RaisedButton(
                                              color: Colors.white,
                                              onPressed: _loadingMore
                                                  ? null
                                                  : () {
                                                      setState(() {
                                                        _loadingMore = true;
                                                      });
                                                      _fetchPois();
                                                    },
                                              child: Text("Cargar más"),
                                            ),
                                            if (_loadingMore)
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 15),
                                                child: Center(
                                                  child: SizedBox(
                                                    width: 25,
                                                    height: 25,
                                                    child:
                                                        CircularProgressIndicator(
                                                      strokeWidth: 2,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        height: 200,
                                        color: Color(0x05000000),
                                      ),
                                    ],
                                  );
                                else
                                  return Column(
                                    children: <Widget>[
                                      item,
                                      Container(
                                        height: 200,
                                        color: Color(0x05000000),
                                      ),
                                    ],
                                  );
                              } else
                                return item;
                            },
                          )
                        : Text(
                            "No hay puntos para mostrar",
                            textAlign: TextAlign.center,
                          )
                    : Text(
                        "Ocurrió un error",
                        textAlign: TextAlign.center,
                      ),
          ),
        ],
      ),
    );
  }
}
