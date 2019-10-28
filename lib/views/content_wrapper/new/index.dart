import 'package:arrancando/config/globals/enums.dart';
import 'package:arrancando/views/content_wrapper/new/_step_general.dart';
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

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_currentStep > 0) {
          setState(() {
            _currentStep = _currentStep - 1;
          });
          return false;
        }
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
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
                    onPressed: onStepContinue,
                    child: Text(
                      _currentStep >= 2 ? 'Terminar' : 'Siguiente',
                    ),
                  ),
                ],
              ),
            );
          },
          onStepContinue: _currentStep >= 2
              ? () {
                  print("Listorti");
                }
              : () {
                  setState(() {
                    _currentStep = _currentStep + 1;
                  });
                },
          steps: <Step>[
            Step(
              title: Text('General'),
              isActive: _currentStep == 0,
              content: StepGeneral(
                tituloController: _tituloController,
                cuerpoController: _cuerpoController,
                formKey: _form1Key,
              ),
            ),
            Step(
              title: Text('Categoría'),
              isActive: _currentStep == 1,
              content: Container(color: Colors.green),
            ),
            Step(
              title: Text('Imágenes'),
              isActive: _currentStep == 2,
              content: Container(color: Colors.blue),
            ),
          ],
        ),
      ),
    );
  }
}
