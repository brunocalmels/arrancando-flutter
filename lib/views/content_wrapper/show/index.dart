import 'dart:convert';

import 'package:arrancando/config/globals/enums.dart';
import 'package:arrancando/config/globals/global_singleton.dart';
import 'package:arrancando/config/globals/index.dart';
import 'package:arrancando/config/models/content_wrapper.dart';
import 'package:arrancando/config/models/saved_content.dart';
import 'package:arrancando/config/services/fetcher.dart';
import 'package:arrancando/views/content_wrapper/dialog/share.dart';
import 'package:arrancando/views/content_wrapper/edit/index.dart';
import 'package:arrancando/views/content_wrapper/show/_comentarios_section.dart';
import 'package:arrancando/views/content_wrapper/show/_image_slider.dart';
import 'package:arrancando/views/home/pages/_loading_widget.dart';
import 'package:arrancando/views/home/pages/_pois_map.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

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
  ContentWrapper _content;
  bool _fetching = true;
  String _url;
  final GlobalSingleton gs = GlobalSingleton();

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
  }

  @override
  void initState() {
    super.initState();
    _fetchContent();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        actions: <Widget>[
          if (_content != null && _content.esOwner(context))
            IconButton(
              onPressed: () async {
                await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => EditPage(
                      contentId: _content.id,
                      type: _content.type,
                    ),
                  ),
                );
                await Future.delayed(Duration(seconds: 1));
                _fetchContent();
              },
              icon: Icon(Icons.edit),
            ),
          if (_content != null)
            IconButton(
              onPressed: () => SavedContent.toggleSave(_content, context),
              icon: Icon(
                SavedContent.isSaved(_content, context)
                    ? Icons.bookmark
                    : Icons.bookmark_border,
              ),
            ),
          IconButton(
            onPressed: _content == null
                ? null
                : () {
                    showDialog(
                      context: context,
                      builder: (_) => ShareContentWrapper(
                        content: _content,
                      ),
                    );
                  },
            icon: Icon(Icons.share),
          ),
        ],
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
                      children: <Widget>[
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
                                  Text(gs.categories[_content.type]
                                      .firstWhere(
                                          (c) => c.id == _content.categID)
                                      .nombre)
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
                        Padding(
                          padding: const EdgeInsets.all(15),
                          child: Text("${_content.cuerpo}"),
                        ),
                        SizedBox(
                          height: 10,
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
                        Text(
                          "${_content.puntajePromedio.toStringAsFixed(1)}",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
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
