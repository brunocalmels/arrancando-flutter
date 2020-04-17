import 'package:arrancando/config/globals/enums.dart';
import 'package:arrancando/config/globals/index.dart';
import 'package:arrancando/config/models/content_wrapper.dart';
import 'package:arrancando/config/models/saved_content.dart';
import 'package:arrancando/views/cards/_row_cant_comments.dart';
import 'package:arrancando/views/cards/_row_puntajes.dart';
import 'package:arrancando/views/content_wrapper/dialog/share.dart';
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
        color: Theme.of(context).backgroundColor,
        elevation: 10,
        child: Stack(
          fit: StackFit.passthrough,
          children: <Widget>[
            Positioned(
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
            ),
            Padding(
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
                            CircleAvatar(
                              radius: 15,
                              backgroundImage: content.user != null &&
                                      content.user.avatar != null
                                  ? CachedNetworkImageProvider(
                                      "${MyGlobals.SERVER_URL}${content.user.avatar}",
                                    )
                                  : null,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(content.user == null
                                ? "------"
                                : "@${content.user.username}"),
                          ],
                        ),
                        SizedBox(
                          height: 10,
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
                              "40 minutos",
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
                              Icons.kitchen,
                              color: Theme.of(context).accentColor,
                              size: 15,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              "Pastas",
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
                              Icons.add_box,
                              color: Theme.of(context).accentColor,
                              size: 15,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              "Complicado",
                              style: TextStyle(
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                        Expanded(
                          child: Container(),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            GestureDetector(
                              child: Icon(
                                Icons.favorite,
                                color: Theme.of(context).accentColor,
                              ),
                              onTap: () {
                                print('favorite');
                              },
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
                              width: 7,
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
                              Icons.person_outline,
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
                                      imageUrl: content.thumbnail
                                              .contains('http')
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
                              onTap: () =>
                                  SavedContent.toggleSave(content, context),
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
            ),
          ],
        ),
      ),
    );
  }
}
