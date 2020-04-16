import 'package:arrancando/config/models/content_wrapper.dart';
import 'package:arrancando/views/cards/_row_puntajes.dart';
import 'package:arrancando/views/content_wrapper/show/_avatar_bubble.dart';
import 'package:arrancando/views/content_wrapper/show/_image_cabecera.dart';
import 'package:arrancando/views/content_wrapper/show/_row_estrellas.dart';
import 'package:arrancando/views/content_wrapper/show/_row_iconos.dart';
import 'package:arrancando/views/content_wrapper/show/_row_puntuaciones.dart';
import 'package:arrancando/views/content_wrapper/show/_row_share.dart';
import 'package:arrancando/views/content_wrapper/show/_titulo_cabecera.dart';
import 'package:flutter/material.dart';

class CabeceraShow extends StatelessWidget {
  final ContentWrapper content;
  final String imageSrc;

  CabeceraShow({
    @required this.content,
    @required this.imageSrc,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.75,
      child: Stack(
        children: <Widget>[
          Positioned.fill(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                ImageCabecera(
                  src: imageSrc,
                ),
                Expanded(
                  child: Container(),
                ),
              ],
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              RowShare(
                content: content,
              ),
              Expanded(
                child: Container(),
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
