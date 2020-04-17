import 'package:arrancando/config/models/content_wrapper.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class TextosShow extends StatelessWidget {
  final ContentWrapper content;

  TextosShow({
    @required this.content,
  });

  List<dynamic> _parseTexto(String cuerpo) {
    var urlPattern =
        r"(https://?|http://?)([-A-Z0-9.]+)(/[-A-Z0-9+&@#/%=~_|!:,.;]*)?(\?[A-Z0-9+&@#/%=~_|!:‌​,.;]*)?";

    var results = new RegExp(
      urlPattern,
      caseSensitive: false,
    ).allMatches(cuerpo);
    List<dynamic> chunks = [];
    int lastEnd = 0;
    results.forEach(
      (r) {
        chunks.add(
          {
            "texto": cuerpo.substring(
              lastEnd,
              r.start,
            ),
            "tipo": "texto",
          },
        );
        chunks.add(
          {
            "texto": cuerpo.substring(
              r.start,
              r.end,
            ),
            "tipo": "link",
          },
        );
        lastEnd = r.end;
      },
    );
    if (chunks.length == 0)
      chunks.add(
        {
          "texto": cuerpo,
          "tipo": "texto",
        },
      );
    return chunks;
  }

  Widget _buildTexto(BuildContext context, String texto, {String label}) =>
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
            SelectableText.rich(
              TextSpan(
                children: _parseTexto(texto)
                    .map(
                      (chunk) => TextSpan(
                        text: chunk['texto'],
                        style: chunk['tipo'] != 'link'
                            ? TextStyle(
                                color: Theme.of(context)
                                    .textTheme
                                    .body1
                                    .color
                                    .withAlpha(150),
                                fontFamily: 'Monserrat',
                              )
                            : TextStyle(
                                color: Colors.blue,
                                fontFamily: 'Monserrat',
                              ),
                        recognizer: chunk['tipo'] != 'link'
                            ? null
                            : (TapGestureRecognizer()
                              ..onTap = () async {
                                if (await canLaunch(chunk['texto'])) {
                                  await launch(
                                    chunk['texto'],
                                    forceSafariVC: false,
                                    forceWebView: false,
                                  );
                                } else {
                                  throw 'Could not launch ${chunk['texto']}';
                                }
                              }),
                      ),
                    )
                    .toList(),
              ),
              textAlign: TextAlign.justify,
            ),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        if (content.cuerpo != null && content.cuerpo.isNotEmpty)
          _buildTexto(context, content.cuerpo),
        if (content.introduccion != null && content.introduccion.isNotEmpty)
          _buildTexto(
            context,
            content.introduccion,
            label: "Introducción",
          ),
        if (content.ingredientes != null && content.ingredientes.isNotEmpty)
          _buildTexto(
            context,
            content.ingredientes,
            label: "Ingredientes",
          ),
        if (content.instrucciones != null && content.instrucciones.isNotEmpty)
          _buildTexto(
            context,
            content.instrucciones,
            label: "Instrucciones",
          ),
      ],
    );
  }
}
