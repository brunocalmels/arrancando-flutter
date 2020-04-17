import 'package:arrancando/config/models/content_wrapper.dart';
import 'package:arrancando/views/content_wrapper/show/comentarios/_comments_list.dart';
import 'package:arrancando/views/content_wrapper/show/comentarios/_from_send_comment.dart';
import 'package:flutter/material.dart';

class ComentariosSection extends StatelessWidget {
  final ContentWrapper content;
  final Function fetchContent;

  ComentariosSection({
    @required this.content,
    @required this.fetchContent,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          CommentsList(
            content: content,
          ),
          SizedBox(
            height: 20,
          ),
          FormSendComment(
            content: content,
            fetchContent: fetchContent,
          ),
        ],
      ),
    );
  }
}
