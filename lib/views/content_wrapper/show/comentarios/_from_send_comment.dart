import 'package:arrancando/config/globals/enums.dart';
import 'package:arrancando/config/globals/index.dart';
import 'package:arrancando/config/models/content_wrapper.dart';
import 'package:arrancando/config/services/fetcher.dart';
import 'package:arrancando/config/state/user.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FormSendComment extends StatefulWidget {
  final ContentWrapper content;
  final Function fetchContent;

  FormSendComment({
    @required this.content,
    @required this.fetchContent,
  });

  @override
  _FormSendCommentState createState() => _FormSendCommentState();
}

class _FormSendCommentState extends State<FormSendComment> {
  final TextEditingController _mensajeController = TextEditingController();
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
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Color(0xff161a25),
        borderRadius: BorderRadius.circular(100),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          CircleAvatar(
            radius: 25,
            backgroundImage:
                Provider.of<UserState>(context, listen: false).activeUser !=
                            null &&
                        Provider.of<UserState>(context, listen: false)
                                .activeUser
                                .avatar !=
                            null
                    ? CachedNetworkImageProvider(
                        "${MyGlobals.SERVER_URL}${Provider.of<UserState>(context, listen: false).activeUser.avatar}",
                      )
                    : null,
          ),
          SizedBox(
            width: 7,
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      textCapitalization: TextCapitalization.sentences,
                      keyboardType: TextInputType.multiline,
                      minLines: 1,
                      maxLines: 2,
                      decoration: InputDecoration(
                        alignLabelWithHint: true,
                        hintText: "Comentario",
                        hasFloatingPlaceholder: false,
                        hintStyle: TextStyle(
                          color: Colors.black54,
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.all(10),
                      ),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.black,
                      ),
                      controller: _mensajeController,
                    ),
                  ),
                  FlatButton(
                    onPressed: _sent ? null : _sendComentario,
                    child: Text(
                      "COMENTAR",
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
