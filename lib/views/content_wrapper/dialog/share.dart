import 'dart:typed_data';

import 'package:arrancando/config/globals/index.dart';
import 'package:arrancando/config/models/content_wrapper.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  int _imagenNro = 0;
  List _imagenes;
  bool _enlaceCopiado = false;

  Future<void> _shareGeneric({bool esFbk = false, bool esWpp = false}) async {
    Uint8List imageBytes;
    if (_imagenes != null && _imagenes.isNotEmpty) {
      String i = _imagenes[_imagenNro];

      String url = _imagenes[_imagenNro].contains('http')
          ? _imagenes[_imagenNro]
          : '${MyGlobals.SERVER_URL}${_imagenes[_imagenNro]}'
              '${MyGlobals.SERVER_URL}';

      if (MyGlobals.VIDEO_FORMATS.contains(i.split('.').last.toLowerCase()) &&
          widget.content.videoThumbs[i] != null) {
        // _videoThumbs[i].readAsBytesSync();
        url = widget.content.videoThumbs[i];
      }

      url = url.contains('http') ? url : '${MyGlobals.SERVER_URL}$url';

      final response = await http.get(url);
      imageBytes = response.bodyBytes;
    }

    await widget.content.sharedThisContent();

    await widget.content.shareSelf(
      esFull: _esFull,
      imageBytes: imageBytes,
      esWpp: esWpp,
      esFbk: esFbk,
    );
  }

  Future<void> _shareLink() async {
    _enlaceCopiado = true;
    if (mounted) setState(() {});

    final url =
        'https://arrancando.com.ar/${widget.content.type.toString().split('.').last}/${widget.content.id}';

    await Clipboard.setData(
      ClipboardData(
        text: url,
      ),
    );

    await Future.delayed(Duration(seconds: 2));

    _enlaceCopiado = false;
    if (mounted) setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _imagenes =
        widget.content.imagenes != null && widget.content.imagenes.isNotEmpty
            ? widget.content.imagenes
            : widget.content.thumbnail != null
                ? [widget.content.thumbnail]
                : [];
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Compartir contenido'),
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
                  Text('Resumen'),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Switch(
                      onChanged: (val) {
                        _esFull = val;
                        if (mounted) setState(() {});
                      },
                      value: _esFull,
                    ),
                  ),
                  Text('Completo'),
                ],
              ),
              // if (widget.content.type == SectionType.recetas && _esFull)
              //   Row(
              //     mainAxisAlignment: MainAxisAlignment.center,
              //     crossAxisAlignment: CrossAxisAlignment.center,
              //     children: <Widget>[
              //       Checkbox(
              //         value: _esWpp,
              //         onChanged: (val) {
              //           if (mounted)
              //             setState(() {
              //               _esWpp = val;
              //             });
              //         },
              //       ),
              //       Text(
              //         'Voy a compartir en WhatsApp',
              //         style: TextStyle(
              //           fontSize: 12,
              //         ),
              //       ),
              //     ],
              //   ),
              SizedBox(
                height: 15,
              ),
              if (_imagenes == null || _imagenes.isEmpty)
                Text(
                  'No hay im??genes para compartir',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 11,
                  ),
                )
              else if (_imagenes != null && _imagenes.isNotEmpty)
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        bottom: 7,
                      ),
                      child: Text(
                        'Seleccion?? la imagen a compartir',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 11,
                        ),
                      ),
                    ),
                    Container(
                      constraints: BoxConstraints(
                        maxHeight:
                            ((MediaQuery.of(context).size.width - 32) / 4) *
                                2.8,
                      ),
                      child: SingleChildScrollView(
                        child: Wrap(
                          direction: Axis.horizontal,
                          children: _imagenes
                              .asMap()
                              .map(
                                (index, i) => MapEntry(
                                  index,
                                  Container(
                                    padding: const EdgeInsets.all(2),
                                    width: (MediaQuery.of(context).size.width -
                                            32) /
                                        4,
                                    height: (MediaQuery.of(context).size.width -
                                            32) /
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
                                          MyGlobals.VIDEO_FORMATS.contains(i
                                                  .split('.')
                                                  .last
                                                  .toLowerCase())
                                              ? widget.content.videoThumbs[i] ==
                                                      null
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
                                                  : CachedNetworkImage(
                                                      imageUrl:
                                                          '${MyGlobals.SERVER_URL}${widget.content.videoThumbs[i]}',
                                                      placeholder:
                                                          (context, url) =>
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
                                                      errorWidget: (context,
                                                              url, error) =>
                                                          Icon(Icons.error),
                                                    )
                                              // Image.file(
                                              //     _videoThumbs[i],
                                              //   )
                                              : CachedNetworkImage(
                                                  imageUrl: i.contains('http')
                                                      ? i
                                                      : '${MyGlobals.SERVER_URL}$i',
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
                  ],
                ),
              SizedBox(
                height: 15,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  IconButton(
                    icon: Image.asset('assets/images/logo-whatsapp.png'),
                    onPressed: () {
                      _shareGeneric(esWpp: true);
                    },
                  ),
                  IconButton(
                    icon: Image.asset('assets/images/logo-facebook.png'),
                    onPressed: () {
                      _shareGeneric(esFbk: true);
                    },
                  ),
                  IconButton(
                    color: Colors.black45,
                    icon: Icon(Icons.add_box),
                    onPressed: _shareGeneric,
                  ),
                  IconButton(
                    color: Colors.black45,
                    icon: Icon(
                      Icons.link,
                      color: Theme.of(context).accentColor,
                    ),
                    onPressed: _shareLink,
                  ),
                ],
              ),
              if (_enlaceCopiado)
                Padding(
                  padding: const EdgeInsets.all(5),
                  child: Text(
                    'Enlace copiado!',
                    style: TextStyle(
                      fontSize: 11,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        FlatButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('Cancelar'),
        ),
      ],
    );
  }
}
