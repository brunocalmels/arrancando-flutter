import 'package:arrancando/config/globals/enums.dart';
import 'package:arrancando/config/globals/index.dart';
import 'package:arrancando/config/models/content_wrapper.dart';
import 'package:arrancando/views/general/type_ahead_publicaciones_recetas.dart';
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

  Widget _botonAddLink(
    BuildContext context,
    TextEditingController controller,
  ) =>
      Tooltip(
        message: "Añadir link a publicación/receta",
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white70,
            borderRadius: BorderRadius.circular(50),
          ),
          child: IconButton(
            icon: Icon(Icons.insert_link),
            onPressed: () async {
              ContentWrapper item = await showDialog(
                context: context,
                builder: (_) => TypeAheadPublicacionesRecetas(),
              );

              if (item != null) {
                controller.text +=
                    " https://arrancando.com.ar/${item.type == SectionType.publicaciones ? 'publicaciones' : 'recetas'}/${item.id}";
              }
            },
          ),
        ),
      );

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
            Stack(
              fit: StackFit.passthrough,
              children: <Widget>[
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
                  controller: cuerpoController,
                ),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: _botonAddLink(context, cuerpoController),
                ),
              ],
            ),
          if (type == SectionType.recetas)
            Stack(
              fit: StackFit.passthrough,
              children: <Widget>[
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
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: _botonAddLink(context, introduccionController),
                ),
              ],
            ),
          if (type == SectionType.recetas)
            Stack(
              fit: StackFit.passthrough,
              children: <Widget>[
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
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: _botonAddLink(context, ingredientesController),
                ),
              ],
            ),
          if (type == SectionType.recetas)
            Stack(
              fit: StackFit.passthrough,
              children: <Widget>[
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
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: _botonAddLink(context, instruccionesController),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
