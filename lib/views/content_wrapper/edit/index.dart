import 'dart:convert';

import 'package:arrancando/config/globals/enums.dart';
import 'package:arrancando/config/globals/global_singleton.dart';
import 'package:arrancando/config/models/category_wrapper.dart';
import 'package:arrancando/config/models/content_wrapper.dart';
import 'package:arrancando/config/services/fetcher.dart';
import 'package:arrancando/views/content_wrapper/new/_step_categoria.dart';
import 'package:arrancando/views/content_wrapper/new/_step_general.dart';
import 'package:arrancando/views/content_wrapper/new/_step_imagenes.dart';
import 'package:arrancando/views/content_wrapper/new/_step_mapa.dart';
import 'package:arrancando/views/home/pages/_loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

class EditPage extends StatefulWidget {
  final int contentId;
  final SectionType type;

  EditPage({
    @required this.contentId,
    @required this.type,
  });

  @override
  _EditPageState createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  final GlobalSingleton gs = GlobalSingleton();
  ContentWrapper _content;
  bool _fetching = true;
  String _url;
  final TextEditingController _tituloController = TextEditingController();
  final TextEditingController _cuerpoController = TextEditingController();
  final GlobalKey<FormState> _form1Key = GlobalKey<FormState>();
  CategoryWrapper _selectedCategory;
  List<Asset> _images = List<Asset>();
  String _selectedDireccion;
  double _selectedLatitud;
  double _selectedLongitud;
  bool _sent = false;
  bool _enableImagenes = false;

  _fetchContent() async {
    switch (widget.type) {
      case SectionType.publicaciones:
        _url = "/publicaciones";
        break;
      case SectionType.recetas:
        _url = "/recetas";
        break;
      case SectionType.pois:
        _url = "/pois";
        break;
      default:
        _url = "/publicaciones";
    }

    ResponseObject resp = await Fetcher.get(
      url: "$_url/${widget.contentId}.json",
    );

    if (resp != null) {
      _content = ContentWrapper.fromJson(json.decode(resp.body));
      _content.type = widget.type;
      _tituloController.text = _content.titulo;
      _cuerpoController.text = _content.cuerpo;
      _selectedCategory = CategoryWrapper.fromJson({
        "id": _content.categID,
        "nombre": gs.categories[_content.type]
            .firstWhere((c) => c.id == _content.categID)
            .nombre,
        "type": _content.type.toString().split(".")[1],
      });
    }

    _fetching = false;
    if (mounted) setState(() {});
  }

  _setCategory(CategoryWrapper val) {
    setState(() {
      _selectedCategory = val;
    });
  }

  _setImages(List<Asset> val) {
    setState(() {
      _images = val;
    });
  }

  _setDireccion(String val) {
    setState(() {
      _selectedDireccion = val;
    });
  }

  _setLatLng(double l1, double l2) {
    setState(() {
      _selectedLatitud = l1;
      _selectedLongitud = l2;
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchContent();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
      ),
      body: SingleChildScrollView(
        child: _fetching
            ? LoadingWidget(height: 200)
            : _content == null
                ? Padding(
                    padding: const EdgeInsets.all(20),
                    child: Container(
                      child: Text("Ocurrió un error"),
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        StepGeneral(
                          cuerpoController: _cuerpoController,
                          formKey: _form1Key,
                          tituloController: _tituloController,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(_content.type == SectionType.publicaciones
                            ? "Ciudad"
                            : "Categoría"),
                        StepCategoria(
                          selectedCategory: _selectedCategory,
                          setCategory: _setCategory,
                          type: _content.type,
                        ),
                        if (_enableImagenes)
                          StepImagenes(
                            images: _images,
                            setImages: _setImages,
                          ),
                        if (!_enableImagenes)
                          Container(
                            height: 200,
                            child: Center(
                              child: FlatButton(
                                onPressed: () {
                                  setState(() {
                                    _enableImagenes = true;
                                  });
                                },
                                child: Text("MODIFICAR IMÁGENES"),
                              ),
                            ),
                          ),
                        if (_content.type == SectionType.pois)
                          StepMapa(
                            setDireccion: _setDireccion,
                            setLatLng: _setLatLng,
                            latitud: _content.latitud,
                            longitud: _content.longitud,
                            direccion: _content.direccion,
                          )
                      ],
                    ),
                  ),
      ),
    );
  }
}
