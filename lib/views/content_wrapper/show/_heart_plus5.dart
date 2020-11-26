import 'package:arrancando/config/globals/enums.dart';
import 'package:arrancando/config/globals/index.dart';
import 'package:arrancando/config/models/content_wrapper.dart';
import 'package:arrancando/config/services/fetcher.dart';
import 'package:arrancando/config/state/user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HeartPlus5 extends StatelessWidget {
  final ContentWrapper content;
  final Function fetchContent;

  HeartPlus5({
    @required this.content,
    this.fetchContent,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<UserState>(
      builder: (context, userState, child) {
        var isFilled = false;
        if (userState.activeUser != null) {
          if (userState.activeUser.id == content.user.id) {
            isFilled = content.puntajes.any((element) => element.puntaje == 5);
          } else {
            isFilled = userState.activeUser != null &&
                (userState.myPuntuaciones['${content.type}-${content.id}'] ??
                        content.myPuntaje(userState.activeUser.id)) ==
                    5;
          }
        }

        var color = Theme.of(context).accentColor;
        if (content.color != null &&
            MyGlobals.LIKES_COLOR[content.color] != null) {
          color = MyGlobals.LIKES_COLOR[content.color];
        }

        return GestureDetector(
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: Icon(
              isFilled ? Icons.favorite : Icons.favorite_border,
              color: color,
            ),
          ),
          onTap: () async {
            if (userState.activeUser.id != content.user.id) {
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

              final key = '${content.type}-${content.id}';

              final newPuntaje = isFilled ? 0 : 5;

              userState.setMyPuntuacion(key, newPuntaje);

              await Fetcher.put(
                url: '$_url/${content.id}/puntuar.json',
                body: {
                  'puntaje': newPuntaje,
                },
              );
              if (fetchContent != null) fetchContent();
            }
          },
        );
      },
    );
  }
}
