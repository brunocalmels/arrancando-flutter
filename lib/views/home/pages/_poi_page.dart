import 'package:arrancando/config/globals/enums.dart';
import 'package:arrancando/config/globals/index.dart';
import 'package:arrancando/config/models/content_wrapper.dart';
import 'package:arrancando/config/state/content_page.dart';
import 'package:arrancando/views/cards/tile_poi.dart';
import 'package:arrancando/views/home/filter_bottom_sheet/index.dart';
import 'package:arrancando/views/home/pages/_pois_map.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:latlong/latlong.dart';
import 'package:provider/provider.dart';

class PoiPage extends StatefulWidget {
  final bool fetching;
  final bool noMore;
  final bool loadingMore;
  final bool locationDenied;
  final Function resetLimit;
  final Function(SectionType) fetchContent;
  final Function increasePage;
  final Function(bool) setLoadingMore;
  final Function setLocationDenied;
  final List<ContentWrapper> items;
  final bool hideFilter;

  PoiPage({
    @required this.fetching,
    @required this.noMore,
    @required this.loadingMore,
    @required this.locationDenied,
    @required this.resetLimit,
    @required this.fetchContent,
    @required this.increasePage,
    @required this.setLocationDenied,
    @required this.setLoadingMore,
    @required this.items,
    this.hideFilter = false,
  });

  @override
  _PoiPageState createState() => _PoiPageState();
}

class _PoiPageState extends State<PoiPage> {
  double _latitud = -38.950249;
  double _longitud = -68.059095;
  final double _zoom = 15;
  MapController _mapController;
  bool _showMap = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      Provider.of<ContentPageState>(context)
          .setContentSortType(ContentSortType.puntuacion);
      widget.setLocationDenied();
      widget.resetLimit();
      widget.fetchContent(SectionType.pois);
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () {
        widget.resetLimit();
        return widget.fetchContent(SectionType.pois);
      },
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            if (!widget.hideFilter)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                        context: MyGlobals.mainScaffoldKey.currentContext,
                        builder: (_) => FilterBottomSheet(
                          fetchContent: () {
                            widget.resetLimit();
                            widget.fetchContent(
                              SectionType.pois,
                            );
                          },
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(15),
                            topRight: Radius.circular(15),
                          ),
                        ),
                        backgroundColor: Colors.white,
                      );
                    },
                    child: Image.asset(
                      'assets/images/content/index/plato-filtrar.png',
                      width: MediaQuery.of(context).size.width * 0.6,
                    ),
                  ),
                ],
              ),
            SizedBox(
              height: 15,
            ),
            AnimatedContainer(
              duration: Duration(milliseconds: 100),
              height:
                  MediaQuery.of(context).size.height * (_showMap ? 0.33 : 0),
              child: PoisMap(
                height: MediaQuery.of(context).size.height * 0.33,
                latitud: _latitud,
                longitud: _longitud,
                zoom: _zoom,
                buildCallback: (MapController controller) {
                  _mapController = controller;
                },
              ),
            ),
            widget.fetching
                ? Container(
                    height: MediaQuery.of(context).size.height * 0.66,
                    child: Center(
                      child: SizedBox(
                        width: 25,
                        height: 25,
                        child: CircularProgressIndicator(
                          strokeWidth: 1,
                        ),
                      ),
                    ),
                  )
                : Container(
                    height: MediaQuery.of(context).size.height *
                        (_showMap ? 0.66 : 1),
                    child: widget.items != null
                        ? widget.items.isNotEmpty
                            ? ListView.builder(
                                padding: const EdgeInsets.all(0),
                                itemCount: widget.items.length,
                                itemBuilder: (BuildContext context, int index) {
                                  final p = widget.items[index];
                                  Widget item = TilePoi(
                                    poi: p,
                                    locationDenied: widget.locationDenied,
                                    onTap: () async {
                                      if (_mapController != null) {
                                        _showMap = true;
                                        if (mounted) setState(() {});
                                        await Future.delayed(
                                            Duration(milliseconds: 500));
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
                                  if (index == widget.items.length - 1) {
                                    if (!widget.noMore) {
                                      return Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          item,
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 10,
                                            ),
                                            child: Column(
                                              children: <Widget>[
                                                if (!widget.noMore)
                                                  RaisedButton(
                                                    color: Colors.white,
                                                    onPressed: widget
                                                            .loadingMore
                                                        ? null
                                                        : () async {
                                                            widget
                                                                .setLoadingMore(
                                                              true,
                                                            );
                                                            widget
                                                                .increasePage();
                                                            await widget
                                                                .fetchContent(
                                                              SectionType.pois,
                                                            );
                                                            widget
                                                                .setLoadingMore(
                                                              false,
                                                            );
                                                          },
                                                    child: Text('Cargar más'),
                                                  ),
                                                if (widget.loadingMore)
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
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
                                    } else {
                                      return Column(
                                        children: <Widget>[
                                          item,
                                          Container(
                                            height: 200,
                                            color: Color(0x05000000),
                                          ),
                                        ],
                                      );
                                    }
                                  } else {
                                    return item;
                                  }
                                },
                              )
                            : Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 15),
                                child: Text(
                                  'No hay tiendas para mostrar',
                                  textAlign: TextAlign.center,
                                ),
                              )
                        : Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 15),
                                child: Text(
                                  'Ocurrió un error',
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Text(
                                '(Si el problema persiste, cerrá sesión y volvé a iniciar)',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                  ),
          ],
        ),
      ),
    );
  }
}
