import 'package:arrancando/config/globals/enums.dart';
import 'package:arrancando/config/globals/index.dart';
import 'package:arrancando/config/models/content_wrapper.dart';
import 'package:arrancando/config/services/fetcher.dart';
import 'package:arrancando/config/state/index.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ComentariosSection extends StatefulWidget {
  final ContentWrapper content;
  final Function fetchContent;

  ComentariosSection({
    @required this.content,
    @required this.fetchContent,
  });

  @override
  _ComentariosSectionState createState() => _ComentariosSectionState();
}

class _ComentariosSectionState extends State<ComentariosSection> {
  final TextEditingController _mensajeController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _sent = false;

  _sendComentario() async {
    if (_mensajeController != null &&
        _mensajeController.text != null &&
        _mensajeController.text != "") {
      try {
        setState(() {
          _sent = true;
        });
        await Fetcher.post(
          url: widget.content.type == SectionType.recetas
              ? "/comentario_recetas.json"
              : "/comentario_publicaciones.json",
          body: {
            "receta_id": widget.content.id,
            "publicacion_id": widget.content.id,
            "mensaje": _mensajeController.text,
          },
        );
        _mensajeController.clear();
        setState(() {});
        widget.fetchContent();
      } catch (e) {
        print(e);
      }
    }
    setState(() {
      _sent = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Divider(),
          SizedBox(
            height: 7,
          ),
          Text(
            "Comentarios:",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          if (widget.content.user.id !=
              Provider.of<MyState>(context).activeUser.id)
            Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    keyboardType: TextInputType.multiline,
                    minLines: 7,
                    maxLines: 7,
                    decoration: InputDecoration(
                      alignLabelWithHint: true,
                      labelText: "Mensaje",
                    ),
                    controller: _mensajeController,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      RaisedButton(
                        onPressed: _sent ? null : _sendComentario,
                        child: Text("Comentar"),
                      ),
                    ],
                  )
                ],
              ),
            ),
          SizedBox(
            height: 10,
          ),
          Container(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height / 2,
            ),
            child: ListView(
              children: widget.content.comentarios != null &&
                      widget.content.comentarios.length > 0
                  ? [...widget.content.comentarios]
                      .reversed
                      .map(
                        (c) => ListTile(
                          leading: CircleAvatar(
                            backgroundImage:
                                c.user != null && c.user.avatar != null
                                    ? CachedNetworkImageProvider(
                                        "${MyGlobals.SERVER_URL}${c.user.avatar}",
                                      )
                                    : null,
                          ),
                          title: Text(
                            c.mensaje,
                          ),
                          subtitle: Text(
                            c.fecha,
                            style: TextStyle(fontSize: 10),
                          ),
                        ),
                      )
                      .toList()
                  : [
                      ListTile(
                        title: Text(
                          "Aún no hay comentarios",
                          textAlign: TextAlign.center,
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
