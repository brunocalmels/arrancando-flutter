import 'package:arrancando/config/models/chat/grupo.dart';
import 'package:arrancando/config/models/chat/mensaje.dart';
import 'package:arrancando/config/models/usuario.dart';
import 'package:arrancando/config/state/user.dart';
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

  void _scrollToBottom({bool force = false}) {
    if (_scrollOnNew || force) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        curve: Curves.easeIn,
        duration: Duration(milliseconds: 100),
      );
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
    _scrollToBottom();
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
                      Expanded(
                        child: Stack(
                          fit: StackFit.passthrough,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width,
                              child: ListView.builder(
                                controller: _scrollController,
                                itemCount: _mensajes.length,
                                itemBuilder: (context, index) {
                                  final isMine = index % 3 == 0;

                                  final avatar = Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 3),
                                    child: CircleAvatar(
                                      radius: 13,
                                      backgroundImage:
                                          _mensajes[index]?.usuario?.avatar !=
                                                  null
                                              ? CachedNetworkImageProvider(
                                                  '${_mensajes[index]?.usuario?.avatar}',
                                                )
                                              : null,
                                    ),
                                  );

                                  return Container(
                                    width: MediaQuery.of(context).size.width,
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 15),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment: isMine
                                            ? MainAxisAlignment.end
                                            : MainAxisAlignment.start,
                                        children: [
                                          if (!isMine) avatar,
                                          Container(
                                            padding: const EdgeInsets.all(5),
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.7,
                                            decoration: BoxDecoration(
                                              color: widget.grupo.toColor,
                                              borderRadius: BorderRadius.only(
                                                topRight: isMine
                                                    ? Radius.zero
                                                    : Radius.circular(10),
                                                topLeft: isMine
                                                    ? Radius.circular(10)
                                                    : Radius.zero,
                                                bottomRight:
                                                    Radius.circular(10),
                                                bottomLeft: Radius.circular(10),
                                              ),
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Text(
                                                  '@${_mensajes[index].usuario.username}',
                                                  style: TextStyle(
                                                    fontSize: 11,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white
                                                        .withAlpha(185),
                                                  ),
                                                ),
                                                SizedBox(height: 5),
                                                Text(
                                                  _mensajes[index].mensaje,
                                                  style: TextStyle(
                                                    fontSize: 13,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          if (isMine) avatar,
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            Positioned(
                              bottom: 10,
                              right: 10,
                              child: AnimatedOpacity(
                                duration: Duration(milliseconds: 400),
                                curve: Curves.easeInOutBack,
                                opacity: !_scrollOnNew && !_sending ? 1 : 0,
                                child: Material(
                                  color:
                                      Theme.of(context).scaffoldBackgroundColor,
                                  elevation: 6,
                                  type: MaterialType.circle,
                                  child: InkWell(
                                    child: Padding(
                                      padding: const EdgeInsets.all(3),
                                      child: Icon(Icons.arrow_downward),
                                    ),
                                    onTap: () => !_scrollOnNew && !_sending
                                        ? _scrollToBottom(force: true)
                                        : null,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(10),
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.1,
                        decoration: BoxDecoration(
                          color: Theme.of(context).scaffoldBackgroundColor,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black,
                              blurRadius: 3,
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _mensajeController,
                                decoration: InputDecoration(
                                  hintText: 'Mensaje',
                                  alignLabelWithHint: true,
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.never,
                                ),
                                onSubmitted: (val) => val.isEmpty || _sending
                                    ? null
                                    : _enviarMensaje(),
                                onChanged: (val) {
                                  if (mounted) setState(() {});
                                },
                              ),
                            ),
                            Material(
                              color: Colors.transparent,
                              child: _sending
                                  ? SizedBox(
                                      width: 48,
                                      height: 48,
                                      child: Center(
                                        child: SizedBox(
                                          width: 15,
                                          height: 15,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 1,
                                          ),
                                        ),
                                      ),
                                    )
                                  : IconButton(
                                      icon: Icon(Icons.send),
                                      onPressed:
                                          _mensajeController.text.isEmpty ||
                                                  _sending
                                              ? null
                                              : _enviarMensaje,
                                    ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
      ),
    );
  }
}
