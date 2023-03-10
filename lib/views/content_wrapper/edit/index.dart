import 'dart:convert';
import 'dart:io';

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
import 'package:arrancando/views/general/type_ahead_ciudad.dart';
import 'package:arrancando/views/home/pages/_loading_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

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
  final TextEditingController _introduccionController = TextEditingController();
  final TextEditingController _ingredientesController = TextEditingController();
  final TextEditingController _instruccionesController =
      TextEditingController();
  final GlobalKey<FormState> _form1Key = GlobalKey<FormState>();
  CategoryWrapper _selectedCategory;
  List<File> _images = [];
  String _selectedDireccion;
  double _selectedLatitud;
  double _selectedLongitud;
  bool _sent = false;
  final _enableImagenes = false;
  final _removeImagenes = <String>[];
  Function _loadAssets;
  // Map<String, File> _videoThumbs = {};

  Future<void> _fetchContent() async {
    switch (widget.type) {
      case SectionType.publicaciones:
        _url = '/publicaciones';
        break;
      case SectionType.recetas:
        _url = '/recetas';
        break;
      case SectionType.pois:
        _url = '/pois';
        break;
      default:
        _url = '/publicaciones';
    }

    final resp = await Fetcher.get(
      url: '$_url/${widget.contentId}.json',
    );

    if (resp != null) {
      _content = ContentWrapper.fromJson(json.decode(resp.body));
      _content.type = widget.type;
      _tituloController.text = _content.titulo;
      _cuerpoController.text = _content.cuerpo;
      _introduccionController.text = _content.introduccion;
      _ingredientesController.text = _content.ingredientes;
      _instruccionesController.text = _content.instrucciones;
      _selectedCategory = CategoryWrapper.fromJson({
        'id': _content.categID,
        'nombre': gs.categories[_content.type]
            .firstWhere((c) => c.id == _content.categID)
            .nombre,
        'type': _content.type.toString().split('.')[1],
      });
      _selectedLatitud = _content.latitud;
      _selectedLongitud = _content.longitud;
      _selectedDireccion = _content.direccion;
    }

    await Future.delayed(Duration(seconds: 1));
    // _getVideosThumbs();
    _fetching = false;
    if (mounted) setState(() {});
  }

  void _setCategory(CategoryWrapper val) {
    _selectedCategory = val;
    if (mounted) setState(() {});
  }

  void _setImages(List<File> val) {
    _images = val;
    if (mounted) setState(() {});
  }

  void _removeImage(File asset) {
    _images.remove(asset);
    if (mounted) setState(() {});
  }

  void _setDireccion(String val) {
    _selectedDireccion = val;
    if (mounted) setState(() {});
  }

  void _setLatLng(double l1, double l2) {
    _selectedLatitud = l1;
    _selectedLongitud = l2;
    if (mounted) setState(() {});
  }

  void _actualizar() async {
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
        'remove_imagenes': _removeImagenes,
      };

      ResponseObject res;

      switch (widget.type) {
        case SectionType.publicaciones:
          res = await Fetcher.put(
            url: '/publicaciones/${_content.id}.json',
            body: {
              ...body,
              'ciudad_id': _selectedCategory.id,
            },
          );
          break;
        case SectionType.recetas:
          res = await Fetcher.put(
            url: '/recetas/${_content.id}.json',
            body: {
              ...body,
              'categoria_receta_id': _selectedCategory.id,
              'introduccion': _introduccionController.text,
              'ingredientes': _ingredientesController.text,
              'instrucciones': _instruccionesController.text,
            },
          );
          break;
        case SectionType.pois:
          res = await Fetcher.put(
            url: '/pois/${_content.id}.json',
            body: {
              ...body,
              'categoria_poi_id': _selectedCategory.id,
              'lat': _selectedLatitud,
              'long': _selectedLongitud,
              'direccion': _selectedDireccion,
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

    _sent = false;
    if (mounted) setState(() {});
  }

  // Future<void> _getVideosThumbs() async {
  //   _videoThumbs = {};
  //   final thumbPath = (await getTemporaryDirectory()).path;
  //   await Future.wait(
  //     _content.imagenes.map(
  //       (i) async {
  //         if (MyGlobals.VIDEO_FORMATS
  //             .contains(i.split('.').last.toLowerCase())) {
  //           _videoThumbs[i] = File(
  //             await VideoThumbnail.thumbnailFile(
  //               video: '${MyGlobals.SERVER_URL}$i',
  //               thumbnailPath: thumbPath,
  //               imageFormat: ImageFormat.WEBP,
  //               maxHeightOrWidth: 250,
  //               quality: 70,
  //             ),
  //           );
  //         }
  //       },
  //     ),
  //   );
  //   if (mounted) setState(() {});
  // }

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
                      child: Text('Ocurri?? un error'),
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
                          introduccionController: _introduccionController,
                          ingredientesController: _ingredientesController,
                          instruccionesController: _instruccionesController,
                          type: widget.type,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(_content.type == SectionType.publicaciones
                            ? 'Ciudad'
                            : 'Categor??a'),
                        _content.type == SectionType.publicaciones
                            ? Container(
                                height: 150,
                                child: SingleChildScrollView(
                                  child: TypeAheadCiudad(
                                    insideEdit: true,
                                    onItemTap: _setCategory,
                                  ),
                                ),
                              )
                            : StepCategoria(
                                selectedCategory: _selectedCategory,
                                setCategory: _setCategory,
                                type: _content.type,
                              ),
                        if (_content.type == SectionType.publicaciones)
                          Text('Ciudad: ${_selectedCategory.nombre}'),
                        Divider(),
                        Text('Im??genes'),
                        Text(
                          _removeImagenes.isNotEmpty
                              ? 'Se ${_removeImagenes.length == 1 ? 'eliminar??' : 'eliminar??n'} ${_removeImagenes.length} ${_removeImagenes.length == 1 ? 'imagen' : 'im??genes'}'
                              : '',
                          style: TextStyle(
                            fontSize: 12,
                          ),
                        ),
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
                                        child: MyGlobals.VIDEO_FORMATS.contains(
                                                i.split('.').last.toLowerCase())
                                            ? _content.videoThumbs[i] == null
                                                ? SizedBox(
                                                    height: 25,
                                                    width: 25,
                                                    child: Center(
                                                      child:
                                                          CircularProgressIndicator(
                                                        strokeWidth: 2,
                                                      ),
                                                    ),
                                                  )
                                                : Stack(
                                                    fit: StackFit.passthrough,
                                                    children: <Widget>[
                                                      Center(
                                                        child:
                                                            // Image.file(
                                                            //   _videoThumbs[i],
                                                            // ),
                                                            CachedNetworkImage(
                                                          imageUrl:
                                                              '${MyGlobals.SERVER_URL}${_content.videoThumbs[i]}',
                                                          placeholder:
                                                              (context, url) =>
                                                                  Center(
                                                            child: SizedBox(
                                                              width: 25,
                                                              height: 25,
                                                              child:
                                                                  CircularProgressIndicator(
                                                                strokeWidth: 2,
                                                              ),
                                                            ),
                                                          ),
                                                          errorWidget: (context,
                                                                  url, error) =>
                                                              Icon(Icons.error),
                                                        ),
                                                      ),
                                                      Center(
                                                        child: Icon(
                                                          Icons.play_arrow,
                                                          color: Colors.white,
                                                        ),
                                                      )
                                                    ],
                                                  )
                                            // : Image.network(
                                            //     '${MyGlobals.SERVER_URL}$i',
                                            //   ),
                                            : CachedNetworkImage(
                                                imageUrl:
                                                    '${MyGlobals.SERVER_URL}$i',
                                                placeholder: (context, url) =>
                                                    Center(
                                                  child: SizedBox(
                                                    width: 25,
                                                    height: 25,
                                                    child:
                                                        CircularProgressIndicator(
                                                      strokeWidth: 2,
                                                    ),
                                                  ),
                                                ),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        Icon(Icons.error),
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
                                            color: Color(0x99000000),
                                            onPressed: () {
                                              _removeImagenes.remove(i);
                                              setState(() {});
                                            },
                                            child: Center(
                                              child: Icon(
                                                Icons.delete,
                                                color: Color(0xccff0000),
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
                        // if (_enableImagenes)
                        StepImagenes(
                          images: _images,
                          setImages: _setImages,
                          removeImage: _removeImage,
                        ),
                        // if (!_enableImagenes)
                        //   Padding(
                        //     padding: const EdgeInsets.only(top: 15),
                        //     child: Center(
                        //       child: FlatButton(
                        //         onPressed: () {
                        //           setState(() {
                        //             _enableImagenes = true;
                        //           });
                        //         },
                        //         child: Text('A??ADIR IM??GENES'),
                        //       ),
                        //     ),
                        //   ),
                        if (_enableImagenes &&
                            _loadAssets != null &&
                            _images.isNotEmpty)
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
                                    child: Text('ELIMINAR NUEVAS'),
                                  ),
                                  FlatButton(
                                    onPressed: () {
                                      _loadAssets();
                                    },
                                    child: Text('MODIFICAR'),
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
                            setCiudadPoi: _setCategory,
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
                                  : Text('ACTUALIZAR'),
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
