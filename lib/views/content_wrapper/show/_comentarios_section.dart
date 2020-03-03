import 'package:arrancando/config/globals/enums.dart';
import 'package:arrancando/config/globals/index.dart';
import 'package:arrancando/config/models/content_wrapper.dart';
import 'package:arrancando/config/services/fetcher.dart';
import 'package:arrancando/config/state/main.dart';
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
        _mensajeController.text.isNotEmpty) {
      try {
        setState(() {
          _sent = true;
        });

        String url = "/comentario_publicaciones.json";

        var body = {
          "comentario_publicacion": {
            "publicacion_id": widget.content.id,
            "mensaje": _mensajeController.text,
          }
        };

        if (widget.content.type == SectionType.recetas) {
          url = "/comentario_recetas.json";
          body = {
            "comentario_receta": {
              "receta_id": widget.content.id,
              "mensaje": _mensajeController.text,
            }
          };
        }

        await Fetcher.post(
          url: url,
          body: body,
        );
        setState(() {});
        await widget.fetchContent();
        _mensajeController.clear();
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
          Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                TextFormField(
                  textCapitalization: TextCapitalization.sentences,
                  keyboardType: TextInputType.multiline,
                  minLines: 3,
                  maxLines: 3,
                  decoration: InputDecoration(
                    alignLabelWithHint: true,
                    labelText: "Mensaje",
                    hasFloatingPlaceholder: false,
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
            height: 20,
          ),
          Container(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height / 3,
            ),
            child: widget.content.comentarios != null &&
                    widget.content.comentarios.length > 0
                ? Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black12,
                        width: 2,
                      ),
                    ),
                    child: ListView(
                      children: [...widget.content.comentarios]
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
                          .toList(),
                    ),
                  )
                : Text(
                    "Aún no hay comentarios",
                    textAlign: TextAlign.center,
                  ),
          ),
        ],
      ),
    );
  }
}
