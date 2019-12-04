import 'package:arrancando/config/globals/index.dart';
import 'package:arrancando/config/models/content_wrapper.dart';
import 'package:arrancando/views/content_wrapper/show/index.dart';
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
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => ShowPage(
              contentId: content.id,
              type: content.type,
            ),
          ),
        );
      },
      trailing: Container(
        width: 40,
        child: content != null &&
                content.imagenes != null &&
                content.imagenes.length == 0
            ? Center(
                child: Icon(
                  Icons.photo_camera,
                  color: Color(0x33000000),
                ),
              )
            : Image.network(
                "${MyGlobals.SERVER_URL}${content.imagenes.first}",
                fit: BoxFit.cover,
              ),
      ),
      title: Text(content.titulo),
    );
  }
}
