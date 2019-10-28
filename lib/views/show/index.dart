import 'dart:convert';

import 'package:arrancando/config/globals/enums.dart';
import 'package:arrancando/config/globals/index.dart';
import 'package:arrancando/config/models/content_wrapper.dart';
import 'package:arrancando/config/services/fetcher.dart';
import 'package:arrancando/views/home/pages/_loading_widget.dart';
import 'package:arrancando/views/show/_image_large.dart';
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

  _fetchContent() async {
    if (mounted)
      setState(() {
        _fetching = true;
      });

    String url;

    switch (widget.type) {
      case SectionType.publicaciones:
        url = "/v2/deportes";
        break;
      case SectionType.recetas:
        url = "/v2/deportes";
        break;
      case SectionType.pois:
        url = "/v2/deportes";
        break;
      default:
        url = "/v2/deportes";
    }

    ResponseObject resp = await Fetcher.get(
      url: "$url/${widget.contentId}",
    );

    if (resp != null) {
      dynamic object = [json.decode(resp.body)]
          .map(
            (o) => {
              "id": o['id'],
              "created_at": o['created_at'],
              "titulo": o['nombre'],
              "cuerpo":
                  "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nam imperdiet nulla et aliquam convallis. Proin elementum enim non magna sollicitudin, id sollicitudin dui tincidunt. Aliquam maximus quam lectus, ut tempor dolor rhoncus eu. Donec quis diam lectus. Proin accumsan ac ipsum et congue. Mauris vitae lorem odio. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aenean tincidunt eros at purus ultricies aliquet. Curabitur viverra metus venenatis quam ultricies, sit amet efficitur magna elementum.",
              "imagenes": [
                o["get_icono"],
                o["get_icono"],
                o["get_icono"],
                o["get_icono"],
                o["get_icono"],
                o["get_icono"],
              ],
            },
          )
          .first;
      _content = ContentWrapper.fromOther(object, widget.type);
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
                                Text(
                                  "${_content.titulo}",
                                  style: Theme.of(context).textTheme.title,
                                ),
                                Text("${_content.fecha}"),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text("${_content.cuerpo}"),
                          ],
                        ),
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
                        child: Swiper(
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
