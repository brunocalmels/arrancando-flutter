import 'dart:convert';

import 'package:arrancando/config/globals/enums.dart';
import 'package:arrancando/config/globals/index.dart';
import 'package:arrancando/config/models/content_wrapper.dart';
import 'package:arrancando/config/services/fetcher.dart';
import 'package:arrancando/views/content_wrapper/show/_image_large.dart';
import 'package:arrancando/views/home/pages/_loading_widget.dart';
import 'package:arrancando/views/home/pages/_pois_map.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

class ShowPage extends StatefulWidget {
  final int contentId;
  final SectionType type;

  ShowPage({
    this.contentId,
    this.type,
  });

  @override
  _ShowPageState createState() => _ShowPageState();
}

class _ShowPageState extends State<ShowPage> {
  ContentWrapper _content;
  bool _fetching = true;
  String _url;

  _fetchContent() async {
    if (mounted)
      // setState(() {
      //   _fetching = true;
      // });

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
      dynamic object = [json.decode(resp.body)]
          .map(
            (o) => json.decode(json.encode({
              ...o,
              "imagenes": [
                "http://yesofcorsa.com/wp-content/uploads/2017/05/Chop-Meat-Wallpaper-Download-Free-1024x682.jpg"
              ],
            })),
          )
          .first;
      _content = ContentWrapper.fromOther(json.decode(resp.body), widget.type);
      // _content = ContentWrapper.fromOther(object, widget.type);
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
          IconButton(
            onPressed: () {
              print(
                  "/${_content.type.toString().split('.').last}/${_content.id}");
            },
            icon: Icon(Icons.share),
          )
        ],
      ),
      body: SingleChildScrollView(
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
                                Icon(
                                    MyGlobals.ICONOS_CATEGORIAS[_content.type]),
                                Text(" / "),
                                Text("Neuquén")
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Expanded(
                                  child: Text(
                                    "${_content.titulo}",
                                    style: Theme.of(context).textTheme.title,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Text("${_content.fecha}"),
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
                        // child: ListView.builder(
                        //   itemCount: _content.imagenes.length,
                        //   scrollDirection: Axis.horizontal,
                        // itemBuilder: (BuildContext context, int index) {
                        //   return Image.network(
                        //       "${MyGlobals.SERVER_URL}${_content.imagenes[index]}");
                        // },
                        // ),
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
                            : Swiper(
                                itemCount: _content.imagenes.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Hero(
                                    tag: "${_content.imagenes[index]}-$index",
                                    child: Stack(
                                      fit: StackFit.passthrough,
                                      children: <Widget>[
                                        Image.network(
                                          "${MyGlobals.SERVER_URL}${_content.imagenes[index]}",
                                        ),
                                        Positioned(
                                          child: Material(
                                            color: Colors.transparent,
                                            child: InkWell(
                                              onTap: () {
                                                Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                    builder: (_) => ImageLarge(
                                                      tag:
                                                          "${_content.imagenes[index]}-$index",
                                                      url:
                                                          // "${_content.imagenes[index]}",
                                                          "${MyGlobals.SERVER_URL}${_content.imagenes[index]}",
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                pagination: SwiperPagination(),
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
                                  _content.puntajePromedio > p
                                      ? _content.puntajePromedio < p + 1
                                          ? Icons.star_half
                                          : Icons.star
                                      : _content.puntajePromedio == p
                                          ? Icons.star
                                          : Icons.star_border,
                                  color: Colors.amber,
                                ),
                              ),
                            )
                            .toList(),
                      ),
                      SizedBox(
                        height: 50,
                      ),
                    ],
                  ),
      ),
    );
  }
}

// PhotoViewGallery.builder(
//   scrollPhysics: const BouncingScrollPhysics(),
//   builder: (BuildContext context, int index) {
//     return PhotoViewGalleryPageOptions(
//       imageProvider: NetworkImage(
//           "${MyGlobals.SERVER_URL}${_content.imagenes[index]}"),
//       initialScale:
//           PhotoViewComputedScale.contained * 0.8,
//       // heroAttributes:
//       //     HeroAttributes(tag: "$index"),
//     );
//   },
//   itemCount: _content.imagenes.length,
//   loadingChild: CircularProgressIndicator(),
//   // backgroundDecoration: widget.backgroundDecoration,
//   // pageController: widget.pageController,
//   // onPageChanged: onPageChanged,
// ),
