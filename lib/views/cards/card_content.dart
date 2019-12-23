import 'package:arrancando/config/globals/enums.dart';
import 'package:arrancando/config/globals/index.dart';
import 'package:arrancando/config/models/content_wrapper.dart';
import 'package:arrancando/config/models/saved_content.dart';
import 'package:arrancando/views/cards/_row_cant_comments.dart';
import 'package:arrancando/views/cards/_row_puntajes.dart';
import 'package:arrancando/views/content_wrapper/show/index.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CardContent extends StatelessWidget {
  final ContentWrapper content;

  CardContent({
    @required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.37,
      child: Card(
        child: Stack(
          fit: StackFit.passthrough,
          children: <Widget>[
            Positioned(
              child: ClipRRect(
                borderRadius: BorderRadius.all(
                  Radius.circular(4),
                ),
                child: content.imagenes.length == 0
                    ? Center(
                        child: Icon(
                          Icons.photo_camera,
                          size: 100,
                          color: Color(0x33000000),
                        ),
                      )
                    : ['mp4', 'mpg', 'mpeg']
                            .contains(content.imagenes.first.split('.').last)
                        ? Center(
                            child: Icon(
                              Icons.video_library,
                              size: 100,
                              color: Color(0x33000000),
                            ),
                          )
                        // : Image.network(
                        //     "${MyGlobals.SERVER_URL}${content.imagenes.first}",
                        //     // "${content.imagenes.first}",
                        //     fit: BoxFit.cover,
                        //   ),
                        : CachedNetworkImage(
                            imageUrl:
                                "${MyGlobals.SERVER_URL}${content.imagenes.first}",
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
            ),
            Container(
              color: Color(0x77000000),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 10,
                right: 10,
                bottom: 10,
              ),
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Text(
                          content.fecha,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: Container(),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Flexible(
                            child: Text(
                              content.titulo,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 30,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      if (content.type == SectionType.publicaciones)
                        Text(
                          content.cuerpo,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: Theme.of(context).textTheme.body1.merge(
                                TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                        ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          RowPuntajes(
                            content: content,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          RowCantComments(
                            content: content,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Positioned(
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
            Padding(
              padding: const EdgeInsets.only(
                left: 10,
                right: 10,
                bottom: 10,
              ),
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      if (content != null)
                        SizedBox(
                          width: 35,
                          child: IconButton(
                            onPressed: () =>
                                SavedContent.toggleSave(content, context),
                            icon: Icon(
                              SavedContent.isSaved(content, context)
                                  ? Icons.bookmark
                                  : Icons.bookmark_border,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      SizedBox(
                        width: 35,
                        child: IconButton(
                          onPressed: content.shareSelf,
                          icon: Icon(
                            Icons.share,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Positioned(
              right: 10,
              bottom: 10,
              child: Tooltip(
                waitDuration: Duration(milliseconds: 50),
                message: "@${content.user.username}",
                child: CircleAvatar(
                  radius: 15,
                  backgroundImage:
                      content.user != null && content.user.avatar != null
                          ? CachedNetworkImageProvider(
                              "${MyGlobals.SERVER_URL}${content.user.avatar}",
                            )
                          : null,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
