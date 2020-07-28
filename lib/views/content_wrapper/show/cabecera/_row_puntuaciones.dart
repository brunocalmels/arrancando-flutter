import 'package:arrancando/config/models/content_wrapper.dart';
import 'package:arrancando/config/state/user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RowPuntuaciones extends StatelessWidget {
  final ContentWrapper content;

  RowPuntuaciones({
    @required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<UserState>(
      builder: (context, userState, child) {
        var tuVoto = userState.activeUser != null &&
                userState.activeUser.id != content.user.id &&
                (userState.myPuntuaciones["${content.type}-${content.id}"] ??
                        content.myPuntaje(userState.activeUser.id)) >
                    0
            ? userState.myPuntuaciones["${content.type}-${content.id}"] ??
                content.myPuntaje(userState.activeUser.id)
            : 0;

        return Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              "${content.puntajePromedio.toStringAsFixed(1)}",
            ),
            SizedBox(
              width: 5,
            ),
            Text(
              "${content.puntajes != null ? content.puntajes.length : ''}",
            ),
            Icon(
              Icons.person,
              size: 20,
              color: Theme.of(context).accentColor,
            ),
            if (tuVoto > 0)
              Padding(
                padding: const EdgeInsets.only(left: 5),
                child: Text(
                  "(tu voto: $tuVoto)",
                  style: TextStyle(
                    fontSize: 12,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
