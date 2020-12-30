import 'dart:convert';

import 'package:arrancando/config/globals/index.dart';
import 'package:arrancando/config/models/active_user.dart';
import 'package:arrancando/config/models/chat/grupo.dart';
import 'package:arrancando/config/models/chat/mensaje.dart';
import 'package:arrancando/config/services/fetcher.dart';
import 'package:arrancando/config/state/user.dart';
import 'package:arrancando/views/chat/grupo/show/mensajes_list/index.dart';
import 'package:arrancando/views/chat/grupo/show/send_mensaje_field/index.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:web_socket_channel/io.dart';

class GrupoChatShowPage extends StatefulWidget {
  final GrupoChat grupo;

  const GrupoChatShowPage({
    Key key,
    @required this.grupo,
  }) : super(key: key);

  @override
  _GrupoChatShowPageState createState() => _GrupoChatShowPageState();
}

class _GrupoChatShowPageState extends State<GrupoChatShowPage> {
  final _mensajeController = TextEditingController();
  final _mensajeFocusNode = FocusNode();
  final _scrollController = ScrollController();
  ActiveUser _activeUser;
  int _page = 1;
  List<MensajeChat> _mensajes = [];
  bool _loading = true;
  bool _sending = false;
  bool _scrollOnNew = true;
  bool _noMore = false;
  IOWebSocketChannel _channel;

  Future<void> _fetchMensajes() async {
    double oldOffsetFromBottom;
    double newOffsetFromBottom;
    try {
      final response = await Fetcher.get(
        url: '/grupo_chats/${widget.grupo.id}.json?page=$_page',
      );

      if (response != null && response.status == 200) {
        final previousLength = _mensajes.length;

        if (_scrollController.hasClients) {
          oldOffsetFromBottom = _scrollController.position.maxScrollExtent;
        }

        _mensajes = [
          ...(json.decode(response.body)['mensajes'] as List)
              .map<MensajeChat>((grupo) => MensajeChat.fromJson(grupo))
              .toList()
              .reversed
              .toList(),
          ..._mensajes,
        ];

        _page++;

        if (previousLength == _mensajes.length) {
          _noMore = true;
        }
      }
    } catch (e) {
      print(e);
    }

    _loading = false;
    if (mounted) setState(() {});

    await Future.delayed(Duration(milliseconds: 50));

    if (_scrollController.hasClients) {
      newOffsetFromBottom = _scrollController.position.maxScrollExtent;
    }

    if (oldOffsetFromBottom != null && newOffsetFromBottom != null) {
      await _scrollController.animateTo(
        newOffsetFromBottom - oldOffsetFromBottom,
        curve: Curves.easeIn,
        duration: Duration(milliseconds: 500),
      );
    }
  }

  void _subscribeToGrupoChat() {
    _channel = IOWebSocketChannel.connect(MyGlobals.WEB_SOCKET_URL);

    final token = _activeUser.authToken;

    final message = json.encode({
      'command': 'subscribe',
      'identifier': json.encode({
        'channel': 'GrupoChatChannel',
        'token': 'Bearer $token',
        'grupo_chat_id': '${widget.grupo.id}',
      }),
    });

    _channel.sink.add(message);

    _channel.stream.listen((event) {
      if (event != null) {
        try {
          final data = json.decode(event) as Map<String, dynamic>;
          if (data['type'] == null || data['type'] == 'Mensaje grupal') {
            _mensajes.add(MensajeChat.fromJson(data['message']));
            if (mounted) setState(() {});
          }
          _scrollToBottom();
        } catch (e) {
          // Ignore
        }
      }
    });
  }

  void _unsubscribeToGrupoChat() {
    if (_channel != null) {
      final token = _activeUser.authToken;

      final message = json.encode({
        'command': 'unsubscribe',
        'identifier': json.encode({
          'channel': 'GrupoChatChannel',
          'token': 'Bearer $token',
          'grupo_chat_id': '${widget.grupo.id}',
        }),
      });

      _channel.sink.add(message);

      _channel.sink.close();

      _channel = null;
    }
  }

  Future<void> _enviarMensaje() async {
    if (_channel != null) {
      _sending = true;
      if (mounted) setState(() {});

      final token = _activeUser.authToken;

      final message = json.encode({
        'command': 'message',
        'data': json.encode({
          'mensaje': _mensajeController.text,
        }),
        'identifier': json.encode({
          'channel': 'GrupoChatChannel',
          'token': 'Bearer $token',
          'grupo_chat_id': '${widget.grupo.id}',
        }),
      });

      _channel.sink.add(message);

      _mensajeController.clear();
      FocusScope.of(context).requestFocus(_mensajeFocusNode);
      _sending = false;
      if (mounted) setState(() {});
    }
  }

  void _scrollToBottom({bool force = false, bool animate = true}) {
    if (_scrollController.hasClients && (_scrollOnNew || force)) {
      if (animate) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          curve: Curves.easeIn,
          duration: Duration(milliseconds: 100),
        );
      } else {
        _scrollController.jumpTo(
          _scrollController.position.maxScrollExtent,
        );
      }
    }
  }

  void _initScrollController() {
    _scrollController.addListener(
      () {
        if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent) {
          _scrollOnNew = true;
        } else {
          _scrollOnNew = false;
        }
        if (mounted) setState(() {});

        if (_scrollController.offset == 0 && _mensajes.isNotEmpty && !_noMore) {
          _fetchMensajes();
        }
      },
    );
  }

  Future<void> _initScreen() async {
    _initScrollController();
    await _fetchMensajes();
    _subscribeToGrupoChat();
    _scrollToBottom(animate: false);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _activeUser = context.read<UserState>().activeUser;
      if (mounted) setState(() {});
      _initScreen();
    });
  }

  @override
  void dispose() {
    _mensajeController?.dispose();
    _scrollController?.dispose();
    _unsubscribeToGrupoChat();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: widget.grupo.toColor,
        title: Text('${widget.grupo.nombre}'),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: _loading
            ? Padding(
                padding: const EdgeInsets.all(15),
                child: Center(
                  child: SizedBox(
                    width: 25,
                    height: 25,
                    child: CircularProgressIndicator(
                      strokeWidth: 1,
                    ),
                  ),
                ),
              )
            : Column(
                children: [
                  if (_mensajes.isEmpty)
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: Center(
                          child: Text(
                            'No hay mensajes aún',
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  if (_mensajes.isNotEmpty)
                    MensajesList(
                      scrollController: _scrollController,
                      mensajes: _mensajes,
                      grupo: widget.grupo,
                      scrollOnNew: _scrollOnNew,
                      sending: _sending,
                      scrollToBottom: _scrollToBottom,
                      activeUser: _activeUser,
                    ),
                  SendMensajeField(
                    mensajeController: _mensajeController,
                    mensajeFocusNode: _mensajeFocusNode,
                    sending: _sending,
                    enviarMensaje: _enviarMensaje,
                  ),
                ],
              ),
      ),
    );
  }
}
