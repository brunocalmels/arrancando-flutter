import 'dart:convert';

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
import 'package:multi_image_picker/multi_image_picker.dart';

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
  List<Asset> _images = List<Asset>();
  String _selectedDireccion;
  double _selectedLatitud;
  double _selectedLongitud;
  bool _sent = false;

  _createContent() async {
    setState(() {
      _sent = true;
    });

    try {
      switch (widget.type) {
        case SectionType.publicaciones:
          ResponseObject res = await Fetcher.post(
            url: "/publicaciones.json",
            body: {
              "titulo": _tituloController.text,
              "cuerpo": _cuerpoController.text,
              "ciudad_id": _selectedCategory.id,
            },
          );

          if (res.status == 201) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (_) => ShowPage(
                  contentId: json.decode(res.body)['id'],
                ),
              ),
            );
          }

          break;
        default:
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
