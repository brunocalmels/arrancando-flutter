import 'dart:convert';

import 'package:arrancando/config/globals/enums.dart';
import 'package:arrancando/config/globals/global_singleton.dart';
import 'package:arrancando/config/globals/index.dart';
import 'package:arrancando/config/models/category_wrapper.dart';
import 'package:arrancando/config/models/content_wrapper.dart';
import 'package:arrancando/config/services/fetcher.dart';
import 'package:arrancando/views/content_wrapper/new/_step_categoria.dart';
import 'package:arrancando/views/content_wrapper/new/_step_general.dart';
import 'package:arrancando/views/content_wrapper/new/_step_imagenes.dart';
import 'package:arrancando/views/content_wrapper/new/_step_mapa.dart';
import 'package:arrancando/views/home/pages/_loading_widget.dart';
import 'package:flutter/material.dart';
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
  List<String> _removeImagenes = [];
  Function _loadAssets;

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
      _selectedLatitud = _content.latitud;
      _selectedLongitud = _content.longitud;
      _selectedDireccion = _content.direccion;
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

  _actualizar() async {
    setState(() {
      _sent = true;
    });

    try {
      Map<String, dynamic> body = {
        "titulo": _tituloController.text,
        "cuerpo": _cuerpoController.text,
        "imagenes": await Future.wait<String>(
          _images.map(
            (i) async => base64Encode(
              (await i.getByteData(quality: 70)).buffer.asUint8List(),
            ),
          ),
        ),
        "remove_imagenes": _removeImagenes,
      };

      ResponseObject res;

      switch (widget.type) {
        case SectionType.publicaciones:
          res = await Fetcher.put(
            url: "/publicaciones/${_content.id}.json",
            body: {
              ...body,
              "ciudad_id": _selectedCategory.id,
            },
          );
          break;
        case SectionType.recetas:
          res = await Fetcher.put(
            url: "/recetas/${_content.id}.json",
            body: {
              ...body,
              "categoria_receta_id": _selectedCategory.id,
            },
          );
          break;
        case SectionType.pois:
          res = await Fetcher.put(
            url: "/pois/${_content.id}.json",
            body: {
              ...body,
              "categoria_poi_id": _selectedCategory.id,
              "lat": _selectedLatitud,
              "long": _selectedLongitud,
              "direccion": _selectedDireccion,
            },
          );
          break;
        default:
      }

      if (res != null && res.status == 200) {
        Navigator.of(context).pop();
      }
    } catch (e) {
      print(e);
    }

    if (mounted)
      setState(() {
        _sent = false;
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
                        Divider(),
                        Text("Imágenes"),
                        SizedBox(
                          height: 5,
                        ),
                        Wrap(
                          direction: Axis.horizontal,
                          children: _content.imagenes
                              .map(
                                (i) => Container(
                                  padding: const EdgeInsets.all(2),
                                  width:
                                      (MediaQuery.of(context).size.width - 32) /
                                          3.2,
                                  height:
                                      (MediaQuery.of(context).size.width - 32) /
                                          3.2,
                                  child: Stack(
                                    fit: StackFit.passthrough,
                                    children: <Widget>[
                                      FlatButton(
                                        color: Colors.black12,
                                        padding: const EdgeInsets.all(0),
                                        onPressed: () {
                                          _removeImagenes.add(i);
                                          setState(() {});
                                        },
                                        child: Image.network(
                                          "${MyGlobals.SERVER_URL}$i",
                                        ),
                                      ),
                                      if (!_removeImagenes.contains(i))
                                        Positioned(
                                          top: 5,
                                          right: 5,
                                          child: Icon(
                                            Icons.delete,
                                            color: Color(0x55ff0000),
                                            size: 15,
                                          ),
                                        ),
                                      if (_removeImagenes.contains(i))
                                        Positioned(
                                          left: 0,
                                          top: 0,
                                          right: 0,
                                          bottom: 0,
                                          child: FlatButton(
                                            color: Colors.black26,
                                            onPressed: () {
                                              _removeImagenes.remove(i);
                                              setState(() {});
                                            },
                                            child: Center(
                                              child: Icon(
                                                Icons.delete,
                                                color: Color(0x88ff0000),
                                                size: 50,
                                              ),
                                            ),
                                          ),
                                        )
                                    ],
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                        if (_enableImagenes)
                          StepImagenes(
                            images: _images,
                            setImages: _setImages,
                            createdCallback: (loadAssets) {
                              _loadAssets = loadAssets;
                              setState(() {});
                            },
                          ),
                        if (!_enableImagenes)
                          Padding(
                            padding: const EdgeInsets.only(top: 15),
                            child: Center(
                              child: FlatButton(
                                onPressed: () {
                                  setState(() {
                                    _enableImagenes = true;
                                  });
                                },
                                child: Text("AÑADIR IMÁGENES"),
                              ),
                            ),
                          ),
                        if (_enableImagenes &&
                            _loadAssets != null &&
                            _images.length > 0)
                          Padding(
                            padding: const EdgeInsets.only(top: 15),
                            child: Center(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  FlatButton(
                                    onPressed: () {
                                      _images = [];
                                      setState(() {});
                                    },
                                    child: Text("ELIMINAR NUEVAS"),
                                  ),
                                  FlatButton(
                                    onPressed: () {
                                      _loadAssets();
                                    },
                                    child: Text("MODIFICAR"),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        if (_content.type == SectionType.pois) Divider(),
                        if (_content.type == SectionType.pois)
                          StepMapa(
                            setDireccion: _setDireccion,
                            setLatLng: _setLatLng,
                            latitud: _content.latitud,
                            longitud: _content.longitud,
                            direccion: _content.direccion,
                          ),
                        SizedBox(
                          height: 15,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            RaisedButton(
                              onPressed: _sent ? null : _actualizar,
                              child: _sent
                                  ? SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 1,
                                      ),
                                    )
                                  : Text("ACTUALIZAR"),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
      ),
    );
  }
}
