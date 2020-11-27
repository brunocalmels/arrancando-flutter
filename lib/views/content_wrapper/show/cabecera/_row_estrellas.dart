import 'package:arrancando/config/globals/enums.dart';
import 'package:arrancando/config/globals/index.dart';
import 'package:arrancando/config/models/content_wrapper.dart';
import 'package:arrancando/config/models/puntaje.dart';
import 'package:arrancando/config/services/fetcher.dart';
import 'package:arrancando/config/state/user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RowEstrellas extends StatelessWidget {
  final ContentWrapper content;
  final Function fetchContent;

  RowEstrellas({
    @required this.content,
    @required this.fetchContent,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<UserState>(
      builder: (context, state, child) {
        var color = Theme.of(context).accentColor;
        if (content.color != null &&
            MyGlobals.LIKES_COLOR[content.color] != null) {
          color = MyGlobals.LIKES_COLOR[content.color];
        }

        return Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [1, 2, 3, 4, 5]
              .map(
                (p) => IconButton(
                  icon: Icon(
                    content.puntajePromedio >= p
                        ? Icons.star
                        : content.puntajePromedio > p - 1
                            ? Icons.star_half
                            : Icons.star_border,
                  ),
                  color: color,
                  disabledColor: color,
                  onPressed: state.activeUser != null &&
                          content.user != null &&
                          state.activeUser.id != content.user.id
                      ? () async {
                          var usuario = state.activeUser.getUsuario;

                          var myPuntaje = Puntaje(usuario, p);
                          content.addMyPuntaje(myPuntaje);

                          String _url;

                          switch (content.type) {
                            case SectionType.publicaciones:
                              _url = '/publicaciones';
                              break;
                            case SectionType.recetas:
                              _url = '/recetas';
                              break;
                            case SectionType.pois:
                              _url = '/pois';
                              break;
                            default:
                              _url = '/publicaciones';
                          }

                          state.setMyPuntuacion(
                            '${content.type}-${content.id}',
                            p,
                          );

                          await Fetcher.put(
                            url: '$_url/${content.id}/puntuar.json',
                            body: {
                              'puntaje': p,
                            },
                          );
                          fetchContent();
                        }
                      : null,
                ),
              )
              .toList(),
        );
      },
    );
  }
}
