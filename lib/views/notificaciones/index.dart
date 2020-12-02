import 'dart:convert';

import 'package:arrancando/config/models/notificacion.dart';
import 'package:arrancando/config/services/dynamic_links.dart';
import 'package:arrancando/config/services/fetcher.dart';
import 'package:arrancando/config/state/main.dart';
import 'package:arrancando/views/notificaciones/_notification_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NotificacionesPage extends StatefulWidget {
  @override
  _NotificacionesPageState createState() => _NotificacionesPageState();
}

class _NotificacionesPageState extends State<NotificacionesPage> {
  final _scrollController = ScrollController();
  List<Notificacion> _notificaciones;
  bool _fetching = true;
  bool _noMore = false;
  int _page = 1;

  Future<void> _fetchNotificaciones({bool reset = false}) async {
    if (reset) {
      _noMore = false;
      _page = 1;
      _notificaciones = [];
    }

    print(_page);

    try {
      final resp = await Fetcher.get(
        url: '/notificaciones.json?page=$_page',
      );

      if (resp != null && resp.body != null) {
        final previousNotificationsLength = _notificaciones.length;

        _notificaciones += (json.decode(resp.body) as List)
            .map(
              (n) => Notificacion.fromJson(n),
            )
            .toList();

        context.read<MainState>().setUnreadNotifications(
              _notificaciones.where((element) => !element.leido).length,
            );

        _page++;

        if (_notificaciones.length <= previousNotificationsLength) {
          _noMore = true;
        }
      }
    } catch (e) {
      print(e);
    }

    _fetching = false;
    if (mounted) setState(() {});
  }

  Future<void> _markAllAsRead() async {
    await Notificacion.markAllRead();
    await _fetchNotificaciones(reset: true);
    context.read<MainState>().setUnreadNotifications(0);
    if (mounted) setState(() {});
  }

  Future<void> _goToNotificationRef(Notificacion n) async {
    try {
      if (!n.leido) {
        await n.markAsRead();
        context.read<MainState>().setUnreadNotifications(
              context.read<MainState>().unreadNotifications - 1,
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
      _fetchNotificaciones(reset: true);
      _scrollController.addListener(
        () {
          if (_scrollController.offset >=
                  _scrollController.position.maxScrollExtent &&
              !_scrollController.position.outOfRange &&
              !_noMore) {
            _fetchNotificaciones();
          }
        },
      );
    });
  }

  @override
  void dispose() {
    _scrollController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notificaciones'),
      ),
      body: RefreshIndicator(
        onRefresh: () => _fetchNotificaciones(reset: true),
        child: SingleChildScrollView(
          controller: _scrollController,
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
                                  for (var notificacion in _notificaciones)
                                    Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        NotificationTile(
                                          notificacion: notificacion,
                                          goToNotification:
                                              _goToNotificationRef,
                                        ),
                                        if (_notificaciones
                                                    .indexOf(notificacion) ==
                                                _notificaciones.length - 1 &&
                                            !_noMore)
                                          Container(
                                            child: Padding(
                                              padding: const EdgeInsets.all(15),
                                              child: SizedBox(
                                                width: 30,
                                                height: 30,
                                                child:
                                                    CircularProgressIndicator(),
                                              ),
                                            ),
                                          )
                                      ],
                                    ),
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
