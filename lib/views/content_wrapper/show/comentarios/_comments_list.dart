import 'package:arrancando/config/globals/index.dart';
import 'package:arrancando/config/models/content_wrapper.dart';
import 'package:arrancando/config/state/main.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CommentsList extends StatelessWidget {
  final ContentWrapper content;
  final Function(int, String) setEditCommentId;
  final Function(int) setDeleteCommentId;
  final Function(int) toggleLikeComment;

  CommentsList({
    @required this.content,
    @required this.setEditCommentId,
    @required this.setDeleteCommentId,
    @required this.toggleLikeComment,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: 260,
      ),
      child: content.comentarios != null && content.comentarios.length > 0
          ? SingleChildScrollView(
              child: Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      color: Color(0x99161a25),
                      padding: const EdgeInsets.all(5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.chat_bubble_outline,
                            size: 15,
                            color: Theme.of(context).accentColor,
                          ),
                          SizedBox(width: 5),
                          Text("${content.comentarios.length}"),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    ...[...content.comentarios]
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
                                crossAxisAlignment: CrossAxisAlignment.center,
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          "@${c.user.username}",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color:
                                                Provider.of<MainState>(context)
                                                            .activeTheme ==
                                                        ThemeMode.dark
                                                    ? null
                                                    : Colors.white,
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
                                  if (c.esOwner(context))
                                    PopupMenuButton(
                                      icon: Icon(
                                        Icons.more_vert,
                                        size: 20,
                                        color: Theme.of(context)
                                            .accentColor
                                            .withAlpha(150),
                                      ),
                                      onSelected: (val) {
                                        if (val == 'editar') {
                                          setEditCommentId(
                                            c.id,
                                            c.mensaje,
                                          );
                                        } else if (val == 'eliminar') {
                                          setDeleteCommentId(c.id);
                                        }
                                      },
                                      itemBuilder: (_) => [
                                        PopupMenuItem(
                                          child: Text("Editar"),
                                          value: "editar",
                                        ),
                                        PopupMenuItem(
                                          child: Text("Eliminar"),
                                          value: "eliminar",
                                        ),
                                      ],
                                    ),
                                  if (!c.esOwner(context))
                                    IconButton(
                                      icon: Icon(
                                        Icons.favorite_border,
                                        color: Theme.of(context).accentColor,
                                      ),
                                      onPressed: () => toggleLikeComment(c.id),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ],
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
