import 'package:arrancando/config/globals/enums.dart';
import 'package:arrancando/config/services/utils.dart';
import 'package:arrancando/views/search/index.dart';
import 'package:arrancando/views/user_profile/index.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ComplexMensaje extends StatelessWidget {
  final String texto;
  final double fontSize;

  ComplexMensaje({
    @required this.texto,
    this.fontSize = 14,
  });

  Widget _buildTexto(BuildContext context, String texto, {String label}) =>
      Column(
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
              children: Utils.parseTexto(texto)
                  .map(
                    (chunk) => TextSpan(
                        text: chunk['texto'],
                        style: chunk['tipo'] != 'link' &&
                                chunk['tipo'] != 'username' &&
                                chunk['tipo'] != 'hashtag'
                            ? TextStyle(
                                color:
                                    Utils.activeTheme(context) == ThemeMode.dark
                                        ? Theme.of(context)
                                            .textTheme
                                            .bodyText2
                                            .color
                                            .withAlpha(150)
                                        : Colors.black,
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
                                      ..onTap = () {
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
                                    await Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (_) => UserProfilePage(
                                          user: null,
                                          username: chunk['texto']
                                              .replaceAll('@', ''),
                                        ),
                                        settings: RouteSettings(
                                            name:
                                                'UserProfilePage#${chunk['texto'].replaceAll('@', '')}'),
                                      ),
                                    );
                                  })
                            : (TapGestureRecognizer()
                              ..onTap = () async {
                                var link = chunk['texto'].trim();
                                if (await canLaunch(link)) {
                                  await launch(
                                    link,
                                    forceSafariVC: false,
                                    forceWebView: false,
                                  );
                                } else {
                                  throw 'Could not launch $link';
                                }
                              })),
                  )
                  .toList(),
            ),
          ),
        ],
      );

  @override
  Widget build(BuildContext context) {
    return _buildTexto(
      context,
      texto,
    );
  }
}
