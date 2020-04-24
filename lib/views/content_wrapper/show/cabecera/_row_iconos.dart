import 'package:arrancando/config/fonts/arrancando_icons_icons.dart';
import 'package:arrancando/config/globals/enums.dart';
import 'package:arrancando/config/globals/global_singleton.dart';
import 'package:arrancando/config/models/content_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:icon_shadow/icon_shadow.dart';

class RowIconos extends StatelessWidget {
  final GlobalSingleton gs = GlobalSingleton();
  final ContentWrapper content;

  RowIconos({
    @required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.85,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                IconShadowWidget(
                  Icon(
                    Icons.timer,
                    color: Theme.of(context).accentColor,
                  ),
                ),
                Text(
                  content.duracion != null
                      ? "${content.duracion} minutos"
                      : "Desconocida",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 9,
                    shadows: [
                      Shadow(
                        color: Theme.of(context).textTheme.body1.color,
                        blurRadius: 5,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                IconShadowWidget(
                  Icon(
                    ArrancandoIcons.horno,
                    color: Theme.of(context).accentColor,
                  ),
                ),
                Text(
                  gs.categories[SectionType.recetas]
                          .firstWhere(
                            (c) => c.id == content.categoriaRecetaId,
                            orElse: () => null,
                          )
                          ?.nombre ??
                      'Desconocida',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 9,
                    shadows: [
                      Shadow(
                        color: Theme.of(context).textTheme.body1.color,
                        blurRadius: 5,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                IconShadowWidget(
                  Icon(
                    ArrancandoIcons.dificultad,
                    color: Theme.of(context).accentColor,
                  ),
                ),
                Text(
                  content.complejidad ?? "Desconocida",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 9,
                    shadows: [
                      Shadow(
                        color: Theme.of(context).textTheme.body1.color,
                        blurRadius: 5,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
