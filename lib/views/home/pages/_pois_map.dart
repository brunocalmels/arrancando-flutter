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

  PoisMap({
    @required this.height,
    @required this.latitud,
    @required this.longitud,
    @required this.zoom,
    this.buildCallback,
    this.onPositionChanged,
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
    return Container(
      height: widget.height,
      child: FlutterMap(
        mapController: _controller,
        options: MapOptions(
          onPositionChanged: widget.onPositionChanged == null
              ? null
              : widget.onPositionChanged,
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
            urlTemplate: "https://api.mapbox.com/v4/"
                "{id}/{z}/{x}/{y}@2x.png?access_token={accessToken}",
            additionalOptions: {
              'accessToken':
                  'pk.eyJ1IjoiaXZhbmVpZGVsIiwiYSI6ImNqdGxxaTJoZzBnZjQzeXBobG84Mms5OTAifQ.HCfGRyJQCTuIW_vFr1eqiQ',
              'id': 'mapbox.streets',
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
    );
  }
}
