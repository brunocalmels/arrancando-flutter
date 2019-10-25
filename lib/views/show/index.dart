import 'dart:convert';

import 'package:arrancando/config/globals/enums.dart';
import 'package:arrancando/config/models/content_wrapper.dart';
import 'package:arrancando/config/services/fetcher.dart';
import 'package:flutter/material.dart';

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
              "imagenes": [o["get_icono"]],
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
      ),
      body: SingleChildScrollView(
        child: _fetching
            ? Center(
                child: CircularProgressIndicator(),
              )
            : _content == null
                ? Container(
                    child: Text("Ocurrió un error"),
                  )
                : Column(
                    children: <Widget>[
                      Text("${_content.id}"),
                      Text("${_content.type}"),
                      Text("${_content.createdAt}"),
                      Text("${_content.updatedAt}"),
                      Text("${_content.titulo}"),
                      Text("${_content.cuerpo}"),
                      Text("${_content.imagenes}"),
                    ],
                  ),
      ),
    );
  }
}
