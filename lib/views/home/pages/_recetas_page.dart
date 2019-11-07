import 'dart:convert';

import 'package:arrancando/config/globals/enums.dart';
import 'package:arrancando/config/globals/index.dart';
import 'package:arrancando/config/models/receta.dart';
import 'package:arrancando/config/services/fetcher.dart';
import 'package:arrancando/config/state/index.dart';
import 'package:arrancando/views/cards/card_receta.dart';
import 'package:arrancando/views/home/pages/_loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RecetasPage extends StatefulWidget {
  final String searchTerm;

  RecetasPage({
    this.searchTerm,
  });

  @override
  _RecetasPageState createState() => _RecetasPageState();
}

class _RecetasPageState extends State<RecetasPage> {
  List<Receta> _recetas;
  bool _fetching = true;

  Future<void> _fetchRecetas() async {
    // if (mounted)
    //   setState(() {
    //     _fetching = true;
    //   });

    int categoriaRecetaId = Provider.of<MyState>(context, listen: false)
                .selectedCategoryHome[SectionType.recetas] !=
            null
        ? Provider.of<MyState>(context, listen: false)
            .selectedCategoryHome[SectionType.recetas]
        : Provider.of<MyState>(context, listen: false)
            .preferredCategories[SectionType.recetas];

    ResponseObject resp = await Fetcher.get(
      url: widget.searchTerm != null && widget.searchTerm.isNotEmpty
          ? "/recetas/search.json?term=${widget.searchTerm}"
          : "/recetas.json${categoriaRecetaId != null ? '?categoria_receta_id=' + "$categoriaRecetaId" : ''}",
    );

    if (resp != null)
      _recetas = (json.decode(resp.body) as List)
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
            (r) => Receta.fromJson(r),
          )
          .toList();

    _fetching = false;
    if (mounted) setState(() {});
  }

  _changeListener() {
    if (Provider.of<MyState>(context, listen: false)
            .selectedCategoryHome[SectionType.recetas] !=
        null) _fetchRecetas();
  }

  @override
  void initState() {
    super.initState();
    _fetchRecetas();
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
        : _recetas != null
            ? _recetas.length > 0
                ? RefreshIndicator(
                    onRefresh: _fetchRecetas,
                    child: ListView(
                      children: [
                        ..._recetas
                            .map(
                              (r) => CardReceta(
                                receta: r,
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
                : Text("No hay recetas para mostrar")
            : Text("Ocurrió un error");
  }
}
