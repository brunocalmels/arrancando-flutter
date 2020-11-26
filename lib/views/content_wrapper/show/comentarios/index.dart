import 'package:arrancando/config/globals/enums.dart';
import 'package:arrancando/config/models/comentario.dart';
import 'package:arrancando/config/models/content_wrapper.dart';
import 'package:arrancando/config/models/puntaje.dart';
import 'package:arrancando/config/services/fetcher.dart';
import 'package:arrancando/config/services/utils.dart';
import 'package:arrancando/config/state/user.dart';
import 'package:arrancando/views/content_wrapper/show/comentarios/_comments_list.dart';
import 'package:arrancando/views/content_wrapper/show/comentarios/_from_send_comment.dart';
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
  bool _sent = false;
  int _editCommentId;

  Future<void> _sendComentario() async {
    if (_mensajeController != null &&
        _mensajeController.text != null &&
        _mensajeController.text.isNotEmpty) {
      try {
        Utils.unfocus(context);

        _sent = true;
        if (mounted) setState(() {});

        String url;
        var body;

        switch (widget.content.type) {
          case SectionType.publicaciones:
            url = '/comentario_publicaciones.json';
            body = {
              'comentario_publicacion': {
                'publicacion_id': widget.content.id,
                'mensaje': _mensajeController.text,
              }
            };
            break;
          case SectionType.recetas:
            url = '/comentario_recetas.json';
            body = {
              'comentario_receta': {
                'receta_id': widget.content.id,
                'mensaje': _mensajeController.text,
              }
            };
            break;
          case SectionType.pois:
            url = '/comentario_pois.json';
            body = {
              'comentario_poi': {
                'poi_id': widget.content.id,
                'mensaje': _mensajeController.text,
              }
            };
            break;
          default:
            url = '/comentario_publicaciones.json';
            body = {
              'comentario_publicacion': {
                'publicacion_id': widget.content.id,
                'mensaje': _mensajeController.text,
              }
            };
        }

        if (_editCommentId != null) {
          await Fetcher.put(
            url: '${url.split('.').first}/$_editCommentId.json',
            body: body,
          );
        } else {
          await Fetcher.post(
            url: url,
            body: body,
          );
        }
        if (mounted) setState(() {});
        await widget.fetchContent();
        _mensajeController.clear();
      } catch (e) {
        print(e);
      }
    }
    _sent = false;
    if (mounted) setState(() {});
  }

  void _setEditCommentId(int id, String text) {
    _editCommentId = id;
    _mensajeController.text = text;
    if (mounted) setState(() {});
  }

  Future<void> _setDeleteCommentId(int id) async {
    try {
      _sent = true;
      if (mounted) setState(() {});

      String url;

      switch (widget.content.type) {
        case SectionType.publicaciones:
          url = '/comentario_publicaciones/$id.json';
          break;
        case SectionType.recetas:
          url = '/comentario_recetas/$id.json';
          break;
        case SectionType.pois:
          url = '/comentario_pois/$id.json';
          break;
        default:
          url = '/comentario_publicaciones/$id.json';
      }

      await Fetcher.destroy(
        url: url,
      );

      if (mounted) setState(() {});

      await widget.fetchContent();
    } catch (e) {
      print(e);
    }

    _sent = false;
    if (mounted) setState(() {});
  }

  Future<void> _toggleLikeComment(Comentario comentario) async {
    try {
      _sent = true;
      if (mounted) setState(() {});

      String url;

      switch (widget.content.type) {
        case SectionType.publicaciones:
          url = '/comentario_publicaciones/${comentario.id}/puntuar.json';
          break;
        case SectionType.recetas:
          url = '/comentario_recetas/${comentario.id}/puntuar.json';
          break;
        case SectionType.pois:
          url = '/comentario_pois/${comentario.id}/puntuar.json';
          break;
        default:
          url = '/comentario_publicaciones/${comentario.id}/puntuar.json';
      }

      var usuario = context.read<UserState>().activeUser.getUsuario;

      var puntaje = comentario.puntajes.firstWhere(
        (p) => p.usuario.id == usuario.id,
        orElse: () => null,
      );

      puntaje ??= Puntaje(usuario, 0);

      puntaje.puntaje = puntaje.puntaje == 0 ? 1 : 0;

      comentario.addMyPuntaje(puntaje);

      await Fetcher.put(
        url: url,
        body: {},
      );

      if (mounted) setState(() {});

      await widget.fetchContent();
    } catch (e) {
      print(e);
    }

    _sent = false;
    if (mounted) setState(() {});
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
            toggleLikeComment: _toggleLikeComment,
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
