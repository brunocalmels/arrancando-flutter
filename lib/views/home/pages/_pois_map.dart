import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';

class PoisMap extends StatefulWidget {
  final double height;
  final double latitud;
  final double longitud;
  final double zoom;
  final Function(MapController) buildCallback;
  final Function(MapPosition, bool) onPositionChanged;
  final bool showCloseMap;
  final Function closeMap;

  PoisMap({
    @required this.height,
    @required this.latitud,
    @required this.longitud,
    @required this.zoom,
    this.buildCallback,
    this.onPositionChanged,
    this.showCloseMap = false,
    this.closeMap,
  });

  @override
  _PoisMapState createState() => _PoisMapState();
}

class _PoisMapState extends State<PoisMap> {
  final MapController _controller = MapController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.buildCallback != null) widget.buildCallback(_controller);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.passthrough,
      children: [
        Container(
          height: widget.height,
          child: FlutterMap(
            mapController: _controller,
            options: MapOptions(
              onPositionChanged: widget.onPositionChanged,
              center: LatLng(
                widget.latitud,
                widget.longitud,
              ),
              zoom: widget.zoom,
            ),
            layers: [
              // TileLayerOptions(
              //   urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
              // ),
              TileLayerOptions(
                urlTemplate:
                    'https://api.mapbox.com/styles/v1/ivaneidel/ckggw2wfg00ok19p8wgabmjlg/tiles/256/{z}/{x}/{y}@2x?access_token={accessToken}',
                additionalOptions: {
                  'accessToken':
                      'pk.eyJ1IjoiaXZhbmVpZGVsIiwiYSI6ImNqdGxxaTJoZzBnZjQzeXBobG84Mms5OTAifQ.HCfGRyJQCTuIW_vFr1eqiQ',
                  'id': 'mapbox.mapbox-streets-v8',
                },
              ),
              MarkerLayerOptions(
                markers: [
                  Marker(
                    height: 30,
                    width: 30,
                    point: LatLng(
                      widget.latitud,
                      widget.longitud,
                    ),
                    builder: (_) => Icon(
                      Icons.place,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        if (widget.showCloseMap)
          Positioned(
            right: 3,
            top: 3,
            child: Material(
              color: Colors.white,
              elevation: 2,
              child: InkWell(
                onTap: () {
                  if (widget.closeMap != null) {
                    widget.closeMap();
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.all(7),
                  child: Icon(
                    Icons.close,
                    color: Colors.black,
                    size: 17,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
