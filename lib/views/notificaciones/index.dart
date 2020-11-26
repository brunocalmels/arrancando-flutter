import 'dart:convert';

import 'package:arrancando/config/models/notificacion.dart';
import 'package:arrancando/config/services/dynamic_links.dart';
import 'package:arrancando/config/services/fetcher.dart';
import 'package:arrancando/config/state/main.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NotificacionesPage extends StatefulWidget {
  @override
  _NotificacionesPageState createState() => _NotificacionesPageState();
}

class _NotificacionesPageState extends State<NotificacionesPage> {
  List<Notificacion> _notificaciones;
  bool _fetching = true;

  Future<void> _fetchNotificaciones() async {
    _fetching = true;
    try {
      final resp = await Fetcher.get(url: '/notificaciones.json');

      if (resp != null && resp.body != null) {
        _notificaciones = (json.decode(resp.body) as List)
            .map(
              (n) => Notificacion.fromJson(n),
            )
            .toList();

        Provider.of<MainState>(
          context,
          listen: false,
        ).setUnreadNotifications(
          _notificaciones.where((element) => !element.leido).length,
        );
      }
    } catch (e) {
      print(e);
    }
    _fetching = false;
    if (mounted) setState(() {});
  }

  Future<void> _markAllAsRead() async {
    await Future.wait(
      _notificaciones.where((n) => !n.leido).map(
            (n) => n.markAsRead(),
          ),
    );
    Provider.of<MainState>(
      context,
      listen: false,
    ).setUnreadNotifications(0);
    if (mounted) setState(() {});
  }

  Future<void> _goToNotificationRef(Notificacion n) async {
    try {
      if (!n.leido) {
        await n.markAsRead();
        Provider.of<MainState>(
          context,
          listen: false,
        ).setUnreadNotifications(
          Provider.of<MainState>(
                context,
                listen: false,
              ).unreadNotifications -
              1,
        );
        if (mounted) setState(() {});
      }
      await DynamicLinks.parseURI(
        Uri.tryParse(n.url),
        context,
      );
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchNotificaciones();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notificaciones'),
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
                    ? _notificaciones.isNotEmpty
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
                                          'MARCAR TODAS LEIDAS',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Theme.of(context)
                                                .textTheme
                                                .bodyText2
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
                                                  .bodyText2
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
                                                ? () => _goToNotificationRef(n)
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
                                child: Text('No hay notificaciónes'),
                              ),
                            ),
                          ]
                    : [
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height,
                          child: Center(
                            child: Text('Ocurrió un error'),
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
