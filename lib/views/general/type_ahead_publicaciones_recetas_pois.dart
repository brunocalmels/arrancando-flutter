import 'dart:async';
import 'dart:convert';

import 'package:arrancando/config/globals/enums.dart';
import 'package:arrancando/config/models/content_wrapper.dart';
import 'package:arrancando/config/services/fetcher.dart';
import 'package:flutter/material.dart';

class TypeAheadPublicacionesRecetasPois extends StatefulWidget {
  @override
  _TypeAheadPublicacionesRecetasPoisState createState() =>
      _TypeAheadPublicacionesRecetasPoisState();
}

class _TypeAheadPublicacionesRecetasPoisState
    extends State<TypeAheadPublicacionesRecetasPois> {
  List<ContentWrapper> _items;
  final TextEditingController _searchController = TextEditingController();
  Timer _debounce;
  bool _searching = false;

  _fetchResults() async {
    if (_searchController.text != null && _searchController.text.length >= 3) {
      ResponseObject resp = await Fetcher.get(
        url:
            "/publicaciones.json?filterrific[search_query]=${_searchController.text}",
      );
      ResponseObject resp2 = await Fetcher.get(
        url:
            "/recetas.json?filterrific[search_query]=${_searchController.text}",
      );
      ResponseObject resp3 = await Fetcher.get(
        url: "/pois.json?filterrific[search_query]=${_searchController.text}",
      );

      _items = [];

      if (resp != null && resp.body != null) {
        _items = [
          ..._items,
          ...(json.decode(resp.body) as List).map(
            (c) {
              ContentWrapper wrapper = ContentWrapper.fromJson(c);
              wrapper.type = SectionType.publicaciones;
              return wrapper;
            },
          ).toList()
        ];
      }
      if (resp2 != null && resp2.body != null) {
        _items = [
          ..._items,
          ...(json.decode(resp2.body) as List).map(
            (c) {
              ContentWrapper wrapper = ContentWrapper.fromJson(c);
              wrapper.type = SectionType.recetas;
              return wrapper;
            },
          ).toList()
        ];
      }
      if (resp3 != null && resp3.body != null) {
        _items = [
          ..._items,
          ...(json.decode(resp3.body) as List).map(
            (c) {
              ContentWrapper wrapper = ContentWrapper.fromJson(c);
              wrapper.type = SectionType.pois;
              return wrapper;
            },
          ).toList()
        ];
      }
    }

    _searching = false;

    if (mounted) setState(() {});
  }

  _searchTerm(text) {
    if (text != null && text.isNotEmpty && text.length >= 3) {
      _searching = true;
      if (mounted) setState(() {});
      if (_debounce?.isActive ?? false) _debounce.cancel();
      _debounce = Timer(const Duration(milliseconds: 1000), _fetchResults);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        "Buscar publicación/receta/p. interés para añadir link",
        style: TextStyle(
          fontSize: 13,
        ),
        textAlign: TextAlign.center,
      ),
      content: Container(
        height: 150,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  TextField(
                    decoration: InputDecoration(
                      hintText: "Buscar",
                    ),
                    controller: _searchController,
                    onChanged: _searchTerm,
                  ),
                  if (_searching)
                    Positioned(
                      top: 20,
                      right: 5,
                      child: SizedBox(
                        width: 15,
                        height: 15,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      ),
                    ),
                ],
              ),
              if (_items == null)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Text(
                    'Empezá a escribir para buscar',
                    style: TextStyle(
                      fontSize: 13,
                    ),
                  ),
                ),
              if (_items != null && _items.length > 0)
                Container(
                  color: Colors.black12.withAlpha(9),
                  height: 220,
                  child: Builder(
                    builder: (context) => SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: _items
                            .map(
                              (item) => ListTile(
                                title: Text(
                                  item.titulo,
                                  style: TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                                onTap: () {
                                  Navigator.of(context).pop(item);
                                },
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  ),
                ),
              if (_items != null && _items.length == 0)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Text(
                    'No hay coincidencias',
                    style: TextStyle(
                      fontSize: 13,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text("Cancelar"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
