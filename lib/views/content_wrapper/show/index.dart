import 'dart:convert';

import 'package:arrancando/config/globals/enums.dart';
import 'package:arrancando/config/globals/global_singleton.dart';
import 'package:arrancando/config/models/category_wrapper.dart';
import 'package:arrancando/config/models/content_wrapper.dart';
import 'package:arrancando/config/services/fetcher.dart';
import 'package:arrancando/views/content_wrapper/show/_row_iconos_fecha.dart';
import 'package:arrancando/views/content_wrapper/show/_show_app_bar.dart';
import 'package:arrancando/views/content_wrapper/show/cabecera/index.dart';
import 'package:arrancando/views/content_wrapper/show/comentarios/index.dart';
import 'package:arrancando/views/content_wrapper/show/images_slider/index.dart';
import 'package:arrancando/views/content_wrapper/show/textos/index.dart';
import 'package:arrancando/views/home/pages/_loading_widget.dart';
import 'package:arrancando/views/home/pages/_pois_map.dart';
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
  final GlobalSingleton gs = GlobalSingleton();
  ContentWrapper _content;
  bool _fetching = true;
  String _url;
  String _categoryName = "";

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
      if (mounted) setState(() {});
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
                          fetchContent: _fetchContent,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        ImagesSlider(
                          images: _content.imagenes,
                          videoThumbs: _content.videoThumbs,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        if (widget.type == SectionType.pois &&
                            _content.latitud != null &&
                            _content.longitud != null)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: PoisMap(
                              height: 200,
                              latitud: _content.latitud,
                              longitud: _content.longitud,
                              zoom: 15,
                            ),
                          ),
                        TextosShow(
                          content: _content,
                        ),
                        RowIconosFecha(
                          content: _content,
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
