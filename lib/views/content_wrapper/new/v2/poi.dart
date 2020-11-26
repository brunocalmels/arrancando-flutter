import 'dart:convert';
import 'dart:io';

import 'package:arrancando/config/globals/enums.dart';
import 'package:arrancando/config/globals/global_singleton.dart';
import 'package:arrancando/config/models/category_wrapper.dart';
import 'package:arrancando/config/models/content_wrapper.dart';
import 'package:arrancando/config/services/deferred_executor.dart';
import 'package:arrancando/config/services/fetcher.dart';
import 'package:arrancando/views/content_wrapper/new/v2/_error_message.dart';
import 'package:arrancando/views/content_wrapper/new/v2/_mucho_peso_archivos.dart';
import 'package:arrancando/views/content_wrapper/new/v2/_multimedia_thumbs.dart';
import 'package:arrancando/views/content_wrapper/new/v2/_new_content_input.dart';
import 'package:arrancando/views/content_wrapper/new/v2/_new_content_multimedia.dart';
import 'package:arrancando/views/content_wrapper/new/v2/_new_poi_mapa.dart';
import 'package:arrancando/views/content_wrapper/new/v2/_scaffold.dart';
import 'package:arrancando/views/content_wrapper/new/v2/_selector_categoria_poi.dart';
import 'package:arrancando/views/content_wrapper/new/v2/_send_boton.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';

class PoiForm extends StatefulWidget {
  final ContentWrapper content;

  PoiForm({
    this.content,
  });

  @override
  _PoiFormState createState() => _PoiFormState();
}

class _PoiFormState extends State<PoiForm> {
  final GlobalSingleton gs = GlobalSingleton();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _tituloController = TextEditingController();
  final TextEditingController _cuerpoController = TextEditingController();
  final TextEditingController _rubroController = TextEditingController();
  final TextEditingController _whatsappController = TextEditingController();
  CategoryWrapper _categoria;
  List<File> _images = [];
  List<String> _currentImages = [];
  Map<String, String> _currentVideoThumbs = {};
  final _imagesToRemove = <String>[];
  int _id;
  bool _isEdit = false;
  bool _sent = false;
  bool _hideButtonVeryBadError = false;
  String _errorMsg;
  double _latitud;
  double _longitud;
  String _direccion;

  void _setDireccion(String direccion) {
    _direccion = direccion;
    if (mounted) setState(() {});
  }

  void _setLatLng(double latitud, double longitud) {
    _latitud = latitud;
    _longitud = longitud;
    if (mounted) setState(() {});
  }

  void _setCategoria(CategoryWrapper categoria) {
    _categoria = categoria;
    if (mounted) setState(() {});
  }

  void _setImages(List<File> images) {
    _images = images;
    if (mounted) setState(() {});
  }

  void _removeImage(File asset) {
    _images.remove(asset);
    if (mounted) setState(() {});
  }

  void _removeCurrentImage(String asset) {
    if (_imagesToRemove.contains(asset)) {
      _imagesToRemove.remove(asset);
    } else {
      _imagesToRemove.add(asset);
    }
    if (mounted) setState(() {});
  }

  Future<void> _crearPublicacion() async {
    _errorMsg = null;
    if (_formKey.currentState.validate() &&
        (_latitud != null && _longitud != null) &&
        ((_images != null && _images.isNotEmpty) ||
            (_currentImages != null && _currentImages.isNotEmpty)) &&
        [...(_images ?? []), ...(_currentImages ?? [])].length <= 6) {
      _sent = true;
      if (mounted) setState(() {});

      try {
        String nombreProvincia;
        String nombreCiudad;
        final places = await placemarkFromCoordinates(
          _latitud,
          _longitud,
        );
        if (places != null && places.isNotEmpty) {
          if (places.first.administrativeArea != null &&
              places.first.administrativeArea.isNotEmpty) {
            nombreProvincia = places.first.administrativeArea;
          }
          if (places.first.subLocality != null &&
              places.first.subLocality.isNotEmpty) {
            nombreCiudad = places.first.subLocality;
          } else if (places.first.locality != null &&
              places.first.locality.isNotEmpty) {
            nombreCiudad = places.first.locality;
          }
        }

        final body = <String, dynamic>{
          'titulo': _tituloController.text,
          'cuerpo': _cuerpoController.text,
          'categoria_poi_id': _categoria.id,
          'nombre_provincia': nombreProvincia,
          'nombre_ciudad': nombreCiudad,
          'lat': _latitud,
          'long': _longitud,
          'direccion': _direccion,
          // 'rubro': _rubroController.text,
          'whatsapp': _whatsappController.text,
          'imagenes': await Future.wait(
            _images.map(
              (i) async => {
                'file': i != null ? i.path.split('/').last : 'file',
                'data': base64Encode(
                  (await i.readAsBytes()).buffer.asUint8List(),
                )
              },
            ),
          ),
          'remove_imagenes': _imagesToRemove,
        };

        Navigator.of(context).popUntil((route) => route.isFirst);

        if (_isEdit && _id != null) {
          DeferredExecutor.execute(
            SectionType.pois,
            Fetcher.put(
              url: '/pois/$_id.json',
              throwError: true,
              body: {
                ...body,
              },
            ),
          );
        } else {
          DeferredExecutor.execute(
            SectionType.pois,
            Fetcher.post(
              url: '/pois.json',
              throwError: true,
              body: {
                ...body,
              },
            ),
          );
        }
      } catch (e) {
        print(e);
        _errorMsg =
            'Ocurrió un error, por favor intentalo nuevamente más tarde.';
        _hideButtonVeryBadError = true;
      }
      _sent = false;
    } else if (!_formKey.currentState.validate()) {
      if (_tituloController.text == null || _tituloController.text.isEmpty) {
        _errorMsg = 'El título no puede estar vacio';
      } else if (_cuerpoController.text == null ||
          _cuerpoController.text.isEmpty) {
        _errorMsg = 'La descripción no puede estar vacia';
      } else if (_rubroController.text == null ||
          _rubroController.text.isEmpty) {
        _errorMsg = 'El rubro no puede estar vacio';
      }
    } else if (!(_latitud != null && _longitud != null)) {
      _errorMsg = 'Debes seleccionar un punto en el mapa';
    } else if (!((_images != null && _images.isNotEmpty) ||
        (_currentImages != null && _currentImages.isNotEmpty))) {
      _errorMsg = 'Debes añadir al menos 1 imagen/video';
    } else if (!([...(_images ?? []), ...(_currentImages ?? [])].length <= 6)) {
      _errorMsg = 'Podés subir como máximo 6 imágenes y/o videos';
    }

    if (mounted) setState(() {});
  }

  void _loadForEdit() {
    if (widget.content != null && widget.content.id != null) {
      _isEdit = true;
      _id = widget.content.id;
      _tituloController.text = widget.content.titulo;
      _cuerpoController.text = widget.content.cuerpo;
      // _rubroController.text = widget.content.rubro;
      _categoria = gs?.categories[SectionType.pois]?.firstWhere(
          (c) => c.id == widget.content.categoriaPoiId,
          orElse: () => null);
      _latitud = widget.content.latitud;
      _longitud = widget.content.longitud;
      _direccion = widget.content.direccion;
      // _rubroController.text = widget.content.rubro;
      _whatsappController.text =
          widget.content.whatsapp != null ? '${widget.content.whatsapp}' : '';
      _currentImages = widget.content.imagenes;
      _currentVideoThumbs = widget.content.videoThumbs;
      if (mounted) setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    _loadForEdit();
  }

  @override
  Widget build(BuildContext context) {
    return NewContentScaffold(
      scaffoldKey: _scaffoldKey,
      formKey: _formKey,
      title: _isEdit ? 'EDITAR P. INTERÉS' : 'NUEVO P. INTERÉS',
      children: [
        SelectorCategoriaPoi(
          label: 'Categoría',
          setCategoria: _setCategoria,
          categoria: _categoria,
        ),
        NewContentInput(
          label: 'Título',
          controller: _tituloController,
          hint: 'Verdulería Palermo',
          validator: (val) => val != null && val.isNotEmpty
              ? null
              : 'Este campo no puede estar vacío',
        ),
        NewContentInput(
          label: 'Descripcion',
          controller: _cuerpoController,
          hint: 'La mejor verdulería de la zona...',
          multiline: true,
          addLinkButton: true,
          validator: (val) => val != null && val.isNotEmpty
              ? null
              : 'Este campo no puede estar vacío',
        ),
        // NewContentInput(
        //   label: 'Rubro',
        //   controller: _rubroController,
        //   hint: 'Verdulería',
        //   validator: (val) => val != null && val.isNotEmpty
        //       ? null
        //       : 'Este campo no puede estar vacío',
        // ),
        NewContentInput(
          label: 'Whatsapp',
          controller: _whatsappController,
          hint:
              'Comenzando por código de país (549 para Argentina), después código de área, sin símbolos ni espacios (por ej. 5492994589675).',
          keyboardType: TextInputType.number,
          multiline: true,
          // validator: (val) => val != null && val.isNotEmpty
          //     ? null
          //     : 'Este campo no puede estar vacío',
        ),
        NewPoiMapa(
          setDireccion: _setDireccion,
          setLatLng: _setLatLng,
          latitud: _latitud,
          longitud: _longitud,
          direccion: _direccion,
        ),
        NewContentMultimedia(
          images: _images,
          setImages: _setImages,
        ),
        MultimediaThumbs(
          images: _images,
          currentImages: _currentImages,
          currentVideoThumbs: _currentVideoThumbs,
          removeImage: _removeImage,
          removeCurrentImage: _removeCurrentImage,
          imagesToRemove: _imagesToRemove,
        ),
        MuchoPesoArchivos(
          images: _images,
        ),
        NewContentErrorMessage(
          message: _errorMsg,
        ),
        if (!_hideButtonVeryBadError)
          NewContentSendBoton(
            onPressed: _crearPublicacion,
            sent: _sent,
            isEdit: _isEdit,
          ),
      ],
    );
  }
}
