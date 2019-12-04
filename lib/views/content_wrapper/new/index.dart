import 'dart:convert';
import 'dart:io';

import 'package:arrancando/config/globals/enums.dart';
import 'package:arrancando/config/globals/index.dart';
import 'package:arrancando/config/models/category_wrapper.dart';
import 'package:arrancando/config/services/fetcher.dart';
import 'package:arrancando/views/content_wrapper/new/_step_categoria.dart';
import 'package:arrancando/views/content_wrapper/new/_step_general.dart';
import 'package:arrancando/views/content_wrapper/new/_step_imagenes.dart';
import 'package:arrancando/views/content_wrapper/new/_step_mapa.dart';
import 'package:arrancando/views/content_wrapper/show/index.dart';
import 'package:flutter/material.dart';

class NewContent extends StatefulWidget {
  final SectionType type;

  NewContent({
    @required this.type,
  });

  @override
  _NewContentState createState() => _NewContentState();
}

class _NewContentState extends State<NewContent> {
  int _currentStep = 0;
  final TextEditingController _tituloController = TextEditingController();
  final TextEditingController _cuerpoController = TextEditingController();
  final GlobalKey<FormState> _form1Key = GlobalKey<FormState>();
  CategoryWrapper _selectedCategory;
  // List<Asset> _images = List<Asset>();
  List<File> _images = List<File>();
  String _selectedDireccion;
  double _selectedLatitud;
  double _selectedLongitud;
  bool _sent = false;

  _createContent() async {
    setState(() {
      _sent = true;
    });

    try {
      Map<String, dynamic> body = {
        "titulo": _tituloController.text,
        "cuerpo": _cuerpoController.text,
        "imagenes": await Future.wait(
          _images.map(
            (i) async => {
              "file": i.path.split('/').last,
              "data": base64Encode(
                (await i.readAsBytes()).buffer.asUint8List(),
              )
            },
          ),
        ),
      };

      ResponseObject res;

      switch (widget.type) {
        case SectionType.publicaciones:
          res = await Fetcher.post(
            url: "/publicaciones.json",
            body: {
              ...body,
              "ciudad_id": _selectedCategory.id,
            },
          );
          break;
        case SectionType.recetas:
          res = await Fetcher.post(
            url: "/recetas.json",
            body: {
              ...body,
              "categoria_receta_id": _selectedCategory.id,
            },
          );
          break;
        case SectionType.pois:
          res = await Fetcher.post(
            url: "/pois.json",
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

      if (res != null && res.status == 201) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => ShowPage(
              contentId: json.decode(res.body)['id'],
              type: widget.type,
            ),
          ),
        );
      }
    } catch (e) {
      print(e);
    }

    if (mounted)
      setState(() {
        _sent = false;
      });
  }

  _setCategory(CategoryWrapper val) {
    setState(() {
      _selectedCategory = val;
    });
  }

  // _setImages(List<Asset> val) {
  _setImages(List<File> val) {
    setState(() {
      _images = val;
    });
  }

  _removeImage(File asset) {
    setState(() {
      _images.remove(asset);
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

  _onStepContinue() {
    switch (_currentStep) {
      case 0:
        if (_tituloController.text != null &&
            _tituloController.text.isNotEmpty &&
            _cuerpoController.text != null &&
            _cuerpoController.text.isNotEmpty) {
          setState(() {
            _currentStep = 1;
          });
        }
        break;
      case 1:
        if (_selectedCategory != null) {
          setState(() {
            _currentStep = 2;
          });
        }
        break;
      case 2:
        if (_images != null && _images.length > 0) {
          if (widget.type != SectionType.pois) {
            _createContent();
          } else {
            setState(() {
              _currentStep = 3;
            });
          }
        }
        break;
      case 3:
        if (_selectedDireccion != null &&
            _selectedLatitud != null &&
            _selectedLongitud != null) {
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
        } else
          return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Crear ${MyGlobals.NOMBRES_CATEGORIAS_SINGULAR[widget.type].toLowerCase()}",
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
                formKey: _form1Key,
              ),
            ),
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
              isActive: _currentStep == 2,
              content: StepImagenes(
                images: _images,
                setImages: _setImages,
                removeImage: _removeImage,
              ),
            ),
            if (widget.type == SectionType.pois)
              Step(
                title: Container(),
                isActive: _currentStep == 3,
                content: StepMapa(
                  setDireccion: _setDireccion,
                  setLatLng: _setLatLng,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
