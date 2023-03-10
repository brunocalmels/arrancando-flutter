import 'dart:convert';
import 'dart:io';

import 'package:arrancando/config/globals/enums.dart';
import 'package:arrancando/config/models/content_wrapper.dart';
import 'package:arrancando/config/services/deferred_executor.dart';
import 'package:arrancando/config/services/fetcher.dart';
import 'package:arrancando/views/content_wrapper/new/v2/_error_message.dart';
import 'package:arrancando/views/content_wrapper/new/v2/_mucho_peso_archivos.dart';
import 'package:arrancando/views/content_wrapper/new/v2/_multimedia_thumbs.dart';
import 'package:arrancando/views/content_wrapper/new/v2/_new_content_input.dart';
import 'package:arrancando/views/content_wrapper/new/v2/_new_content_multimedia.dart';
import 'package:arrancando/views/content_wrapper/new/v2/_scaffold.dart';
import 'package:arrancando/views/content_wrapper/new/v2/_send_boton.dart';
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
  final _imagesToRemove = <String>[];
  int _id;
  bool _isEdit = false;
  bool _sent = false;
  final _hideButtonVeryBadError = false;
  String _errorMsg;

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
        ((_images != null && _images.isNotEmpty) ||
            (_currentImages != null && _currentImages.isNotEmpty)) &&
        [...(_images ?? []), ...(_currentImages ?? [])].length <= 6) {
      _sent = true;
      if (mounted) setState(() {});

      try {
        final body = <String, dynamic>{
          'titulo': _tituloController.text,
          'cuerpo': _cuerpoController.text,
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
          // TODO: Remove next line
          'ciudad_id': 1,
        };

        Navigator.of(context).popUntil((route) => route.isFirst);

        if (_isEdit && _id != null) {
          DeferredExecutor.execute(
            SectionType.publicaciones,
            LastFuture(
              function: Fetcher.put,
              url: '/publicaciones/$_id.json',
              body: {
                ...body,
              },
            ),
          );
        } else {
          DeferredExecutor.execute(
            SectionType.publicaciones,
            LastFuture(
              function: Fetcher.post,
              url: '/publicaciones.json',
              body: {
                ...body,
              },
            ),
          );
        }
      } catch (e) {
        print(e);
        _errorMsg =
            'Ocurri?? un error, por favor intentalo nuevamente m??s tarde.';
      }
      _sent = false;
    } else if (!_formKey.currentState.validate()) {
      if (_tituloController.text == null || _tituloController.text.isEmpty) {
        _errorMsg = 'El t??tulo no puede estar vacio';
      } else if (_cuerpoController.text == null ||
          _cuerpoController.text.isEmpty) {
        _errorMsg = 'El cuerpo no puede estar vacio';
      }
    } else if (!((_images != null && _images.isNotEmpty) ||
        (_currentImages != null && _currentImages.isNotEmpty))) {
      _errorMsg = 'Debes a??adir al menos 1 imagen/video';
    } else if (!([...(_images ?? []), ...(_currentImages ?? [])].length <= 6)) {
      _errorMsg = 'Pod??s subir como m??ximo 6 im??genes y/o videos';
    }

    if (mounted) setState(() {});
  }

  void _loadForEdit() {
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
      title: _isEdit ? 'EDITAR PUBLICACI??N' : 'NUEVA PUBLICACI??N',
      children: [
        NewContentInput(
          label: 'T??tulo',
          controller: _tituloController,
          hint: 'Vac??o con papas',
          validator: (val) => val != null && val.isNotEmpty
              ? null
              : 'Este campo no puede estar vac??o',
        ),
        NewContentInput(
          label: 'Cuerpo',
          controller: _cuerpoController,
          hint: 'Pasamos un domingo espectacular. No nos quer??amos ir...',
          multiline: true,
          addLinkButton: true,
          validator: (val) => val != null && val.isNotEmpty
              ? null
              : 'Este campo no puede estar vac??o',
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
