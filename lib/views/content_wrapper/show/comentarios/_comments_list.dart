import 'package:arrancando/config/globals/index.dart';
import 'package:arrancando/config/models/content_wrapper.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CommentsList extends StatefulWidget {
  final ContentWrapper content;

  CommentsList({
    @required this.content,
  });

  @override
  _CommentsListState createState() => _CommentsListState();
}

class _CommentsListState extends State<CommentsList> {
  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: 260,
      ),
      child: widget.content.comentarios != null &&
              widget.content.comentarios.length > 0
          ? SingleChildScrollView(
              child: Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [...widget.content.comentarios]
                      .reversed
                      .map(
                        (c) => Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Color(0x99161a25),
                              boxShadow: [
                                BoxShadow(
                                  blurRadius: 7,
                                  color: Color(0xff161a25),
                                ),
                              ],
                            ),
                            child: Row(
                              children: <Widget>[
                                CircleAvatar(
                                  radius: 30,
                                  backgroundImage:
                                      c.user != null && c.user.avatar != null
                                          ? CachedNetworkImageProvider(
                                              "${MyGlobals.SERVER_URL}${c.user.avatar}",
                                            )
                                          : null,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        "@${c.user.username}",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 4,
                                      ),
                                      Text(
                                        c.mensaje,
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: Colors.white.withAlpha(150),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
            )
          : Text(
              "Aún no hay comentarios",
              textAlign: TextAlign.center,
            ),
    );
  }
}