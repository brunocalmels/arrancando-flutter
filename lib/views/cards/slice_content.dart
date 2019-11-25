import 'package:arrancando/config/globals/index.dart';
import 'package:arrancando/config/models/content_wrapper.dart';
import 'package:arrancando/views/cards/_row_puntajes.dart';
import 'package:arrancando/views/content_wrapper/show/index.dart';
import 'package:flutter/material.dart';

class SliceContent extends StatelessWidget {
  final ContentWrapper content;

  SliceContent({
    this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 150,
      child: Card(
        elevation: 1,
        child: Stack(
          fit: StackFit.passthrough,
          children: <Widget>[
            Positioned(
              child: Material(
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Flexible(
                    flex: 1,
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(
                        Radius.circular(4),
                      ),
                      child: content.imagenes.length == 0
                          ? Center(
                              child: Icon(
                                Icons.photo_camera,
                                size: 50,
                                color: Color(0x33000000),
                              ),
                            )
                          : Image.network(
                              "${MyGlobals.SERVER_URL}${content.imagenes.first}",
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                  Flexible(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          content.fecha,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              content.titulo,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 25,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              content.cuerpo,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: Theme.of(context).textTheme.body1,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            RowPuntajes(
                              content: content,
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
