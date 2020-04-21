import 'package:arrancando/config/globals/enums.dart';
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
    return GestureDetector(
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: Icon(
          (Provider.of<UserState>(context)
                          .myPuntuaciones["${content.type}-${content.id}"] ??
                      content.myPuntaje(
                          Provider.of<UserState>(context).activeUser.id)) >
                  0
              ? Icons.favorite
              : Icons.favorite_border,
          color: Theme.of(context).accentColor,
        ),
      ),
      onTap: () async {
        UserState userState = Provider.of<UserState>(context);

        String _url;

        switch (content.type) {
          case SectionType.publicaciones:
            _url = "/publicaciones";
            break;
          case SectionType.recetas:
            _url = "/recetas";
            break;
          case SectionType.pois:
            _url = "/pois";
            break;
          default:
            _url = "/publicaciones";
        }

        String key = "${content.type}-${content.id}";

        int newPuntaje = (userState.myPuntuaciones[key] ??
                    content.myPuntaje(userState.activeUser.id)) >
                0
            ? 0
            : 5;

        userState.setMyPuntuacion(key, newPuntaje);

        await Fetcher.put(
          url: "$_url/${content.id}/puntuar.json",
          body: {
            "puntaje": newPuntaje,
          },
        );
        if (fetchContent != null) fetchContent();
      },
    );
  }
}
