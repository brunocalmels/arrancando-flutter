import 'package:arrancando/config/models/notificacion.dart';
import 'package:flutter/material.dart';

class NotificationTile extends StatelessWidget {
  final Notificacion notificacion;
  final Function(Notificacion) goToNotification;

  const NotificationTile({
    Key key,
    @required this.notificacion,
    @required this.goToNotification,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
            bottom: BorderSide(
          color: Theme.of(context).textTheme.bodyText2.color.withAlpha(50),
          width: 1,
        )),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(10),
        title: Text(
          notificacion.titulo,
          style: TextStyle(
            fontWeight: !notificacion.leido ? FontWeight.bold : null,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            if (notificacion.cuerpo != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 3),
                child: Text(
                  notificacion.cuerpo,
                ),
              ),
            Text(notificacion.fecha),
          ],
        ),
        onTap: notificacion.url != null
            ? () => goToNotification(notificacion)
            : null,
      ),
    );
  }
}
