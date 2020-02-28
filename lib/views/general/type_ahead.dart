import 'dart:async';
import 'dart:convert';

import 'package:arrancando/config/models/category_wrapper.dart';
import 'package:arrancando/config/services/fetcher.dart';
import 'package:flutter/material.dart';

class TypeAhead extends StatefulWidget {
  @override
  _TypeAheadState createState() => _TypeAheadState();
}

class _TypeAheadState extends State<TypeAhead> {
  List<CategoryWrapper> _items;
  final TextEditingController _searchController = TextEditingController();
  Timer _debounce;

  _fetchResults() async {
    ResponseObject resp = await Fetcher.get(
      url: "/ciudades.json",
    );

    _items = (json.decode(resp.body) as List)
        .map((c) => CategoryWrapper.fromJson(c))
        .where((c) => c.nombre
            .toLowerCase()
            .contains(_searchController.text.toLowerCase()))
        .toList();

    if (mounted) setState(() {});
  }

  _searchTerm(text) {
    if (text != null && text.isNotEmpty && text.length >= 3) {
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
            TextField(
              decoration: InputDecoration(
                hintText: "Buscar",
              ),
              controller: _searchController,
              onChanged: _searchTerm,
            ),
            if (_items == null)
              Container(
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
                height: 150,
                child: ListView.builder(
                  itemCount: _items.length,
                  itemBuilder: (context, index) => ListTile(
                    title: Text(
                      _items[index].nombre,
                    ),
                    onTap: () {},
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
