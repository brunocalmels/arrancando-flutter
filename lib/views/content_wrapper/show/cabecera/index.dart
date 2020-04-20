import 'package:arrancando/config/globals/index.dart';
import 'package:arrancando/config/models/content_wrapper.dart';
import 'package:arrancando/views/content_wrapper/show/cabecera/_avatar_bubble.dart';
import 'package:arrancando/views/content_wrapper/show/cabecera/_image_cabecera.dart';
import 'package:arrancando/views/content_wrapper/show/cabecera/_row_estrellas.dart';
import 'package:arrancando/views/content_wrapper/show/cabecera/_row_iconos.dart';
import 'package:arrancando/views/content_wrapper/show/cabecera/_row_puntuaciones.dart';
import 'package:arrancando/views/content_wrapper/show/cabecera/_row_share_edit.dart';
import 'package:arrancando/views/content_wrapper/show/cabecera/_titulo_cabecera.dart';
import 'package:flutter/material.dart';

class CabeceraShow extends StatelessWidget {
  final ContentWrapper content;
  final Function fetchContent;

  CabeceraShow({
    @required this.content,
    @required this.fetchContent,
  });

  String _getFirstImage() {
    if (content.imagenes != null && content.imagenes.isNotEmpty) {
      if (['mp4', 'mpg', 'mpeg'].contains(
        content.imagenes.first.split('.').last.toLowerCase(),
      )) {
        return content.videoThumbs[content.imagenes.first].contains('http')
            ? content.videoThumbs[content.imagenes.first]
            : "${MyGlobals.SERVER_URL}${content.videoThumbs[content.imagenes.first]}";
      } else {
        return content.imagenes.first.contains('http')
            ? content.imagenes.first
            : "${MyGlobals.SERVER_URL}${content.imagenes.first}";
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Stack(
        children: <Widget>[
          Positioned.fill(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                ImageCabecera(
                  src: _getFirstImage(),
                ),
              ],
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              RowShareEdit(
                content: content,
                fetchContent: fetchContent,
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.16,
              ),
              SizedBox(
                height: 5,
              ),
              RowIconos(),
              SizedBox(
                height: 5,
              ),
              AvatarBubble(
                user: content.user,
              ),
              SizedBox(
                height: 5,
              ),
              TituloCabecera(
                titulo: content.titulo,
              ),
              SizedBox(
                height: 5,
              ),
              RowEstrellas(
                content: content,
              ),
              SizedBox(
                height: 5,
              ),
              RowPuntuaciones(
                content: content,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
