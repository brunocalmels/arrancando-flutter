import 'dart:async';

import 'package:arrancando/config/models/category_wrapper.dart';
import 'package:arrancando/config/services/permissions.dart';
import 'package:arrancando/views/home/pages/_pois_map.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong/latlong.dart';

class StepMapa extends StatefulWidget {
  final Function(CategoryWrapper) setCiudadPoi;
  final Function(String) setDireccion;
  final Function(double, double) setLatLng;
  final double latitud;
  final double longitud;
  final String direccion;

  StepMapa({
    @required this.setCiudadPoi,
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
  bool _locating = false;
  Timer _debounce;

  Future<void> _fetchPlaceByName() async {
    if (mounted) {
      setState(() {
        _locating = true;
      });
      try {
        final placemarks = await locationFromAddress(_direccionController.text);

        _latitud = placemarks.first.latitude;
        _longitud = placemarks.first.longitude;
        _mapController.move(
          LatLng(
            placemarks.first.latitude,
            placemarks.first.longitude,
          ),
          15,
        );

        widget.setDireccion(_direccionController.text);
        widget.setLatLng(
          placemarks.first.latitude,
          placemarks.first.longitude,
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

  void _searchLocation(String text) {
    if (text != null && text.isNotEmpty) {
      setState(() {
        _searching = true;
      });
      if (_debounce?.isActive ?? false) _debounce.cancel();
      _debounce = Timer(const Duration(milliseconds: 1500), _fetchPlaceByName);
    }
  }

  Future<void> _setMyLocation() async {
    _locating = true;
    if (mounted) setState(() {});

    final locationDenied = !(await PermissionUtils.requestLocationPermission());
    if (!locationDenied) {
      final currentPosition = await Geolocator.getCurrentPosition(
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
    _latitud = widget.latitud ?? _latitud;
    _longitud = widget.longitud ?? _longitud;
    if (widget.direccion != null) _direccionController.text = widget.direccion;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        // Text('Ciudad'),
        // Container(
        //   height: 150,
        //   child: SingleChildScrollView(
        //     child: TypeAheadCiudad(
        //       insideEdit: true,
        //       onItemTap: (CategoryWrapper ciudad) {
        //          = ciudad;
        //         widget.setCiudadPoi(ciudad);
        //         if (mounted) setState(() {});
        //       },
        //     ),
        //   ),
        // ),
        // if ( != null)
        //   Padding(
        //     padding: const EdgeInsets.all(15),
        //     child: Text('Ciudad: ${.nombre}'),
        //   ),
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
                  _mapController = controller;
                  if (mounted) setState(() {});
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
          'Arrastrá con 2 dedos el mapa para ajustar el marcador.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 11,
          ),
        ),
        SizedBox(
          height: 15,
        ),
        Stack(
          fit: StackFit.passthrough,
          children: <Widget>[
            TextField(
              decoration: InputDecoration(
                labelText: 'Dirección, Ciudad, Provincia',
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
