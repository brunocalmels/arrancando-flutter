import 'dart:convert';

import 'package:arrancando/config/globals/enums.dart';
import 'package:arrancando/config/globals/global_singleton.dart';
import 'package:arrancando/config/globals/index.dart';
import 'package:arrancando/config/models/category_wrapper.dart';
import 'package:arrancando/config/models/content_wrapper.dart';
import 'package:arrancando/config/models/saved_content.dart';
import 'package:arrancando/config/services/fetcher.dart';
import 'package:arrancando/views/content_wrapper/dialog/share.dart';
import 'package:arrancando/views/content_wrapper/edit/index.dart';
import 'package:arrancando/views/content_wrapper/new/v2/publicacion.dart';
import 'package:arrancando/views/content_wrapper/show/_cabecera_show.dart';
import 'package:arrancando/views/content_wrapper/show/_comentarios_section.dart';
import 'package:arrancando/views/content_wrapper/show/_image_slider.dart';
import 'package:arrancando/views/content_wrapper/show/_show_app_bar.dart';
import 'package:arrancando/views/home/pages/_loading_widget.dart';
import 'package:arrancando/views/home/pages/_pois_map.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ShowPage extends StatefulWidget {
  final int contentId;
  final SectionType type;

  ShowPage({
    @required this.contentId,
    @required this.type,
  });

  @override
  _ShowPageState createState() => _ShowPageState();
}

class _ShowPageState extends State<ShowPage> {
  final GlobalSingleton gs = GlobalSingleton();
  ContentWrapper _content;
  bool _fetching = true;
  String _url;
  String _categoryName = "";
  String _imageSrc;

  Future<void> _fetchContent() async {
    switch (widget.type) {
      case SectionType.publicaciones:
        _url = "/publicaciones";
        break;
      case SectionType.recetas:
        _url = "/recetas";
        break;
      case SectionType.pois:
        _url = "/pois";
        break;
      default:
        _url = "/publicaciones";
    }

    ResponseObject resp = await Fetcher.get(
      url: "$_url/${widget.contentId}.json",
    );

    if (resp != null) {
      _content = ContentWrapper.fromJson(json.decode(resp.body));
      _content.type = widget.type;
    }

    _fetching = false;

    if (mounted) setState(() {});

    if (resp != null) {
      if (gs == null ||
          gs.categories == null ||
          gs.categories[_content.type] == null ||
          gs.categories[_content.type].isEmpty) {
        await CategoryWrapper.loadCategories();
      }
      _categoryName = gs.categories[_content.type]
          .firstWhere((c) => c.id == _content.categID)
          .nombre;
      _getFirstImage();
      if (mounted) setState(() {});
    }
  }

  List<dynamic> _parseTexto(String cuerpo) {
    var urlPattern =
        r"(https://?|http://?)([-A-Z0-9.]+)(/[-A-Z0-9+&@#/%=~_|!:,.;]*)?(\?[A-Z0-9+&@#/%=~_|!:‌​,.;]*)?";

    var results = new RegExp(
      urlPattern,
      caseSensitive: false,
    ).allMatches(cuerpo);
    List<dynamic> chunks = [];
    int lastEnd = 0;
    results.forEach(
      (r) {
        chunks.add(
          {
            "texto": cuerpo.substring(
              lastEnd,
              r.start,
            ),
            "tipo": "texto",
          },
        );
        chunks.add(
          {
            "texto": cuerpo.substring(
              r.start,
              r.end,
            ),
            "tipo": "link",
          },
        );
        lastEnd = r.end;
      },
    );
    if (chunks.length == 0)
      chunks.add(
        {
          "texto": cuerpo,
          "tipo": "texto",
        },
      );
    return chunks;
  }

  void _getFirstImage() {
    if (_content.imagenes != null && _content.imagenes.isNotEmpty) {
      if (['mp4', 'mpg', 'mpeg'].contains(
        _content.imagenes.first.split('.').last.toLowerCase(),
      )) {
        _imageSrc = _content.videoThumbs[_content.imagenes.first]
                .contains('http')
            ? _content.videoThumbs[_content.imagenes.first]
            : "${MyGlobals.SERVER_URL}${_content.videoThumbs[_content.imagenes.first]}";
      } else {
        _imageSrc = _content.imagenes.first.contains('http')
            ? _content.imagenes.first
            : "${MyGlobals.SERVER_URL}${_content.imagenes.first}";
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchContent();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        child: ShowAppBar(
          content: _content,
          fetchContent: _fetchContent,
        ),
        preferredSize: Size.fromHeight(kToolbarHeight),
      ),
      body: RefreshIndicator(
        onRefresh: _fetchContent,
        child: SingleChildScrollView(
          child: _fetching
              ? LoadingWidget(height: 200)
              : _content == null
                  ? Container(
                      child: Text("Ocurrió un error"),
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        CabeceraShow(
                          content: _content,
                          imageSrc: _imageSrc,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(15),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Icon(MyGlobals
                                      .ICONOS_CATEGORIAS[_content.type]),
                                  Text(" / "),
                                  Text(_categoryName)
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Expanded(
                                    child: Text(
                                      "${_content.titulo}",
                                      style: Theme.of(context).textTheme.title,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 3),
                                    child: Text("${_content.fecha}"),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                        ),
                        if (widget.type == SectionType.pois &&
                            _content.latitud != null &&
                            _content.longitud != null)
                          PoisMap(
                            height: 200,
                            latitud: _content.latitud,
                            longitud: _content.longitud,
                            zoom: 15,
                          ),
                        SizedBox(
                          height: 10,
                        ),
                        if (_content.cuerpo != null &&
                            _content.cuerpo.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 15,
                              top: 15,
                              right: 15,
                              bottom: 25,
                            ),
                            // child: Text(
                            //   "${_content.cuerpo}",
                            //   textAlign: TextAlign.justify,
                            // ),

                            child: RichText(
                              textAlign: TextAlign.justify,
                              text: TextSpan(
                                children: _parseTexto(_content.cuerpo)
                                    .map(
                                      (chunk) => TextSpan(
                                        text: chunk['texto'],
                                        style: chunk['tipo'] != 'link'
                                            ? TextStyle(
                                                color: Theme.of(context)
                                                    .textTheme
                                                    .body1
                                                    .color)
                                            : TextStyle(color: Colors.blue),
                                        recognizer: chunk['tipo'] != 'link'
                                            ? null
                                            : (TapGestureRecognizer()
                                              ..onTap = () async {
                                                if (await canLaunch(
                                                    chunk['texto'])) {
                                                  await launch(
                                                    chunk['texto'],
                                                    forceSafariVC: false,
                                                    forceWebView: false,
                                                  );
                                                } else {
                                                  throw 'Could not launch ${chunk['texto']}';
                                                }
                                              }),
                                      ),
                                    )
                                    .toList(),
                              ),
                            ),
                          ),
                        if (_content.introduccion != null &&
                            _content.introduccion.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 15,
                              top: 15,
                              right: 15,
                              bottom: 25,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Text(
                                  "INTRODUCCIÓN:",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                // Text(
                                //   "${_content.introduccion}",
                                //   textAlign: TextAlign.justify,
                                // ),
                                RichText(
                                  textAlign: TextAlign.justify,
                                  text: TextSpan(
                                    children: _parseTexto(_content.introduccion)
                                        .map(
                                          (chunk) => TextSpan(
                                            text: chunk['texto'],
                                            style: chunk['tipo'] != 'link'
                                                ? TextStyle(
                                                    color: Theme.of(context)
                                                        .textTheme
                                                        .body1
                                                        .color)
                                                : TextStyle(color: Colors.blue),
                                            recognizer: chunk['tipo'] != 'link'
                                                ? null
                                                : (TapGestureRecognizer()
                                                  ..onTap = () async {
                                                    if (await canLaunch(
                                                        chunk['texto'])) {
                                                      await launch(
                                                        chunk['texto'],
                                                        forceSafariVC: false,
                                                        forceWebView: false,
                                                      );
                                                    } else {
                                                      throw 'Could not launch ${chunk['texto']}';
                                                    }
                                                  }),
                                          ),
                                        )
                                        .toList(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        if (_content.ingredientes != null &&
                            _content.ingredientes.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 15,
                              top: 15,
                              right: 15,
                              bottom: 25,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Text(
                                  "INGREDIENTES:",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                // Text(
                                //   "${_content.ingredientes}",
                                //   textAlign: TextAlign.justify,
                                // ),
                                RichText(
                                  textAlign: TextAlign.justify,
                                  text: TextSpan(
                                    children: _parseTexto(_content.ingredientes)
                                        .map(
                                          (chunk) => TextSpan(
                                            text: chunk['texto'],
                                            style: chunk['tipo'] != 'link'
                                                ? TextStyle(
                                                    color: Theme.of(context)
                                                        .textTheme
                                                        .body1
                                                        .color)
                                                : TextStyle(color: Colors.blue),
                                            recognizer: chunk['tipo'] != 'link'
                                                ? null
                                                : (TapGestureRecognizer()
                                                  ..onTap = () async {
                                                    if (await canLaunch(
                                                        chunk['texto'])) {
                                                      await launch(
                                                        chunk['texto'],
                                                        forceSafariVC: false,
                                                        forceWebView: false,
                                                      );
                                                    } else {
                                                      throw 'Could not launch ${chunk['texto']}';
                                                    }
                                                  }),
                                          ),
                                        )
                                        .toList(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        if (_content.instrucciones != null &&
                            _content.instrucciones.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 15,
                              top: 15,
                              right: 15,
                              bottom: 25,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Text(
                                  "INSTRUCCIONES:",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                // Text(
                                //   "${_content.instrucciones}",
                                //   textAlign: TextAlign.justify,
                                // ),
                                RichText(
                                  textAlign: TextAlign.justify,
                                  text: TextSpan(
                                    children: _parseTexto(
                                            _content.instrucciones)
                                        .map(
                                          (chunk) => TextSpan(
                                            text: chunk['texto'],
                                            style: chunk['tipo'] != 'link'
                                                ? TextStyle(
                                                    color: Theme.of(context)
                                                        .textTheme
                                                        .body1
                                                        .color)
                                                : TextStyle(color: Colors.blue),
                                            recognizer: chunk['tipo'] != 'link'
                                                ? null
                                                : (TapGestureRecognizer()
                                                  ..onTap = () async {
                                                    if (await canLaunch(
                                                        chunk['texto'])) {
                                                      await launch(
                                                        chunk['texto'],
                                                        forceSafariVC: false,
                                                        forceWebView: false,
                                                      );
                                                    } else {
                                                      throw 'Could not launch ${chunk['texto']}';
                                                    }
                                                  }),
                                          ),
                                        )
                                        .toList(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: 250,
                          color: Colors.black,
                          child: _content.imagenes == null ||
                                  _content.imagenes.length == 0
                              ? Center(
                                  child: Text(
                                    "No hay imágenes",
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                )
                              : ImageSlider(
                                  images: _content.imagenes,
                                  videoThumbs: _content.videoThumbs,
                                ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [1, 2, 3, 4, 5]
                              .map(
                                (p) => IconButton(
                                  onPressed: () async {
                                    await Fetcher.put(
                                      url: "$_url/${_content.id}/puntuar.json",
                                      body: {
                                        "puntaje": p,
                                      },
                                    );
                                    _fetchContent();
                                  },
                                  icon: Icon(
                                    _content.puntajePromedio >= p
                                        ? Icons.star
                                        : _content.puntajePromedio > p - 1
                                            ? Icons.star_half
                                            : Icons.star_border,
                                    color: Colors.amber,
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      "${_content.puntajePromedio.toStringAsFixed(1)}",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 7,
                                    ),
                                    Text(
                                      "( ${_content.puntajes.length} ",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                    Icon(
                                      Icons.person,
                                      size: 20,
                                    ),
                                    Text(
                                      " )",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 45,
                                ),
                                CircleAvatar(
                                  radius: 50,
                                  backgroundImage: _content.user != null &&
                                          _content.user.avatar != null
                                      ? CachedNetworkImageProvider(
                                          "${MyGlobals.SERVER_URL}${_content.user.avatar}",
                                        )
                                      : null,
                                ),
                                if (_content.user != null)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 15),
                                    child: Text(
                                      _content.user.username != null
                                          ? "@${_content.user.username}"
                                          : _content.user.nombre != null &&
                                                  _content.user.apellido != null
                                              ? "${_content.user.nombre} ${_content.user.apellido}"
                                              : _content.user.email,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                        if (_content.type != SectionType.pois)
                          ComentariosSection(
                            content: _content,
                            fetchContent: _fetchContent,
                          ),
                        SizedBox(
                          height: 50,
                        ),
                      ],
                    ),
        ),
      ),
    );
  }
}
