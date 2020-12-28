import 'package:arrancando/config/models/chat/grupo.dart';
import 'package:arrancando/config/models/chat/mensaje.dart';
import 'package:arrancando/config/models/usuario.dart';
import 'package:arrancando/config/state/user.dart';
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
      'https://bucketeer-f8bf5f7d-38a0-4187-a7fb-12c4b034c091.s3.amazonaws.com/t45a5eoszk3ethudklagddnkwo1n?response-content-disposition=inline%3B%20filename%3D%22filename.jpg%22%3B%20filename%2A%3DUTF-8%27%27filename.jpg&response-content-type=image%2Fjpeg&X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAX7CRDYXP5ZB73NFB%2F20201228%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Date=20201228T155853Z&X-Amz-Expires=300&X-Amz-SignedHeaders=host&X-Amz-Signature=5abf41fd2aba455bf26eea8c17f4abfe7475f94d8ef6e9273c4324d5559aecc9',
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

  void _scrollToBottom() {
    if (_scrollOnNew) {
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

  @override
  void initState() {
    super.initState();
    _fetchMensajes();
    _initScrollController();
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
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          child: ListView.builder(
                            controller: _scrollController,
                            itemCount: _mensajes.length,
                            itemBuilder: (context, index) {
                              final isMine = index % 3 == 0;

                              return Container(
                                width: MediaQuery.of(context).size.width,
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 15),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: isMine
                                        ? MainAxisAlignment.end
                                        : MainAxisAlignment.start,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(5),
                                        width:
                                            MediaQuery.of(context).size.width *
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
                                            bottomRight: isMine
                                                ? Radius.zero
                                                : Radius.circular(10),
                                            bottomLeft: isMine
                                                ? Radius.circular(10)
                                                : Radius.zero,
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
                                                color:
                                                    Colors.white.withAlpha(185),
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
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
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
                                onChanged: (val) {
                                  if (mounted) setState(() {});
                                },
                              ),
                            ),
                            Material(
                              color: Colors.transparent,
                              child: IconButton(
                                icon: Icon(Icons.send),
                                onPressed: _mensajeController.text.isEmpty
                                    ? null
                                    : () {
                                        _mensajes.add(
                                          MensajeChat(
                                            1,
                                            widget.grupo.id,
                                            context
                                                .read<UserState>()
                                                .activeUser
                                                .getUsuario,
                                            DateTime.now(),
                                            DateTime.now(),
                                            _mensajeController.text,
                                          ),
                                        );
                                        _mensajeController.clear();
                                        if (mounted) setState(() {});
                                        _scrollToBottom();
                                      },
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
