import 'package:arrancando/config/globals/index.dart';
import 'package:arrancando/config/models/comentario.dart';
import 'package:arrancando/config/models/content_wrapper.dart';
import 'package:arrancando/config/state/main.dart';
import 'package:arrancando/config/state/user.dart';
import 'package:arrancando/views/content_wrapper/show/textos/index.dart';
import 'package:arrancando/views/user_profile/index.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CommentsList extends StatelessWidget {
  final ContentWrapper content;
  final Function(int, String) setEditCommentId;
  final Function(int) setDeleteCommentId;
  final Function(Comentario) toggleLikeComment;

  CommentsList({
    @required this.content,
    @required this.setEditCommentId,
    @required this.setDeleteCommentId,
    @required this.toggleLikeComment,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: content.comentarios != null && content.comentarios.length > 0
          ? Column(
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
                      Text(
                        "${content.comentarios.length} comentarios",
                        style: TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  constraints: BoxConstraints(
                    maxHeight: 260,
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: content.comentarios.reversed
                          .map(
                            (c) => Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Color(0x99161a25),
                                  boxShadow: Provider.of<MainState>(context)
                                              .activeTheme ==
                                          ThemeMode.dark
                                      ? [
                                          BoxShadow(
                                            blurRadius: 7,
                                            color: Color(0xff161a25),
                                          ),
                                        ]
                                      : null,
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        onTap: () {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (_) => UserProfilePage(
                                                user: c.user,
                                              ),
                                              settings: RouteSettings(
                                                  name: 'UserProfilePage'),
                                            ),
                                          );
                                        },
                                        child: CircleAvatar(
                                          radius: 30,
                                          backgroundImage: c.user != null &&
                                                  c.user.avatar != null
                                              ? CachedNetworkImageProvider(
                                                  "${MyGlobals.SERVER_URL}${c.user.avatar}",
                                                )
                                              : null,
                                        ),
                                      ),
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
                                              color: Provider.of<MainState>(
                                                              context)
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
                                            c.fecha,
                                            style: TextStyle(
                                              fontSize: 9,
                                              color:
                                                  Colors.white.withAlpha(150),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 4,
                                          ),
                                          // Text(
                                          //   c.mensaje,
                                          //   style: TextStyle(
                                          //     fontSize: 11,
                                          //     color: Colors.white.withAlpha(150),
                                          //   ),
                                          // ),
                                          TextosShow(
                                            content: null,
                                            fullText: c.mensaje,
                                            textAlign: TextAlign.left,
                                            fontSize: 11,
                                            paddingZero: true,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Text("${c.puntajes.length}"),
                                        if (c.esOwner(context))
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 5),
                                            child: Icon(
                                              Icons.favorite,
                                              color:
                                                  Theme.of(context).accentColor,
                                              size: 12,
                                            ),
                                          ),
                                      ],
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
                                      Material(
                                        color: Colors.transparent,
                                        type: MaterialType.circle,
                                        child: InkWell(
                                          child: Padding(
                                            padding: const EdgeInsets.all(5),
                                            child: Icon(
                                              c.myPuntaje(Provider.of<
                                                                  UserState>(
                                                              context)
                                                          .activeUser
                                                          .id) >
                                                      0
                                                  ? Icons.favorite
                                                  : Icons.favorite_border,
                                              color:
                                                  Theme.of(context).accentColor,
                                            ),
                                          ),
                                          onTap: () => toggleLikeComment(c),
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
                ),
              ],
            )
          : Text(
              "Aún no hay comentarios",
              textAlign: TextAlign.center,
            ),
    );
  }
}
