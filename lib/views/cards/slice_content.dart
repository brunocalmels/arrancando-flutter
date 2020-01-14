import 'package:arrancando/config/globals/index.dart';
import 'package:arrancando/config/models/content_wrapper.dart';
import 'package:arrancando/views/cards/_row_cant_comments.dart';
import 'package:arrancando/views/cards/_row_puntajes.dart';
import 'package:arrancando/views/content_wrapper/show/index.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class SliceContent extends StatelessWidget {
  final ContentWrapper content;

  SliceContent({
    this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Stack(
        fit: StackFit.passthrough,
        children: <Widget>[
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.all(
                Radius.circular(4),
              ),
              child: Container(
                color: Color(0x11666666),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: 100,
                  height: 100,
                  color: Colors.black12,
                  child:
                      content.imagenes == null || content.imagenes.length == 0
                          ? Center(
                              child: Icon(
                                Icons.photo_camera,
                                size: 50,
                                color: Color(0x33000000),
                              ),
                            )
                          : [
                              'mp4',
                              'mpg',
                              'mpeg'
                            ].contains(content.imagenes.first.split('.').last)
                              ? Center(
                                  child: Icon(
                                    Icons.video_library,
                                    size: 50,
                                    color: Color(0x33000000),
                                  ),
                                )
                              : CachedNetworkImage(
                                  imageUrl:
                                      "${MyGlobals.SERVER_URL}${content.imagenes.first}",
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => Center(
                                    child: SizedBox(
                                      width: 25,
                                      height: 25,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    ),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      Icon(Icons.error),
                                ),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Container(
                    height: 100,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Expanded(
                                  child: Text(
                                    content.titulo,
                                    maxLines: 2,
                                    style: Theme.of(context).textTheme.subhead,
                                  ),
                                ),
                                Icon(
                                  MyGlobals.ICONOS_CATEGORIAS[content.type],
                                  size: 15,
                                ),
                              ],
                            ),
                            Text(
                              content.fecha,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        Spacer(),
                        Row(
                          children: <Widget>[
                            RowPuntajes(
                              content: content,
                              textColor: Colors.black,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            RowCantComments(
                              content: content,
                              textColor: Colors.black,
                            ),
                            // Spacer(),
                            // CircleAvatar(
                            //   radius: 12,
                            //   backgroundImage: content.user != null &&
                            //           content.user.avatar != null
                            //       ? CachedNetworkImageProvider(
                            //           "${MyGlobals.SERVER_URL}${content.user.avatar}",
                            //         )
                            //       : null,
                            // ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.all(
                Radius.circular(4),
              ),
              child: Material(
                color: Colors.transparent,
                type: MaterialType.card,
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => ShowPage(
                          contentId: content.id,
                          type: content.type,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
