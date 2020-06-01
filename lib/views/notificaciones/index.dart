import 'dart:convert';

import 'package:arrancando/config/models/notificacion.dart';
import 'package:arrancando/config/services/dynamic_links.dart';
import 'package:arrancando/config/services/fetcher.dart';
import 'package:arrancando/views/content_wrapper/show/index.dart';
import 'package:flutter/material.dart';

class NotificacionesPage extends StatefulWidget {
  @override
  _NotificacionesPageState createState() => _NotificacionesPageState();
}

class _NotificacionesPageState extends State<NotificacionesPage> {
  List<Notificacion> _notificaciones;
  bool _fetching = true;

  _fetchNotificaciones() async {
    _fetching = true;
    try {
      ResponseObject resp = await Fetcher.get(url: "/notificaciones.json");

      if (resp != null && resp.body != null) {
        _notificaciones = (json.decode(resp.body) as List)
            .map(
              (n) => Notificacion.fromJson(n),
            )
            .toList();
      }
    } catch (e) {
      print(e);
    }
    _fetching = false;
    if (mounted) setState(() {});
  }

  _markAllAsRead() async {
    await Future.wait(
      _notificaciones.where((n) => !n.leido).map(
            (n) => n.markAsRead(),
          ),
    );
    if (mounted) setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _fetchNotificaciones();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Notificaciones"),
      ),
      body: RefreshIndicator(
        onRefresh: () => _fetchNotificaciones(),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: !_fetching
                ? _notificaciones != null
                    ? _notificaciones.length > 0
                        ? [
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: <Widget>[
                                      FlatButton(
                                        onPressed: _markAllAsRead,
                                        child: Text(
                                          "MARCAR TODAS LEIDAS",
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Theme.of(context)
                                                .textTheme
                                                .body1
                                                .color,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  ..._notificaciones
                                      .map(
                                        (n) => Container(
                                          decoration: BoxDecoration(
                                            border: Border(
                                                bottom: BorderSide(
                                              color: Theme.of(context)
                                                  .textTheme
                                                  .body1
                                                  .color
                                                  .withAlpha(50),
                                              width: 1,
                                            )),
                                          ),
                                          child: ListTile(
                                            contentPadding:
                                                const EdgeInsets.all(10),
                                            title: Text(
                                              n.titulo,
                                              style: TextStyle(
                                                fontWeight: !n.leido
                                                    ? FontWeight.bold
                                                    : null,
                                              ),
                                            ),
                                            subtitle: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              mainAxisSize: MainAxisSize.min,
                                              children: <Widget>[
                                                if (n.cuerpo != null)
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            bottom: 3),
                                                    child: Text(
                                                      n.cuerpo,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      maxLines: 1,
                                                    ),
                                                  ),
                                                Text(n.fecha),
                                              ],
                                            ),
                                            onTap: n.url != null
                                                ? () {
                                                    try {
                                                      n.markAsRead();
                                                      DynamicLinks.parseURI(
                                                        Uri.tryParse(n.url),
                                                        context,
                                                      );
                                                    } catch (e) {
                                                      print(e);
                                                    }
                                                  }
                                                : null,
                                          ),
                                        ),
                                      )
                                      .toList(),
                                ],
                              ),
                            ),
                          ]
                        : [
                            Container(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height,
                              child: Center(
                                child: Text("No hay notificaciónes"),
                              ),
                            ),
                          ]
                    : [
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height,
                          child: Center(
                            child: Text("Ocurrió un error"),
                          ),
                        ),
                      ]
                : [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      child: Center(
                        child: SizedBox(
                          height: 25,
                          width: 25,
                          child: CircularProgressIndicator(),
                        ),
                      ),
                    ),
                  ],
          ),
        ),
      ),
    );
  }
}
