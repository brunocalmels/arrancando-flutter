import 'package:arrancando/config/globals/enums.dart';
import 'package:arrancando/config/models/content_wrapper.dart';
import 'package:arrancando/config/services/fetcher.dart';
import 'package:arrancando/views/content_wrapper/show/comentarios/_comments_list.dart';
import 'package:arrancando/views/content_wrapper/show/comentarios/_from_send_comment.dart';
import 'package:flutter/material.dart';

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
  bool _sent = false;
  int _editCommentId;

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

        if (_editCommentId != null) {
          await Fetcher.put(
            url: "${url.split('.').first}/$_editCommentId.json",
            body: body,
          );
        } else {
          await Fetcher.post(
            url: url,
            body: body,
          );
        }
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

  _setEditCommentId(int id, String text) {
    _editCommentId = id;
    _mensajeController.text = text;
    if (mounted) setState(() {});
  }

  _setDeleteCommentId(int id) async {
    try {
      setState(() {
        _sent = true;
      });

      String url = "/comentario_publicaciones/$id.json";

      url = "/comentario_recetas/$id.json";

      await Fetcher.destroy(
        url: url,
      );

      setState(() {});

      await widget.fetchContent();
    } catch (e) {
      print(e);
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
          CommentsList(
            content: widget.content,
            setEditCommentId: _setEditCommentId,
            setDeleteCommentId: _setDeleteCommentId,
          ),
          SizedBox(
            height: 20,
          ),
          FormSendComment(
            mensajeController: _mensajeController,
            sent: _sent,
            sendComentario: _sendComentario,
          ),
        ],
      ),
    );
  }
}
