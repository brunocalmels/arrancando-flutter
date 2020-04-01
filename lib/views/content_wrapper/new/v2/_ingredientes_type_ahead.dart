import 'dart:async';

import 'package:arrancando/config/globals/index.dart';
import 'package:flutter/material.dart';

class IngredientesTypeAhead extends StatefulWidget {
  final List<String> ingredientes;
  final Function(List<String>) setIngredientes;

  IngredientesTypeAhead({
    @required this.ingredientes,
    @required this.setIngredientes,
  });

  @override
  _IngredientesTypeAheadState createState() => _IngredientesTypeAheadState();
}

class _IngredientesTypeAheadState extends State<IngredientesTypeAhead> {
  List<String> _items;
  final TextEditingController _searchController = TextEditingController();
  Timer _debounce;
  bool _searching = false;

  _fetchResults() async {
    if (_searchController.text != null && _searchController.text.length >= 1) {
      // ResponseObject resp = await Fetcher.get(
      //   url: "/ciudades/search.json?term=${_searchController.text}",
      // );

      // if (resp != null && resp.body != null) {
      //   _items = (json.decode(resp.body) as List)
      //       .map((c) => CategoryWrapper.fromJson(c))
      //       .toList();
      // } else {
      //   _items = [];
      // }
      _items = MyGlobals.INGREDIENTES
          .where((i) =>
              i.toLowerCase().contains(_searchController.text.toLowerCase()))
          .toList();
    }

    _searching = false;

    if (mounted) setState(() {});
  }

  _searchTerm(text) {
    if (text != null && text.isNotEmpty && text.length >= 1) {
      _searching = true;
      if (mounted) setState(() {});
      if (_debounce?.isActive ?? false) _debounce.cancel();
      _debounce = Timer(const Duration(milliseconds: 1000), _fetchResults);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(
          "Ingredientes",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.white70,
          ),
        ),
        SizedBox(
          height: 5,
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.transparent,
            boxShadow: [
              BoxShadow(
                color: Color(0xff1a1c28),
                offset: Offset(0.0, 0.0),
              ),
              BoxShadow(
                color: Color(0xff2d3548),
                offset: Offset(0.0, 0.0),
                spreadRadius: -12.0,
                blurRadius: 12.0,
              ),
            ],
          ),
          child: Stack(
            children: <Widget>[
              TextFormField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: "Papas, Batatas, ...",
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 12,
                  ),
                ),
                onChanged: _searchTerm,
                textCapitalization: TextCapitalization.sentences,
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
              if (_searching)
                Positioned(
                  top: 15,
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
          ..._items
              .map(
                (item) => ListTile(
                  title: Text(
                    item,
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                  onTap: () {
                    widget.setIngredientes(
                      [...widget.ingredientes, item],
                    );
                    _searchController.clear();
                  },
                ),
              )
              .toList(),
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
        if (widget.ingredientes != null && widget.ingredientes.length > 0)
          ...widget.ingredientes.map((i) => Text(i)).toList(),
        SizedBox(
          height: 5,
        ),
      ],
    );
  }
}
