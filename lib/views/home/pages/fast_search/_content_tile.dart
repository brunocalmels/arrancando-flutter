import 'package:arrancando/config/globals/enums.dart';
import 'package:arrancando/config/globals/index.dart';
import 'package:arrancando/config/models/content_wrapper.dart';
import 'package:flutter/material.dart';

class ContentTile extends StatelessWidget {
  final ContentWrapper content;

  ContentTile({
    this.content,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        String type = "HOME";
        switch (content.type) {
          case SectionType.publicaciones:
            type = "PUBLICACION";
            break;
          case SectionType.recetas:
            type = "RECETA";
            break;
          case SectionType.pois:
            type = "POI";
            break;
          default:
        }
        print('GOTO $type ${content.id}');
      },
      trailing: Container(
        width: 40,
        child: Image.network(
          "${MyGlobals.SERVER_URL}${content.imagenes.first}",
          fit: BoxFit.cover,
        ),
      ),
      title: Text(content.titulo),
    );
  }
}
