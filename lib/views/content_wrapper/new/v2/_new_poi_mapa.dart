import 'dart:async';

import 'package:arrancando/config/models/active_user.dart';
import 'package:arrancando/views/content_wrapper/new/v2/_new_content_input.dart';
import 'package:arrancando/views/home/pages/_pois_map.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong/latlong.dart';

class NewPoiMapa extends StatefulWidget {
  final Function(String) setDireccion;
  final Function(double, double) setLatLng;
  final double latitud;
  final double longitud;
  final String direccion;

  NewPoiMapa({
    @required this.setDireccion,
    @required this.setLatLng,
    this.latitud,
    this.longitud,
    this.direccion,
  });

  @override
  _NewPoiMapaState createState() => _NewPoiMapaState();
}

class _NewPoiMapaState extends State<NewPoiMapa> {
  final TextEditingController _direccionController = TextEditingController();
  MapController _mapController;
  double _latitud = -38.950249;
  double _longitud = -68.059095;
  bool _searching = false;
  bool _locating = false;
  Timer _debounce;

  _fetchPlaceByName() async {
    if (mounted) {
      setState(() {
        _locating = true;
      });
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
        _locating = false;
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

  _setMyLocation() async {
    if (mounted)
      setState(() {
        _locating = true;
      });
    bool locationDenied = await ActiveUser.locationPermissionDenied();
    if (!locationDenied) {
      Position currentPosition = await Geolocator().getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      _latitud = currentPosition.latitude;
      _longitud = currentPosition.longitude;
      _mapController.move(LatLng(_latitud, _longitud), 15);
      widget.setLatLng(_latitud, _longitud);
      _locating = false;
      if (mounted) setState(() {});
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
        SizedBox(
          height: 15,
        ),
        Container(
          height: 200,
          child: Stack(
            fit: StackFit.passthrough,
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
                  if (widget.latitud == null || widget.longitud == null)
                    _setMyLocation();
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
              if (_locating)
                Container(
                  color: Colors.white54,
                  child: Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                    ),
                  ),
                ),
            ],
          ),
        ),
        SizedBox(
          height: 5,
        ),
        Text(
          "Arrastrá con 2 dedos el mapa para ajustar el marcador.",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 11,
          ),
        ),
        Stack(
          fit: StackFit.passthrough,
          children: <Widget>[
            NewContentInput(
              controller: _direccionController,
              onChanged: _searchLocation,
              hint: "Dirección, Ciudad, Provincia",
              label: "",
            ),
            if (_searching)
              Positioned(
                right: 10,
                top: 42.5,
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
        SizedBox(
          height: 15,
        ),
      ],
    );
  }
}
