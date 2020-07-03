import 'package:arrancando/config/fonts/arrancando_icons_icons.dart';
import 'package:arrancando/config/globals/enums.dart';
import 'package:arrancando/config/globals/global_singleton.dart';
import 'package:arrancando/config/globals/index.dart';
import 'package:arrancando/config/models/content_wrapper.dart';
import 'package:arrancando/config/models/saved_content.dart';
import 'package:arrancando/views/content_wrapper/dialog/share.dart';
import 'package:arrancando/views/content_wrapper/show/_heart_plus5.dart';
import 'package:arrancando/views/content_wrapper/show/index.dart';
import 'package:arrancando/views/user_profile/index.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CardContent extends StatelessWidget {
  final GlobalSingleton gs = GlobalSingleton();
  final ContentWrapper content;

  CardContent({
    @required this.content,
  });

  Widget _contentBehind(context) => Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  // Avatar + Username
                  SizedBox(
                    height: 40,
                  ),
                  Text(
                    content.titulo.toUpperCase(),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  content.type == SectionType.recetas
                      ? Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Icon(
                                  Icons.timer,
                                  color: Theme.of(context).accentColor,
                                  size: 15,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  content.duracion != null
                                      ? "${content.duracion} minutos"
                                      : "Desconocido",
                                  style: TextStyle(
                                    fontSize: 10,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Icon(
                                  ArrancandoIcons.horno,
                                  color: Theme.of(context).accentColor,
                                  size: 15,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  gs.categories[SectionType.recetas]
                                          .firstWhere(
                                            (c) =>
                                                c.id ==
                                                content.categoriaRecetaId,
                                            orElse: () => null,
                                          )
                                          ?.nombre ??
                                      'Desconocida',
                                  style: TextStyle(
                                    fontSize: 10,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Icon(
                                  ArrancandoIcons.dificultad,
                                  color: Theme.of(context).accentColor,
                                  size: 15,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  content.complejidad ?? "Desconocida",
                                  style: TextStyle(
                                    fontSize: 10,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        )
                      : Text(
                          content.cuerpo ?? '',
                          maxLines: 5,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 10,
                          ),
                        ),
                  Expanded(
                    child: Container(),
                  ),
                  // Row iconos
                ],
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        content.fecha,
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      Icon(
                        Icons.calendar_today,
                        size: 15,
                        color: Theme.of(context).accentColor,
                      ),
                    ],
                  ),
                  Expanded(
                    child: Container(),
                  ),
                  SizedBox(
                    width: 150,
                    height: 125,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black,
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 10,
                            color: Colors.black,
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(
                          Radius.circular(4),
                        ),
                        child: content.thumbnail == null
                            ? Center(
                                child: Icon(
                                  Icons.photo_camera,
                                  size: 50,
                                  color: Color(0x33000000),
                                ),
                              )
                            : CachedNetworkImage(
                                imageUrl: content.thumbnail.contains('http')
                                    ? "${content.thumbnail}"
                                    : "${MyGlobals.SERVER_URL}${content.thumbnail}",
                                fit: BoxFit.cover,
                                placeholder: (context, url) => Center(
                                  child: SizedBox(
                                    width: 15,
                                    height: 15,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  ),
                                ),
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error),
                              ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  // Row iconos
                ],
              ),
            ),
          ],
        ),
      );

  Widget _contentFront(context) => Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => UserProfilePage(
                                  user: content.user,
                                ),
                                settings: RouteSettings(
                                  name: "UserProfilePage",
                                ),
                              ),
                            );
                          },
                          child: CircleAvatar(
                            radius: 15,
                            backgroundImage: content.user != null &&
                                    content.user.avatar != null
                                ? CachedNetworkImageProvider(
                                    "${MyGlobals.SERVER_URL}${content.user.avatar}",
                                  )
                                : null,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Text(
                          content.user == null
                              ? "------"
                              : "@${content.user.username}",
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  // RecetaInfo / Descripción
                  Expanded(
                    child: Container(),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      HeartPlus5(
                        content: content,
                      ),
                      SizedBox(
                        width: 7,
                      ),
                      GestureDetector(
                        child: Icon(
                          Icons.chat_bubble_outline,
                          color: Theme.of(context).accentColor,
                        ),
                        onTap: () {
                          print('chat_bubble_outline');
                        },
                      ),
                      SizedBox(
                        width: 12,
                      ),
                      GestureDetector(
                        child: Icon(
                          Icons.camera_alt,
                          color: Theme.of(context).accentColor,
                        ),
                        onTap: () {
                          print('camera_alt');
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  // Fecha
                  Expanded(
                    child: Container(),
                  ),
                  // Foto
                  Expanded(
                    child: Container(),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (_) => ShareContentWrapper(
                              content: content,
                            ),
                          );
                        },
                        child: Icon(
                          Icons.share,
                          color: Theme.of(context).accentColor,
                        ),
                      ),
                      SizedBox(
                        width: 7,
                      ),
                      GestureDetector(
                        onTap: () => SavedContent.toggleSave(content, context),
                        child: Icon(
                          SavedContent.isSaved(content, context)
                              ? Icons.bookmark
                              : Icons.bookmark_border,
                          color: Theme.of(context).accentColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      );

  Widget _tapInkWell(context) => Positioned(
        child: Material(
          color: Colors.transparent,
          type: MaterialType.card,
          child: InkWell(
            borderRadius: BorderRadius.all(
              Radius.circular(4),
            ),
            onTap: () {
              print(
                  '${content.type.toString().split('.').last[0].toLowerCase()}${content.type.toString().split('.').last.substring(1)}#${content.id}');
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => ShowPage(
                    contentId: content.id,
                    type: content.type,
                  ),
                  settings: RouteSettings(
                    name:
                        '${content.type.toString().split('.').last[0].toLowerCase()}${content.type.toString().split('.').last.substring(1)}#${content.id}',
                  ),
                ),
              );
            },
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.37,
      child: Card(
        color: Theme.of(context).backgroundColor,
        elevation: 10,
        child: Stack(
          fit: StackFit.passthrough,
          children: <Widget>[
            _contentBehind(context),
            _tapInkWell(context),
            _contentFront(context),
          ],
        ),
      ),
    );
  }
}
