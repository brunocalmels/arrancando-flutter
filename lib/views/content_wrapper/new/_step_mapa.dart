import 'dart:async';

import 'package:arrancando/views/home/pages/_pois_map.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong/latlong.dart';

class StepMapa extends StatefulWidget {
  final Function(String) setDireccion;
  final Function(double, double) setLatLng;
  final double latitud;
  final double longitud;
  final String direccion;

  StepMapa({
    @required this.setDireccion,
    @required this.setLatLng,
    this.latitud,
    this.longitud,
    this.direccion,
  });

  @override
  _StepMapaState createState() => _StepMapaState();
}

class _StepMapaState extends State<StepMapa> {
  final TextEditingController _direccionController = TextEditingController();
  MapController _mapController;
  double _latitud = -38.950249;
  double _longitud = -68.059095;
  bool _searching = false;
  Timer _debounce;

  _fetchPlaceByName() async {
    if (mounted) {
      try {
        List<Placemark> placemarks =
            await Geolocator().placemarkFromAddress(_direccionController.text);

        _latitud = placemarks.first.position.latitude;
        _longitud = placemarks.first.position.longitude;
        _mapController.move(
          LatLng(
            placemarks.first.position.latitude,
            placemarks.first.position.longitude,
          ),
          15,
        );

        widget.setDireccion(_direccionController.text);
        widget.setLatLng(
          placemarks.first.position.latitude,
          placemarks.first.position.longitude,
        );
      } catch (e) {
        print(e);
      }
      setState(() {
        _searching = false;
      });
    }
  }

  _searchLocation(String text) {
    if (text != null && text.isNotEmpty) {
      setState(() {
        _searching = true;
      });
      if (_debounce?.isActive ?? false) _debounce.cancel();
      _debounce = Timer(const Duration(milliseconds: 1500), _fetchPlaceByName);
    }
  }

  @override
  void initState() {
    super.initState();
    _latitud = widget.latitud != null ? widget.latitud : _latitud;
    _longitud = widget.longitud != null ? widget.longitud : _longitud;
    if (widget.direccion != null) _direccionController.text = widget.direccion;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        PoisMap(
          height: 200,
          latitud: _latitud,
          longitud: _longitud,
          zoom: 15,
          buildCallback: (MapController controller) {
            if (mounted)
              setState(() {
                _mapController = controller;
              });
          },
          onPositionChanged: (MapPosition position, bool changed) {
            if (changed && _mapController != null) {
              _latitud = position.center.latitude;
              _longitud = position.center.longitude;
              widget.setDireccion(_direccionController.text);
              widget.setLatLng(
                position.center.latitude,
                position.center.longitude,
              );
              setState(() {});
            }
          },
        ),
        SizedBox(
          height: 15,
        ),
        Stack(
          fit: StackFit.passthrough,
          children: <Widget>[
            TextField(
              decoration: InputDecoration(
                labelText: "Dirección, Ciudad, Provincia",
              ),
              controller: _direccionController,
              onChanged: _searchLocation,
            ),
            if (_searching)
              Positioned(
                right: 0,
                top: 30,
                child: SizedBox(
                  height: 10,
                  width: 10,
                  child: CircularProgressIndicator(
                    strokeWidth: 1,
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}
