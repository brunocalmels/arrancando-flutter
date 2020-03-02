import 'dart:async';
import 'dart:convert';

import 'package:arrancando/config/models/category_wrapper.dart';
import 'package:arrancando/config/services/fetcher.dart';
import 'package:flutter/material.dart';

class TypeAheadCiudad extends StatefulWidget {
  final Function(CategoryWrapper) onItemTap;

  TypeAheadCiudad({
    this.onItemTap,
  });

  @override
  _TypeAheadCiudadState createState() => _TypeAheadCiudadState();
}

class _TypeAheadCiudadState extends State<TypeAheadCiudad> {
  List<CategoryWrapper> _items;
  final TextEditingController _searchController = TextEditingController();
  Timer _debounce;
  bool _searching = false;

  _fetchResults() async {
    if (_searchController.text != null && _searchController.text.length >= 3) {
      ResponseObject resp = await Fetcher.get(
        url: "/ciudades/search.json?term=${_searchController.text}",
      );

      _items = (json.decode(resp.body) as List)
          .map((c) => CategoryWrapper.fromJson(c))
          .toList();
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
    return Center(
      child: Container(
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
                height: 220,
                child: ListView.builder(
                  itemCount: _items.length,
                  itemBuilder: (context, index) => ListTile(
                    title: Text(
                      _items[index].nombre,
                    ),
                    onTap: () {
                      if (widget.onItemTap != null) {
                        widget.onItemTap(_items[index]);
                      }
                    },
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
    );
  }
}
