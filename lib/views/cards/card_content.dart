import 'package:arrancando/config/globals/index.dart';
import 'package:arrancando/config/models/content_wrapper.dart';
import 'package:arrancando/config/models/saved_content.dart';
import 'package:arrancando/views/cards/_row_puntajes.dart';
import 'package:arrancando/views/content_wrapper/show/index.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class CardContent extends StatelessWidget {
  final ContentWrapper content;

  CardContent({
    this.content,
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
                    : Image.network(
                        "${MyGlobals.SERVER_URL}${content.imagenes.first}",
                        // "${content.imagenes.first}",
                        fit: BoxFit.cover,
                      ),
              ),
            ),
            Positioned(
              child: Material(
                color: Color(0x77000000),
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          content.fecha,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
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
                          onPressed: () async {
                            if (content.imagenes.length > 0) {
                              http.Response response = await http.get(
                                "${MyGlobals.SERVER_URL}${content.imagenes.first}",
                              );

                              Share.file(
                                'Compartir imagen',
                                'imagen.jpg',
                                response.bodyBytes,
                                'image/jpg',
                                text: "Texto texto texto",
                              );
                            }
                          },
                          icon: Icon(
                            Icons.share,
                            color: Colors.white,
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
                      Text(
                        content.titulo,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        content.cuerpo,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 4,
                        style: Theme.of(context).textTheme.body1.merge(
                              TextStyle(
                                color: Colors.white,
                              ),
                            ),
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
    );
  }
}
