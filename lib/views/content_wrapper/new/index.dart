import 'dart:convert';
import 'dart:io';

import 'package:arrancando/config/globals/enums.dart';
import 'package:arrancando/config/globals/global_singleton.dart';
import 'package:arrancando/config/globals/index.dart';
import 'package:arrancando/config/models/category_wrapper.dart';
import 'package:arrancando/config/services/fetcher.dart';
import 'package:arrancando/config/state/user.dart';
import 'package:arrancando/views/content_wrapper/new/_step_categoria.dart';
import 'package:arrancando/views/content_wrapper/new/_step_general.dart';
import 'package:arrancando/views/content_wrapper/new/_step_imagenes.dart';
import 'package:arrancando/views/content_wrapper/new/_step_mapa.dart';
import 'package:arrancando/views/content_wrapper/show/index.dart';
import 'package:arrancando/views/home/app_bar/_dialog_category_select.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NewContent extends StatefulWidget {
  final SectionType type;

  NewContent({
    @required this.type,
  });

  @override
  _NewContentState createState() => _NewContentState();
}

class _NewContentState extends State<NewContent> {
  final _scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
  final TextEditingController _tituloController = TextEditingController();
  final TextEditingController _cuerpoController = TextEditingController();
  final TextEditingController _introduccionController = TextEditingController();
  final TextEditingController _ingredientesController = TextEditingController();
  final TextEditingController _instruccionesController =
      TextEditingController();
  final GlobalKey<FormState> _form1Key = GlobalKey<FormState>();
  int _currentStep = 0;
  CategoryWrapper _selectedCategory;
  // CategoryWrapper _selectedCiudadPoi;
  // List<Asset> _images = List<Asset>();
  var _images = <File>[];
  String _selectedDireccion;
  double _selectedLatitud;
  double _selectedLongitud;
  bool _sent = false;
  bool _hideButtonVeryBadError = false;
  String _errorMsg;
  final GlobalSingleton gs = GlobalSingleton();

  Future<void> _createContent() async {
    _errorMsg = null;
    setState(() {
      _sent = true;
    });

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
      };

      ResponseObject res;

      switch (widget.type) {
        case SectionType.publicaciones:
          final prefs = await SharedPreferences.getInstance();
          var preferredCiudadId = prefs.getInt('preferredCiudadId');

          if (preferredCiudadId == null) {
            final ciudadId = await showDialog(
              context: context,
              builder: (_) => DialogCategorySelect(
                selectCity: true,
                titleText: '¿Cuál es tu ciudad?',
                allowDismiss: false,
              ),
            );

            if (gs.categories[SectionType.publicaciones].isEmpty) {
              await CategoryWrapper.loadCategories();
            }

            if (ciudadId != null) {
              context.read<UserState>().setPreferredCategories(
                    SectionType.publicaciones,
                    ciudadId,
                  );
              final prefs = await SharedPreferences.getInstance();
              await prefs.setInt('preferredCiudadId', ciudadId);
              preferredCiudadId = ciudadId;
            }
          }

          res = await Fetcher.post(
            url: '/publicaciones.json',
            throwError: true,
            body: {
              ...body,
              // 'ciudad_id': _selectedCategory.id,
              'ciudad_id': preferredCiudadId,
            },
          );
          break;
        case SectionType.recetas:
          res = await Fetcher.post(
            url: '/recetas.json',
            throwError: true,
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
          String nombreProvincia;
          String nombreCiudad;
          final places = await placemarkFromCoordinates(
            _selectedLatitud,
            _selectedLongitud,
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
          res = await Fetcher.post(
            url: '/pois.json',
            throwError: true,
            body: {
              ...body,
              'categoria_poi_id': _selectedCategory.id,
              // 'ciudad_id': _selectedCiudadPoi.id,
              'nombre_provincia': nombreProvincia,
              'nombre_ciudad': nombreCiudad,
              'lat': _selectedLatitud,
              'long': _selectedLongitud,
              'direccion': _selectedDireccion,
            },
          );
          break;
        default:
      }

      if (res != null && res.status == 201) {
        print(
            '${widget.type.toString().split('.').last[0].toLowerCase()}${widget.type.toString().split('.').last.substring(1)}#${json.decode(res.body)['id']}');
        await Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => ShowPage(
              contentId: json.decode(res.body)['id'],
              type: widget.type,
            ),
            settings: RouteSettings(
              name:
                  '${widget.type.toString().split('.').last[0].toLowerCase()}${widget.type.toString().split('.').last.substring(1)}#${json.decode(res.body)['id']}',
            ),
          ),
        );
      } else {
        if (res != null && res.body != null) {
          _errorMsg =
              (json.decode(res.body) as Map).values.expand((i) => i).join(',');
        } else {
          _errorMsg =
              'Ocurrió un error, por favor intentalo nuevamente más tarde.';
          _hideButtonVeryBadError = true;
        }
        if (mounted) setState(() {});
      }
    } catch (e) {
      print(e);
    }

    _sent = false;
    if (mounted) setState(() {});
  }

  void _setCategory(CategoryWrapper val) {
    _selectedCategory = val;
    if (mounted) setState(() {});
  }

  void _setCiudadPoi(CategoryWrapper ciudad) {
    // _selectedCiudadPoi = ciudad;
    // if (mounted) setState(() {});
  }

  // _setImages(List<Asset> val) {
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

  Future<int> _computeSize() async {
    final pesos = (await Future.wait(
      _images.map(
        (i) => i.length(),
      ),
    ))
        .fold(
      0,
      (sum, i) => sum + i,
    );
    return pesos;
  }

  Widget _muchoPesoArchivos() => FutureBuilder(
        future: _computeSize(),
        builder: (context, AsyncSnapshot<int> snapshot) {
          if (snapshot.hasData &&
              snapshot.data >= MyGlobals.MUCHO_PESO_PUBLICACION) {
            return Padding(
              padding: const EdgeInsets.only(top: 15),
              child: Text(
                'Estás subiendo archivos muy pesados, la creación puede tardar.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 13,
                ),
              ),
            );
          }
          return Container();
        },
      );

  void _onStepContinue() {
    switch (_currentStep) {
      case 0:
        if (_tituloController.text != null &&
            _tituloController.text.isNotEmpty) {
          setState(() {
            _currentStep = 1;
          });
        }
        break;
      case 1:
        if (widget.type != SectionType.publicaciones) {
          if (_selectedCategory != null) {
            setState(() {
              _currentStep = 2;
            });
          }
        } else if (_images == null || _images.isEmpty) {
          _scaffoldMessengerKey.currentState.showSnackBar(
            SnackBar(
              content: Text(
                  'Es necesario añadir al menos una imagen para poder crear un contenido.'),
            ),
          );
        } else {
          _createContent();
        }

        break;
      case 2:
        if (_images != null && _images.isNotEmpty) {
          if (widget.type != SectionType.pois) {
            _createContent();
          } else {
            setState(() {
              _currentStep = 3;
            });
          }
        } else {
          _scaffoldMessengerKey.currentState.showSnackBar(
            SnackBar(
              content: Text(
                  'Es necesario añadir al menos una imagen para poder crear un contenido.'),
            ),
          );
        }
        break;
      case 3:
        if (_selectedLatitud != null && _selectedLongitud != null) {
          _createContent();
        }
        break;
      default:
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (!_sent) {
          if (_currentStep > 0) {
            setState(() {
              _currentStep = _currentStep - 1;
            });
            return false;
          }
          return true;
        } else {
          return false;
        }
      },
      child: ScaffoldMessenger(
        key: _scaffoldMessengerKey,
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              'Crear ${MyGlobals.NOMBRES_CATEGORIAS_SINGULAR[widget.type].toLowerCase()}',
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            backgroundColor: Colors.white,
            iconTheme: IconThemeData(color: Colors.black),
          ),
          body: Stepper(
            type: StepperType.horizontal,
            currentStep: _currentStep,
            controlsBuilder: (
              BuildContext context, {
              VoidCallback onStepContinue,
              VoidCallback onStepCancel,
            }) {
              return Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    if (!_hideButtonVeryBadError)
                      FlatButton(
                        onPressed: _sent ? null : onStepContinue,
                        child: _sent
                            ? SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 1,
                                ),
                              )
                            : Text(
                                'Continuar',
                              ),
                      ),
                  ],
                ),
              );
            },
            onStepContinue: _onStepContinue,
            steps: <Step>[
              Step(
                title: Container(),
                isActive: _currentStep == 0,
                content: StepGeneral(
                  tituloController: _tituloController,
                  cuerpoController: _cuerpoController,
                  introduccionController: _introduccionController,
                  ingredientesController: _ingredientesController,
                  instruccionesController: _instruccionesController,
                  formKey: _form1Key,
                  type: widget.type,
                ),
              ),
              if (widget.type != SectionType.publicaciones)
                Step(
                  title: Container(),
                  isActive: _currentStep == 1,
                  content: StepCategoria(
                    type: widget.type,
                    selectedCategory: _selectedCategory,
                    setCategory: _setCategory,
                  ),
                ),
              Step(
                title: Container(),
                isActive: widget.type == SectionType.publicaciones
                    ? _currentStep == 1
                    : _currentStep == 2,
                content: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    StepImagenes(
                      images: _images,
                      setImages: _setImages,
                      removeImage: _removeImage,
                    ),
                    if (widget.type != SectionType.pois && _errorMsg != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 15),
                        child: Text(
                          _errorMsg,
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    if (widget.type != SectionType.pois) _muchoPesoArchivos(),
                  ],
                ),
              ),
              if (widget.type == SectionType.pois)
                Step(
                  title: Container(),
                  isActive: _currentStep == 3,
                  content: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      StepMapa(
                        setCiudadPoi: _setCiudadPoi,
                        setDireccion: _setDireccion,
                        setLatLng: _setLatLng,
                      ),
                      if (_errorMsg != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 15),
                          child: Text(
                            _errorMsg,
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      _muchoPesoArchivos(),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
