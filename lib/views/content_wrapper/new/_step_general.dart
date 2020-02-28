import 'package:arrancando/config/globals/enums.dart';
import 'package:flutter/material.dart';

class StepGeneral extends StatelessWidget {
  final TextEditingController tituloController;
  final TextEditingController cuerpoController;
  final TextEditingController introduccionController;
  final TextEditingController ingredientesController;
  final TextEditingController instruccionesController;
  final GlobalKey<FormState> formKey;
  final SectionType type;

  StepGeneral({
    @required this.tituloController,
    @required this.cuerpoController,
    @required this.introduccionController,
    @required this.ingredientesController,
    @required this.instruccionesController,
    @required this.formKey,
    @required this.type,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: <Widget>[
          TextFormField(
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(
              labelText: "Título",
              hintText: "Título",
            ),
            controller: tituloController,
          ),
          if (type != SectionType.recetas)
            TextFormField(
              textCapitalization: TextCapitalization.sentences,
              keyboardType: TextInputType.multiline,
              minLines: 7,
              maxLines: 7,
              decoration: InputDecoration(
                alignLabelWithHint: true,
                labelText: "Cuerpo",
                hintText: "Cuerpo",
              ),
              controller: ingredientesController,
            ),
          if (type == SectionType.recetas)
            TextFormField(
              textCapitalization: TextCapitalization.sentences,
              keyboardType: TextInputType.multiline,
              minLines: 7,
              maxLines: 7,
              decoration: InputDecoration(
                alignLabelWithHint: true,
                labelText: "Introducción",
                hintText: "Introducción",
              ),
              controller: introduccionController,
            ),
          if (type == SectionType.recetas)
            TextFormField(
              textCapitalization: TextCapitalization.sentences,
              keyboardType: TextInputType.multiline,
              minLines: 7,
              maxLines: 7,
              decoration: InputDecoration(
                alignLabelWithHint: true,
                labelText: "Ingredientes",
                hintText: "Ingredientes",
              ),
              controller: ingredientesController,
            ),
          if (type == SectionType.recetas)
            TextFormField(
              textCapitalization: TextCapitalization.sentences,
              keyboardType: TextInputType.multiline,
              minLines: 7,
              maxLines: 7,
              decoration: InputDecoration(
                alignLabelWithHint: true,
                labelText: "Instrucciones",
                hintText: "Instrucciones",
              ),
              controller: instruccionesController,
            ),
        ],
      ),
    );
  }
}
