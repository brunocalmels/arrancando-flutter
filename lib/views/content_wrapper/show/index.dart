import 'dart:convert';

import 'package:arrancando/config/fonts/arrancando_icons_icons.dart';
import 'package:arrancando/config/globals/enums.dart';
import 'package:arrancando/config/globals/global_singleton.dart';
import 'package:arrancando/config/models/category_wrapper.dart';
import 'package:arrancando/config/models/content_wrapper.dart';
import 'package:arrancando/config/services/fetcher.dart';
import 'package:arrancando/views/content_wrapper/show/_row_iconos_fecha.dart';
import 'package:arrancando/views/content_wrapper/show/_show_app_bar.dart';
import 'package:arrancando/views/content_wrapper/show/cabecera/_row_estrellas.dart';
import 'package:arrancando/views/content_wrapper/show/cabecera/index.dart';
import 'package:arrancando/views/content_wrapper/show/comentarios/index.dart';
import 'package:arrancando/views/content_wrapper/show/images_slider/index.dart';
import 'package:arrancando/views/content_wrapper/show/textos/index.dart';
import 'package:arrancando/views/home/pages/_loading_widget.dart';
import 'package:arrancando/views/home/pages/_pois_map.dart';
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

    _content.comentarios
        .sort((c1, c2) => c1.createdAt.isBefore(c2.createdAt) ? -1 : 1);

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

  List<String> _reorderImages() {
    if (_content != null &&
        _content.imagenes != null &&
        _content.imagenes.isNotEmpty) {
      if (_content.imagenes.length > 1) {
        var newList = [..._content.imagenes];
        var aux = newList.removeAt(0);
        newList.insert(1, aux);
        return [...newList];
      }
      return _content.imagenes;
    }
    return [];
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
                          images: _reorderImages(),
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
                        if (widget.type == SectionType.pois &&
                            _content.whatsapp != null &&
                            _content.whatsapp.toString().isNotEmpty &&
                            _content.whatsapp.toString().length > 4)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Material(
                                      type: MaterialType.circle,
                                      color: Color(0xff1bd741),
                                      child: IconButton(
                                        icon: Icon(
                                          ArrancandoIcons.whatsapp,
                                          color: Colors.white,
                                        ),
                                        onPressed: () async {
                                          String url =
                                              "https://api.whatsapp.com/send?phone=${_content.whatsapp}&text=Hola%2C%20los%20vi%20en%20Arrancando%20y%20quer%C3%ADa%20comunicarme%20directamente%20con%20ustedes.";
                                          if (await canLaunch(url)) {
                                            await launch(
                                              url,
                                              forceSafariVC: false,
                                              forceWebView: false,
                                            );
                                          } else {
                                            throw 'Could not launch $url';
                                          }
                                        },
                                      ),
                                    ),
                                    SizedBox(height: 7),
                                    Text(
                                      "WHATSAPP",
                                      style: TextStyle(
                                        fontSize: 9,
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        Padding(
                          padding: const EdgeInsets.all(15),
                          child: Center(
                            child: RowEstrellas(
                              content: _content,
                              fetchContent: _fetchContent,
                            ),
                          ),
                        ),
                        RowIconosFecha(
                          content: _content,
                          fetchContent: _fetchContent,
                        ),
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
