import 'package:arrancando/config/globals/enums.dart';
import 'package:arrancando/config/models/content_wrapper.dart';
import 'package:arrancando/views/general/type_ahead_publicaciones_recetas_pois.dart';
import 'package:flutter/material.dart';

class AddLinkButton extends StatelessWidget {
  final TextEditingController controller;

  AddLinkButton({
    @required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.circle,
      color: Colors.transparent,
      child: Tooltip(
        message: "Añadir link a publicación/receta/p. interés",
        child: IconButton(
          icon: Icon(
            Icons.insert_link,
            color: Theme.of(context).accentColor,
          ),
          onPressed: () async {
            ContentWrapper item = await showDialog(
              context: context,
              builder: (_) => TypeAheadPublicacionesRecetasPois(),
            );

            if (item != null) {
              controller.text +=
                  " https://arrancando.com.ar/${item.type == SectionType.publicaciones ? 'publicaciones' : item.type == SectionType.recetas ? 'recetas' : 'pois'}/${item.id}";
            }
          },
        ),
      ),
    );
  }
}
