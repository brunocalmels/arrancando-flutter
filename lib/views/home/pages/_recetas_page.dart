import 'dart:convert';

import 'package:arrancando/config/models/receta.dart';
import 'package:arrancando/config/services/fetcher.dart';
import 'package:arrancando/views/cards/card_receta.dart';
import 'package:arrancando/views/home/pages/_loading_widget.dart';
import 'package:flutter/material.dart';

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
  bool _fetching = false;

  _fetchRecetas() async {
    if (mounted)
      setState(() {
        _fetching = true;
      });

    ResponseObject resp = await Fetcher.get(
      url: widget.searchTerm != null && widget.searchTerm.isNotEmpty
          ? "/v2/deportes/search/${widget.searchTerm}"
          : "/v2/deportes",
    );

    if (resp != null)
      _recetas = (json.decode(resp.body) as List)
          // REMOVE THIS PART
          .map(
            (r) => {
              "id": r['id'],
              "created_at": r['created_at'],
              "titulo": r['nombre'],
              "cuerpo":
                  "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nam imperdiet nulla et aliquam convallis. Proin elementum enim non magna sollicitudin, id sollicitudin dui tincidunt. Aliquam maximus quam lectus, ut tempor dolor rhoncus eu. Donec quis diam lectus. Proin accumsan ac ipsum et congue. Mauris vitae lorem odio. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aenean tincidunt eros at purus ultricies aliquet. Curabitur viverra metus venenatis quam ultricies, sit amet efficitur magna elementum.",
              "imagenes": [r["get_icono"]],
            },
          )
          // REMOVE THIS PART
          .map(
            (r) => Receta.fromJson(r),
          )
          .toList();

    _fetching = false;
    if (mounted) setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _fetchRecetas();
  }

  @override
  Widget build(BuildContext context) {
    return _fetching
        ? LoadingWidget()
        : _recetas != null
            ? _recetas.length > 0
                ? Column(
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
                  )
                : Text("No hay recetas para mostrar")
            : Text("Ocurrió un error");
  }
}
