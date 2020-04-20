import 'dart:convert';
import 'dart:io';

import 'package:arrancando/config/globals/enums.dart';
import 'package:arrancando/config/models/content_wrapper.dart';
import 'package:arrancando/config/services/fetcher.dart';
import 'package:arrancando/views/content_wrapper/new/v2/_error_message.dart';
import 'package:arrancando/views/content_wrapper/new/v2/_mucho_peso_archivos.dart';
import 'package:arrancando/views/content_wrapper/new/v2/_multimedia_thumbs.dart';
import 'package:arrancando/views/content_wrapper/new/v2/_new_content_input.dart';
import 'package:arrancando/views/content_wrapper/new/v2/_new_content_multimedia.dart';
import 'package:arrancando/views/content_wrapper/new/v2/_scaffold.dart';
import 'package:arrancando/views/content_wrapper/new/v2/_send_boton.dart';
import 'package:arrancando/views/content_wrapper/show/index.dart';
import 'package:flutter/material.dart';

class PublicacionForm extends StatefulWidget {
  final ContentWrapper content;

  PublicacionForm({
    this.content,
  });

  @override
  _PublicacionFormState createState() => _PublicacionFormState();
}

class _PublicacionFormState extends State<PublicacionForm> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _tituloController = TextEditingController();
  final TextEditingController _cuerpoController = TextEditingController();
  List<File> _images = [];
  List<String> _currentImages = [];
  Map<String, String> _currentVideoThumbs = {};
  List<String> _imagesToRemove = [];
  int _id;
  bool _isEdit = false;
  bool _sent = false;
  bool _hideButtonVeryBadError = false;
  String _errorMsg;

  _setImages(List<File> images) {
    _images = images;
    if (mounted) setState(() {});
  }

  _removeImage(File asset) {
    _images.remove(asset);
    if (mounted) setState(() {});
  }

  _removeCurrentImage(String asset) {
    if (_imagesToRemove.contains(asset))
      _imagesToRemove.remove(asset);
    else
      _imagesToRemove.add(asset);
    if (mounted) setState(() {});
  }

  _crearPublicacion() async {
    _errorMsg = null;
    if (_formKey.currentState.validate() &&
        ((_images != null && _images.isNotEmpty) ||
            (_currentImages != null && _currentImages.isNotEmpty))) {
      _sent = true;
      if (mounted) setState(() {});

      try {
        Map<String, dynamic> body = {
          "titulo": _tituloController.text,
          "cuerpo": _cuerpoController.text,
          "imagenes": await Future.wait(
            _images.map(
              (i) async => {
                "file": i != null ? i.path.split('/').last : 'file',
                "data": base64Encode(
                  (await i.readAsBytes()).buffer.asUint8List(),
                )
              },
            ),
          ),
          "remove_imagenes": _imagesToRemove,
          // TODO: Remove next line
          "ciudad_id": 1,
        };

        ResponseObject res;

        if (_isEdit && _id != null)
          res = await Fetcher.put(
            url: "/publicaciones/$_id.json",
            throwError: true,
            body: {
              ...body,
            },
          );
        else
          res = await Fetcher.post(
            url: "/publicaciones.json",
            throwError: true,
            body: {
              ...body,
            },
          );

        if (res != null && (res.status == 201 || res.status == 200)) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (_) => ShowPage(
                contentId: json.decode(res.body)['id'],
                type: SectionType.publicaciones,
              ),
              settings: RouteSettings(
                name: 'Publicaciones#${json.decode(res.body)['id']}',
              ),
            ),
          );
        } else {
          if (res != null && res.body != null) {
            _errorMsg = (json.decode(res.body) as Map)
                .values
                .expand((i) => i)
                .join(',');
          } else {
            _errorMsg =
                "Ocurrió un error, por favor intentalo nuevamente más tarde.";
            _hideButtonVeryBadError = true;
          }
          if (mounted) setState(() {});
        }
      } catch (e) {
        print(e);
      }
      _sent = false;
    } else if (_images == null || _images.isEmpty) {
      _errorMsg = "Debes añadir al menos 1 imagen/video";
    }

    if (mounted) setState(() {});
  }

  _loadForEdit() {
    if (widget.content != null && widget.content.id != null) {
      _isEdit = true;
      _id = widget.content.id;
      _tituloController.text = widget.content.titulo;
      _cuerpoController.text = widget.content.cuerpo;
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
      title: _isEdit ? "EDITAR PUBLICACIÓN" : "NUEVA PUBLICACIÓN",
      children: [
        NewContentInput(
          label: "Título",
          controller: _tituloController,
          hint: "Vacío con papas",
          validator: (val) => val != null && val.isNotEmpty
              ? null
              : "Este campo no puede estar vacío",
        ),
        NewContentInput(
          label: "Cuerpo",
          controller: _cuerpoController,
          hint: "Pasamos un domingo espectacular. No nos queríamos ir...",
          multiline: true,
          addLinkButton: true,
          validator: (val) => val != null && val.isNotEmpty
              ? null
              : "Este campo no puede estar vacío",
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
