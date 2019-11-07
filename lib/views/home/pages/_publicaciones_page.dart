import 'dart:convert';

import 'package:arrancando/config/globals/enums.dart';
import 'package:arrancando/config/globals/index.dart';
import 'package:arrancando/config/models/publicacion.dart';
import 'package:arrancando/config/services/fetcher.dart';
import 'package:arrancando/config/state/index.dart';
import 'package:arrancando/views/cards/card_publicacion.dart';
import 'package:arrancando/views/home/pages/_loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PublicacionesPage extends StatefulWidget {
  final String searchTerm;

  PublicacionesPage({
    this.searchTerm,
  });

  @override
  _PublicacionesPageState createState() => _PublicacionesPageState();
}

class _PublicacionesPageState extends State<PublicacionesPage> {
  List<Publicacion> _publicaciones;
  bool _fetching = true;

  Future<void> _fetchPublicaciones() async {
    // if (mounted)
    // setState(() {
    //   _fetching = true;
    // });

    int ciudadId = Provider.of<MyState>(context, listen: false)
                .selectedCategoryHome[SectionType.publicaciones] !=
            null
        ? Provider.of<MyState>(context, listen: false)
            .selectedCategoryHome[SectionType.publicaciones]
        : Provider.of<MyState>(context, listen: false)
            .preferredCategories[SectionType.publicaciones];

    ResponseObject resp = await Fetcher.get(
      url: widget.searchTerm != null && widget.searchTerm.isNotEmpty
          ? "/publicaciones/search.json?term=${widget.searchTerm}"
          : "/publicaciones.json${ciudadId != null ? '?ciudad_id=' + "$ciudadId" : ''}",
    );

    if (resp != null)
      _publicaciones = (json.decode(resp.body) as List)
          // // REMOVE THIS PART
          // .map(
          //   (p) => json.decode(json.encode({
          //     ...p,
          //     "imagenes": [
          //       "http://yesofcorsa.com/wp-content/uploads/2017/05/Chop-Meat-Wallpaper-Download-Free-1024x682.jpg"
          //     ],
          //   })),
          // )
          // // REMOVE THIS PART
          .map(
            (p) => Publicacion.fromJson(p),
          )
          .toList();

    _fetching = false;
    if (mounted) setState(() {});
  }

  _changeListener() {
    if (Provider.of<MyState>(context, listen: false)
            .selectedCategoryHome[SectionType.publicaciones] !=
        null) _fetchPublicaciones();
  }

  @override
  void initState() {
    super.initState();
    _fetchPublicaciones();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<MyState>(MyGlobals.mainNavigatorKey.currentContext)
          .addListener(_changeListener);
    });
  }

  @override
  void dispose() {
    Provider.of<MyState>(MyGlobals.mainNavigatorKey.currentContext)
        .removeListener(_changeListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _fetching
        ? LoadingWidget()
        : _publicaciones != null
            ? _publicaciones.length > 0
                ? RefreshIndicator(
                    onRefresh: _fetchPublicaciones,
                    child: ListView(
                      children: [
                        ..._publicaciones
                            .map(
                              (p) => CardPublicacion(
                                publicacion: p,
                              ),
                            )
                            .toList(),
                        Container(
                          height: 100,
                          color: Color(0x05000000),
                        ),
                      ],
                    ),
                  )
                : Text("No hay publicaciones para mostrar")
            : Text("Ocurrió un error");
  }
}
