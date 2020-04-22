import 'dart:convert';

import 'package:arrancando/config/models/subcategoria_receta.dart';
import 'package:arrancando/config/services/fetcher.dart';
import 'package:flutter/material.dart';

class PageSubCategorias extends StatefulWidget {
  final List<SubcategoriaReceta> selectedCategorias;

  PageSubCategorias({
    this.selectedCategorias,
  });

  @override
  _PageSubCategoriasState createState() => _PageSubCategoriasState();
}

class _PageSubCategoriasState extends State<PageSubCategorias> {
  bool _loading = true;
  List<SubcategoriaReceta> _items;
  List<SubcategoriaReceta> _selectedSubcategorias = [];

  _fetchSubcategorias() async {
    if (mounted) setState(() {});

    ResponseObject resp = await Fetcher.get(
      url: "/subcategoria_recetas.json",
    );

    if (resp != null && resp.body != null) {
      _items = (json.decode(resp.body) as List)
          .map((i) => SubcategoriaReceta.fromJson(i))
          .toList();
    } else {
      _items = [];
    }

    _loading = false;
    if (mounted) setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _fetchSubcategorias();
    _selectedSubcategorias = widget.selectedCategorias ?? [];
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "SELECCIONAR SUBCATEGORÍAS",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
      ),
      body: !_loading
          ? _items != null && _items.length > 0
              ? SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ..._items
                          .map(
                            (sc) => CheckboxListTile(
                              title: Text(sc.nombre),
                              value: _selectedSubcategorias.firstWhere(
                                      (c) => c.id == sc.id,
                                      orElse: () => null) !=
                                  null,
                              onChanged: (val) {
                                if (val)
                                  _selectedSubcategorias.add(sc);
                                else
                                  _selectedSubcategorias
                                      .removeWhere((s) => s.id == sc.id);
                                if (mounted) setState(() {});
                              },
                            ),
                          )
                          .toList(),
                      Padding(
                        padding: const EdgeInsets.all(15),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            RaisedButton(
                              color: Theme.of(context).backgroundColor,
                              elevation: 10,
                              child: Text(
                                "LISTO",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              onPressed: () {
                                Navigator.of(context)
                                    .pop(_selectedSubcategorias);
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Text(
                        "Ocurrió un error",
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                )
          : Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
    );
  }
}
