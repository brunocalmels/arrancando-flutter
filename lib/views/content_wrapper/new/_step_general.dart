import 'package:flutter/material.dart';

class StepGeneral extends StatelessWidget {
  final TextEditingController tituloController;
  final TextEditingController cuerpoController;
  final GlobalKey<FormState> formKey;

  StepGeneral({
    @required this.tituloController,
    @required this.cuerpoController,
    @required this.formKey,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: <Widget>[
          TextFormField(
            decoration: InputDecoration(
              hasFloatingPlaceholder: false,
              labelText: "Título",
            ),
            controller: tituloController,
          ),
          TextFormField(
            keyboardType: TextInputType.multiline,
            minLines: 7,
            maxLines: 7,
            decoration: InputDecoration(
              alignLabelWithHint: true,
              hasFloatingPlaceholder: false,
              labelText: "Cuerpo",
            ),
            controller: tituloController,
          ),
        ],
      ),
    );
  }
}
