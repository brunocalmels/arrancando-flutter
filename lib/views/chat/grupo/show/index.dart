import 'package:arrancando/config/globals/index.dart';
import 'package:arrancando/config/models/chat/grupo.dart';
import 'package:arrancando/config/models/chat/mensaje.dart';
import 'package:arrancando/config/models/usuario.dart';
import 'package:arrancando/config/state/user.dart';
import 'package:arrancando/views/chat/grupo/show/mensajes_list/index.dart';
import 'package:arrancando/views/chat/grupo/show/send_mensaje_field/index.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
  final _scrollController = ScrollController();
  List<MensajeChat> _mensajes = [];
  bool _loading = true;
  bool _sending = false;
  bool _scrollOnNew = true;

  Future<void> _fetchMensajes() async {
    _loading = true;
    if (mounted) setState(() {});

    // try {
    //   final response = await Fetcher.get(url: '/grupos/${widget.grupo.id}.json');

    //   if (response != null && response.status == 200) {
    //     _mensajes = (json.decode(response.body) as List)
    //         .map<MensajeChat>((grupo) => MensajeChat.fromJson(grupo))
    //         .toList();
    //   }
    // } catch (e) {
    //   print(e);
    // }

    final usuario = Usuario(
      1,
      'https://www.purina-latam.com/sites/g/files/auxxlc391/files/styles/facebook_share/public/Purina%C2%AE%20La%20llegada%20del%20gatito%20a%20casa.jpg?itok=6QG07anP',
      'Ivan',
      'Eidel',
      'egre2806@gmail.com',
      'DaCook',
      null,
    );

    final mensajes = [
      'Lorem ipsum dolor sit amet, consectetur adipiscing elit',
      'Nam imperdiet nulla et aliquam convallis',
      'Proin elementum enim non magna sollicitudin, id sollicitudin dui tincidunt',
      'Aliquam maximus quam lectus, ut tempor dolor rhoncus eu',
      'Donec quis diam lectus',
      'Proin accumsan ac ipsum et congue',
      'Mauris vitae lorem odio',
      'Lorem ipsum dolor sit amet, consectetur adipiscing elit',
      'Aenean tincidunt eros at purus ultricies aliquet',
      'Curabitur viverra metus venenatis quam ultricies, sit amet efficitur magna elementum',
    ];

    for (var mensaje in mensajes) {
      _mensajes.add(
        MensajeChat(
          1,
          widget.grupo.id,
          usuario,
          DateTime.now(),
          DateTime.now(),
          mensaje,
        ),
      );
    }

    _loading = false;
    if (mounted) setState(() {});
  }

  Future<void> _enviarMensaje() async {
    _sending = true;
    if (mounted) setState(() {});
    _mensajes.add(
      MensajeChat(
        1,
        widget.grupo.id,
        context.read<UserState>().activeUser.getUsuario,
        DateTime.now(),
        DateTime.now(),
        _mensajeController.text,
      ),
    );
    _mensajeController.clear();
    if (mounted) setState(() {});
    await Future.delayed(Duration(milliseconds: 100));
    _scrollToBottom();
    _sending = false;
    if (mounted) setState(() {});
  }

  void _scrollToBottom({bool force = false, bool animate = true}) {
    if (_scrollOnNew || force) {
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
      },
    );
  }

  Future<void> _initScreen() async {
    await _fetchMensajes();
    _initScrollController();
    _scrollToBottom(animate: false);
  }

  @override
  void initState() {
    super.initState();
    _initScreen();
  }

  @override
  void dispose() {
    _mensajeController?.dispose();
    _scrollController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
            : _mensajes.isEmpty
                ? Padding(
                    padding: const EdgeInsets.all(15),
                    child: Center(
                      child: Text(
                        'No hay mensajes aún',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                : Column(
                    children: [
                      MensajesList(
                        scrollController: _scrollController,
                        mensajes: _mensajes,
                        grupo: widget.grupo,
                        scrollOnNew: _scrollOnNew,
                        sending: _sending,
                        scrollToBottom: _scrollToBottom,
                      ),
                      SendMensajeField(
                        mensajeController: _mensajeController,
                        sending: _sending,
                        enviarMensaje: _enviarMensaje,
                      ),
                    ],
                  ),
      ),
    );
  }
}
