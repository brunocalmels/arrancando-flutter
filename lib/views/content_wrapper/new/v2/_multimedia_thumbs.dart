import 'dart:io';

import 'package:arrancando/config/globals/index.dart';
import 'package:flutter/material.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class MultimediaThumbs extends StatelessWidget {
  final List<File> images;
  final Function(File) removeImage;

  MultimediaThumbs({
    @required this.images,
    this.removeImage,
  });

  Future<int> _computeSize() async {
    int pesos = (await Future.wait(
      images.map(
        (i) => i.length(),
      ),
    ))
        .fold(
      0,
      (sum, i) => sum + i,
    );
    return pesos;
  }

  Widget _muchoPesoArchivos() => FutureBuilder(
        future: _computeSize(),
        builder: (context, AsyncSnapshot<int> snapshot) {
          if (snapshot.hasData &&
              snapshot.data >= MyGlobals.MUCHO_PESO_PUBLICACION)
            return Padding(
              padding: const EdgeInsets.only(top: 15),
              child: Text(
                "Estás subiendo archivos muy pesados, la creación puede tardar.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 13,
                ),
              ),
            );
          return Container();
        },
      );

  @override
  Widget build(BuildContext context) {
    return images != null && images.length > 0
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(10),
                child: Wrap(
                  spacing: MediaQuery.of(context).size.width * 0.05,
                  runSpacing: MediaQuery.of(context).size.width * 0.05,
                  direction: Axis.horizontal,
                  children: images
                      .map(
                        (asset) => asset != null && asset.path != null
                            ? Container(
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      blurRadius: 4,
                                      color: Colors.black,
                                    )
                                  ],
                                ),
                                width:
                                    MediaQuery.of(context).size.width * 0.135,
                                height:
                                    MediaQuery.of(context).size.width * 0.135,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(4),
                                  ),
                                  child: Stack(
                                    fit: StackFit.passthrough,
                                    children: <Widget>[
                                      ['mp4', 'mpg', 'mpeg'].contains(asset.path
                                              .split('.')
                                              .last
                                              .toLowerCase())
                                          ? FutureBuilder(
                                              future:
                                                  VideoThumbnail.thumbnailData(
                                                video: asset.path,
                                                imageFormat: ImageFormat.JPEG,
                                                maxHeightOrWidth:
                                                    ((MediaQuery.of(context)
                                                                    .size
                                                                    .width -
                                                                32) /
                                                            3.5)
                                                        .floor(),
                                                quality: 70,
                                              ),
                                              builder: (context, snapshot) {
                                                if (snapshot.hasData) {
                                                  return Stack(
                                                    fit: StackFit.passthrough,
                                                    children: <Widget>[
                                                      Image.memory(
                                                        snapshot.data,
                                                        fit: BoxFit.cover,
                                                      ),
                                                      Center(
                                                        child: Icon(
                                                          Icons.play_arrow,
                                                          color: Colors.white,
                                                        ),
                                                      )
                                                    ],
                                                  );
                                                }
                                                return SizedBox(
                                                  height: 5,
                                                  width: 5,
                                                  child: Center(
                                                    child:
                                                        CircularProgressIndicator(
                                                      strokeWidth: 2,
                                                    ),
                                                  ),
                                                );
                                              },
                                            )
                                          : Image.file(
                                              asset,
                                              fit: BoxFit.cover,
                                            ),
                                      if (removeImage != null)
                                        Positioned(
                                          top: 0,
                                          right: 0,
                                          child: GestureDetector(
                                            onTap: () => removeImage(asset),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: Colors.red,
                                                boxShadow: [
                                                  BoxShadow(
                                                    blurRadius: 4,
                                                    color: Colors.black,
                                                  )
                                                ],
                                                borderRadius:
                                                    BorderRadius.circular(50),
                                              ),
                                              child: Icon(
                                                Icons.close,
                                                color: Colors.white,
                                                size: 15,
                                              ),
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              )
                            : Container(),
                      )
                      .toList(),
                ),
              ),
              _muchoPesoArchivos(),
            ],
          )
        : Container();
  }
}
