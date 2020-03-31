import 'dart:convert';
import 'dart:io';

import 'package:arrancando/config/globals/enums.dart';
import 'package:arrancando/config/services/fetcher.dart';
import 'package:arrancando/views/content_wrapper/new/v2/_crear_boton.dart';
import 'package:arrancando/views/content_wrapper/new/v2/_error_message.dart';
import 'package:arrancando/views/content_wrapper/new/v2/_multimedia_thumbs.dart';
import 'package:arrancando/views/content_wrapper/new/v2/_new_content_input.dart';
import 'package:arrancando/views/content_wrapper/new/v2/_new_content_multimedia.dart';
import 'package:arrancando/views/content_wrapper/new/v2/_scaffold.dart';
import 'package:arrancando/views/content_wrapper/show/index.dart';
import 'package:flutter/material.dart';

class PublicacionNew extends StatefulWidget {
  @override
  _PublicacionNewState createState() => _PublicacionNewState();
}

class _PublicacionNewState extends State<PublicacionNew> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _tituloController = TextEditingController();
  final TextEditingController _cuerpoController = TextEditingController();
  List<File> _images = [];
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

  _crearPublicacion() async {
    _errorMsg = null;
    if (_formKey.currentState.validate() &&
        _images != null &&
        _images.isNotEmpty) {
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
          // TODO: Remove next line
          "ciudad_id": 1,
        };

        ResponseObject res = await Fetcher.post(
          url: "/publicaciones.json",
          throwError: true,
          body: {
            ...body,
          },
        );

        if (res != null && res.status == 201) {
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

  @override
  Widget build(BuildContext context) {
    return NewContentScaffold(
      scaffoldKey: _scaffoldKey,
      formKey: _formKey,
      title: "NUEVA PUBLICACIÓN",
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
          removeImage: _removeImage,
        ),
        NewContentErrorMessage(
          message: _errorMsg,
        ),
        if (!_hideButtonVeryBadError)
          NewContentCrearBoton(
            onPressed: _crearPublicacion,
            sent: _sent,
          ),
      ],
    );
  }
}
