import 'dart:io';
import 'dart:typed_data';

import 'package:arrancando/config/globals/enums.dart';
import 'package:arrancando/config/globals/index.dart';
import 'package:arrancando/config/models/content_wrapper.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:http/http.dart' as http;

class ShareContentWrapper extends StatefulWidget {
  final ContentWrapper content;

  ShareContentWrapper({
    @required this.content,
  });

  @override
  _ShareContentWrapperState createState() => _ShareContentWrapperState();
}

class _ShareContentWrapperState extends State<ShareContentWrapper> {
  bool _esFull = false;
  bool _esWpp = false;
  int _imagenNro = 0;
  Map<String, File> _videoThumbs = {};

  _getVideosThumbs() async {
    if (widget.content.imagenes != null && widget.content.imagenes.length > 0) {
      _videoThumbs = {};
      String thumbPath = (await getTemporaryDirectory()).path;
      List<String> vids = widget.content.imagenes
          .where((i) =>
              ['mp4', 'mpg', 'mpeg'].contains(i.split('.').last.toLowerCase()))
          .toList();

      await Future.wait(
        vids.map(
          (v) async {
            String filename = v.split('/').last;
            filename = filename.replaceRange(
              filename[filename.length - 4] == '.'
                  ? filename.length - 3
                  : filename.length - 4,
              filename.length,
              'jpg',
            );
            File thumb = File("$thumbPath/$filename");
            if (thumb.existsSync()) {
              _videoThumbs[v] = thumb;
            } else {
              _videoThumbs[v] = File(
                await VideoThumbnail.thumbnailFile(
                  video: "${MyGlobals.SERVER_URL}$v",
                  thumbnailPath: thumbPath,
                  imageFormat: ImageFormat.JPEG,
                  maxHeightOrWidth: 350,
                  quality: 95,
                ),
              );
            }
          },
        ),
      );
      if (mounted) setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    _getVideosThumbs();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Compartir contenido"),
      contentPadding: const EdgeInsets.all(3),
      content: Container(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text("Resumen"),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Switch(
                      onChanged: (val) {
                        if (mounted)
                          setState(() {
                            _esFull = val;
                          });
                      },
                      value: _esFull,
                    ),
                  ),
                  Text("Completo"),
                ],
              ),
              if (widget.content.type == SectionType.recetas && _esFull)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Checkbox(
                      value: _esWpp,
                      onChanged: (val) {
                        if (mounted)
                          setState(() {
                            _esWpp = val;
                          });
                      },
                    ),
                    Text(
                      "Voy a compartir en WhatsApp",
                      style: TextStyle(
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              SizedBox(
                height: 15,
              ),
              if (widget.content.imagenes == null ||
                  widget.content.imagenes.length == 0)
                Text(
                  "No hay imágenes para compartir",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 11,
                  ),
                ),
              if (widget.content.imagenes != null &&
                  widget.content.imagenes.length > 0)
                Padding(
                  padding: const EdgeInsets.only(
                    bottom: 7,
                  ),
                  child: Text(
                    "Seleccioná la imagen a compartir",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 11,
                    ),
                  ),
                ),
              if (widget.content.imagenes != null &&
                  widget.content.imagenes.length > 0)
                Container(
                  constraints: BoxConstraints(
                    maxHeight:
                        ((MediaQuery.of(context).size.width - 32) / 4) * 2.8,
                  ),
                  child: SingleChildScrollView(
                    child: Wrap(
                      direction: Axis.horizontal,
                      children: widget.content.imagenes
                          .asMap()
                          .map(
                            (index, i) => MapEntry(
                              index,
                              Container(
                                padding: const EdgeInsets.all(2),
                                width:
                                    (MediaQuery.of(context).size.width - 32) /
                                        4,
                                height:
                                    (MediaQuery.of(context).size.width - 32) /
                                        4,
                                child: FlatButton(
                                  color: Colors.black12,
                                  padding: const EdgeInsets.all(0),
                                  onPressed: () {
                                    _imagenNro = index;
                                    setState(() {});
                                  },
                                  child: Stack(
                                    fit: StackFit.expand,
                                    children: <Widget>[
                                      ['mp4', 'mpg', 'mpeg'].contains(
                                              i.split('.').last.toLowerCase())
                                          ? _videoThumbs[i] == null
                                              ? SizedBox(
                                                  height: 25,
                                                  width: 25,
                                                  child: Center(
                                                    child:
                                                        CircularProgressIndicator(
                                                      strokeWidth: 2,
                                                    ),
                                                  ),
                                                )
                                              : Image.file(
                                                  _videoThumbs[i],
                                                )
                                          : CachedNetworkImage(
                                              imageUrl:
                                                  "${MyGlobals.SERVER_URL}$i",
                                              placeholder: (context, url) =>
                                                  Center(
                                                child: SizedBox(
                                                  width: 25,
                                                  height: 25,
                                                  child:
                                                      CircularProgressIndicator(
                                                    strokeWidth: 2,
                                                  ),
                                                ),
                                              ),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      Icon(Icons.error),
                                            ),
                                      if (_imagenNro == index)
                                        Container(
                                          color: Colors.green.withAlpha(80),
                                          child: Center(
                                            child: Icon(
                                              Icons.share,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          )
                          .values
                          .toList(),
                    ),
                  ),
                ),
              SizedBox(
                height: 15,
              ),
              RaisedButton(
                onPressed: () async {
                  Uint8List imageBytes;
                  if (widget.content.imagenes != null &&
                      widget.content.imagenes.isNotEmpty) {
                    String i = widget.content.imagenes[_imagenNro];

                    if (['mp4', 'mpg', 'mpeg']
                            .contains(i.split('.').last.toLowerCase()) &&
                        _videoThumbs[i] != null) {
                      imageBytes = _videoThumbs[i].readAsBytesSync();
                    } else {
                      http.Response response = await http.get(
                        "${MyGlobals.SERVER_URL}${widget.content.imagenes[_imagenNro]}",
                      );
                      imageBytes = response.bodyBytes;
                    }
                  }

                  widget.content.shareSelf(
                    esFull: _esFull,
                    imageBytes: imageBytes,
                    esWpp: _esWpp,
                  );
                },
                color: Colors.green,
                child: Text(
                  "Compartir",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      actions: <Widget>[
        FlatButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text("Cancelar"),
        ),
      ],
    );
  }
}
