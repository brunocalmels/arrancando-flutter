import 'package:arrancando/config/my_globals.dart';
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
        String type = "NONE";
        switch (content.type) {
          case "publicacion":
            type = "PUBLICACION";
            break;
          case "receta":
            type = "RECETA";
            break;
          case "poi":
            type = "POI";
            break;
          default:
        }
        print('GOTO $type ${content.id}');
      },
      trailing: Container(
        width: 40,
        child: Image.network(
          "${MyGlobals.SERVER_URL}${content.image}",
          fit: BoxFit.cover,
        ),
      ),
      title: Text(content.title),
    );
  }
}

class ContentWrapper {
  final int id;
  final String image;
  final String title;
  final String type;

  ContentWrapper({
    this.id,
    this.image,
    this.title,
    this.type,
  });
}
