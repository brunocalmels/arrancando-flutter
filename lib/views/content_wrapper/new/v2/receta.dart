import 'dart:convert';
import 'dart:io';

import 'package:arrancando/config/globals/enums.dart';
import 'package:arrancando/config/globals/index.dart';
import 'package:arrancando/config/models/content_wrapper.dart';
import 'package:arrancando/config/services/fetcher.dart';
import 'package:arrancando/views/content_wrapper/new/v2/_dropdrown_select.dart';
import 'package:arrancando/views/content_wrapper/new/v2/_error_message.dart';
import 'package:arrancando/views/content_wrapper/new/v2/_ingredientes_type_ahead.dart';
import 'package:arrancando/views/content_wrapper/new/v2/_mucho_peso_archivos.dart';
import 'package:arrancando/views/content_wrapper/new/v2/_multimedia_thumbs.dart';
import 'package:arrancando/views/content_wrapper/new/v2/_new_content_input.dart';
import 'package:arrancando/views/content_wrapper/new/v2/_new_content_multimedia.dart';
import 'package:arrancando/views/content_wrapper/new/v2/_scaffold.dart';
import 'package:arrancando/views/content_wrapper/new/v2/_selector_categoria.dart';
import 'package:arrancando/views/content_wrapper/new/v2/_selector_subcategoria.dart';
import 'package:arrancando/views/content_wrapper/new/v2/_send_boton.dart';
import 'package:arrancando/views/content_wrapper/show/index.dart';
import 'package:flutter/material.dart';

class RecetaForm extends StatefulWidget {
  final ContentWrapper content;

  RecetaForm({
    this.content,
  });

  @override
  RecetaFormState createState() => RecetaFormState();
}

class RecetaFormState extends State<RecetaForm> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _tituloController = TextEditingController();
  final TextEditingController _introduccionController = TextEditingController();
  // final TextEditingController _ingredientesController = TextEditingController();
  List<String> _ingredientes = [];
  final TextEditingController _instruccionesController =
      TextEditingController();
  final TextEditingController _duracionController = TextEditingController();
  String _complejidad;
  dynamic _categoria;
  List<dynamic> _subcategorias;
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

  _setCategoria(dynamic categoria) {
    _categoria = categoria;
    if (mounted) setState(() {});
  }

  _setSubCategorias(List<dynamic> subcategorias) {
    _subcategorias = subcategorias;
    if (mounted) setState(() {});
  }

  _setIngredientes(List<String> ingredientes) {
    _ingredientes = ingredientes;
    if (mounted) setState(() {});
  }

  _setComplejidad(dynamic val) {
    _complejidad = val;
    if (mounted) setState(() {});
  }

  _crearReceta() async {
    _errorMsg = null;
    if (_formKey.currentState.validate() &&
        ((_images != null && _images.isNotEmpty) ||
            (_currentImages != null && _currentImages.isNotEmpty))) {
      _sent = true;
      if (mounted) setState(() {});

      try {
        Map<String, dynamic> body = {
          "categoria_receta_id": _categoria['id'],
          "titulo": _tituloController.text,
          "introduccion": _introduccionController.text,
          "ingredientes": _ingredientes,
          "instrucciones": _instruccionesController.text,
          "duracion": int.tryParse(_duracionController.text.split('.')[0]),
          "complejidad": _complejidad,
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
        };

        ResponseObject res;

        if (_isEdit && _id != null)
          res = await Fetcher.put(
            url: "/recetas/$_id.json",
            throwError: true,
            body: {
              ...body,
            },
          );
        else
          res = await Fetcher.post(
            url: "/recetas.json",
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
                type: SectionType.recetas,
              ),
              settings: RouteSettings(
                name: 'Recetas#${json.decode(res.body)['id']}',
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
      _introduccionController.text = widget.content.introduccion;
      _ingredientes = []; //widget.content.ingredientes;
      _instruccionesController.text = widget.content.instrucciones;
      _currentImages = widget.content.imagenes;
      _currentVideoThumbs = widget.content.videoThumbs;
      _categoria = MyGlobals.CATEGORIAS_RECETA.firstWhere(
          (c) => c['id'] == widget.content.categoriaRecetaId,
          orElse: () => null);
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
      title: _isEdit ? "EDITAR RECETA" : "NUEVA RECETA",
      children: [
        SelectorCategoria(
          label: "Categoría",
          setCategoria: _setCategoria,
          categoria: _categoria,
        ),
        SelectorSubCategoria(
          label: "Subcategorías",
          setSubCategorias: _setSubCategorias,
          subcategorias: _subcategorias,
        ),
        NewContentInput(
          label: "Título",
          controller: _tituloController,
          hint: "Merengue italiano",
          validator: (val) => val != null && val.isNotEmpty
              ? null
              : "Este campo no puede estar vacío",
        ),
        NewContentInput(
          label: "Duración",
          controller: _duracionController,
          hint: "45 minutos",
          keyboardType: TextInputType.number,
        ),
        DropdownSelect(
          label: "Complejidad",
          hint: "Definir",
          onChanged: _setComplejidad,
          value: _complejidad,
          items: [
            {
              "label": "Simple",
              "value": "Simple",
            },
            {
              "label": "Media",
              "value": "Media",
            },
            {
              "label": "Compleja",
              "value": "Compleja",
            },
          ],
        ),
        NewContentInput(
          label: "Introducción",
          controller: _introduccionController,
          hint: "Para hacer merengue...",
          multiline: true,
          addLinkButton: true,
          validator: (val) => val != null && val.isNotEmpty
              ? null
              : "Este campo no puede estar vacío",
        ),
        IngredientesTypeAhead(
          ingredientes: _ingredientes,
          setIngredientes: _setIngredientes,
        ),
        NewContentInput(
          label: "Instrucciones",
          controller: _instruccionesController,
          hint: "- Se baten las claras a punto de nieve...",
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
            onPressed: _crearReceta,
            sent: _sent,
            isEdit: _isEdit,
          ),
      ],
    );
  }
}
