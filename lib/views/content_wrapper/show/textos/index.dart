import 'package:arrancando/config/globals/enums.dart';
import 'package:arrancando/config/models/content_wrapper.dart';
import 'package:arrancando/views/search/index.dart';
import 'package:arrancando/views/user_profile/index.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class TextosShow extends StatelessWidget {
  final ContentWrapper content;
  final TextAlign textAlign;
  final double fontSize;
  final String fullText;
  final bool paddingZero;

  TextosShow({
    @required this.content,
    this.textAlign = TextAlign.justify,
    this.fontSize = 14,
    this.fullText,
    this.paddingZero = false,
  });

  List<dynamic> _parseTexto(String cuerpo) {
    var urlPattern =
        r"(https://?|http://?)([-A-Z0-9.]+)(/[-A-Z0-9+&@#/%=~_|!:,.;]*)?(\?[A-Z0-9+&@#/%=~_|!:‌​,.;]*)?";

    List<dynamic> chunks2 = [];

    var outTexto = "";
    _saveAndClear() {
      chunks2.add({
        "tipo": "texto",
        "texto": outTexto,
      });
      outTexto = '';
    }

    cuerpo
        .replaceAll('\r', '')
        .replaceAll('\n', ' \n ')
        .split(' ')
        .forEach((piece) {
      if (piece != null && piece.isNotEmpty) {
        if (piece[0] == "@") {
          _saveAndClear();
          chunks2.add({
            "tipo": "username",
            "texto": "$piece ",
          });
        } else if (piece[0] == "#") {
          _saveAndClear();
          chunks2.add({
            "tipo": "hashtag",
            "texto": "$piece ",
          });
        } else if (RegExp(urlPattern, caseSensitive: false)
                .allMatches(piece)
                .length >
            0) {
          _saveAndClear();
          chunks2.add({
            "tipo": "link",
            "texto": "$piece ",
          });
        } else {
          if (piece == "\n")
            outTexto += "$piece";
          else
            outTexto += "$piece ";
        }
      }
    });

    if (outTexto != "") _saveAndClear();

    return chunks2;
  }

  Widget _buildTexto(BuildContext context, String texto, {String label}) =>
      Padding(
        padding: EdgeInsets.only(
          left: paddingZero ? 0 : 15,
          top: paddingZero ? 0 : 15,
          right: paddingZero ? 0 : 15,
          bottom: paddingZero ? 0 : 25,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            if (label != null)
              Padding(
                padding: const EdgeInsets.only(
                  bottom: 5,
                ),
                child: Text(
                  label,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
                ),
              ),
            RichText(
              text: TextSpan(
                children: _parseTexto(texto)
                    .map(
                      (chunk) => TextSpan(
                        text: chunk['texto'],
                        style: chunk['tipo'] != 'link' &&
                                chunk['tipo'] != 'username' &&
                                chunk['tipo'] != 'hashtag'
                            ? TextStyle(
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyText2
                                    .color
                                    .withAlpha(150),
                                fontFamily: 'Monserrat',
                                fontSize: fontSize,
                              )
                            : TextStyle(
                                color: Colors.blue,
                                fontFamily: 'Monserrat',
                                fontSize: fontSize,
                              ),
                        recognizer: chunk['tipo'] != 'link'
                            ? chunk['tipo'] != 'username'
                                ? chunk['tipo'] != 'hashtag'
                                    ? null
                                    : (TapGestureRecognizer()
                                      ..onTap = () async {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (_) => SearchPage(
                                              originalType:
                                                  SectionType.publicaciones,
                                              originalSearch:
                                                  (chunk['texto'] as String)
                                                      .trim(),
                                            ),
                                            settings: RouteSettings(
                                              name: 'Search',
                                            ),
                                          ),
                                        );
                                      })
                                : (TapGestureRecognizer()
                                  ..onTap = () async {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (_) => UserProfilePage(
                                          user: null,
                                          username: chunk["texto"]
                                              .replaceAll('@', ''),
                                        ),
                                        settings: RouteSettings(
                                            name: 'UserProfilePage'),
                                      ),
                                    );
                                  })
                            : (TapGestureRecognizer()
                              ..onTap = () async {
                                var link = chunk['texto'].trim();
                                print(link);
                                if (await canLaunch(link)) {
                                  await launch(
                                    link,
                                    forceSafariVC: false,
                                    forceWebView: false,
                                  );
                                } else {
                                  throw 'Could not launch $link';
                                }
                              }),
                      ),
                    )
                    .toList(),
              ),
              textAlign: textAlign,
            ),
          ],
        ),
      );

  Widget _buildIngredientesItems(
    BuildContext context,
    List<Map> ingredientes, {
    String label,
  }) =>
      Padding(
        padding: const EdgeInsets.only(
          left: 15,
          top: 15,
          right: 15,
          bottom: 25,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            if (label != null)
              Padding(
                padding: const EdgeInsets.only(
                  bottom: 5,
                ),
                child: Text(
                  label,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
                ),
              ),
            ...ingredientes
                .map(
                  (i) => Text(
                      "${i['cantidad']} ${i['unidad']} de ${i['ingrediente']}"),
                )
                .toList(),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    return fullText == null
        ? Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              if (content.cuerpo != null && content.cuerpo.isNotEmpty)
                _buildTexto(context, content.cuerpo),
              if (content.introduccion != null &&
                  content.introduccion.isNotEmpty)
                _buildTexto(
                  context,
                  content.introduccion,
                  label: "Introducción",
                ),
              content.ingredientesItems != null &&
                      content.ingredientesItems.isNotEmpty
                  ? _buildIngredientesItems(
                      context,
                      content.ingredientesItems,
                      label: "Ingredientes",
                    )
                  : content.ingredientes != null &&
                          content.ingredientes.isNotEmpty
                      ? _buildTexto(
                          context,
                          content.ingredientes,
                          label: "Ingredientes",
                        )
                      : Container(),
              if (content.instrucciones != null &&
                  content.instrucciones.isNotEmpty)
                _buildTexto(
                  context,
                  content.instrucciones,
                  label: "Instrucciones",
                ),
            ],
          )
        : _buildTexto(
            context,
            fullText,
          );
  }
}
