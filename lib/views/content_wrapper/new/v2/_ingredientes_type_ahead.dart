import 'dart:async';
import 'dart:convert';

import 'package:arrancando/config/models/ingrediente.dart';
import 'package:arrancando/config/services/fetcher.dart';
import 'package:arrancando/config/state/main.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class IngredientesTypeAhead extends StatefulWidget {
  final List<dynamic> ingredientes;
  final Function(List<dynamic>) setIngredientes;
  final Function(dynamic) removeIngrediente;

  IngredientesTypeAhead({
    @required this.ingredientes,
    @required this.setIngredientes,
    @required this.removeIngrediente,
  });

  @override
  _IngredientesTypeAheadState createState() => _IngredientesTypeAheadState();
}

class _IngredientesTypeAheadState extends State<IngredientesTypeAhead> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  List<Ingrediente> _items;
  Ingrediente _selected;
  String _unidad;
  String _errorIngred;
  Timer _debounce;
  bool _searching = false;
  List _unidadesIngredientes = [];

  _fetchResults() async {
    if (_searchController.text != null && _searchController.text.length >= 1) {
      ResponseObject resp = await Fetcher.get(
        url:
            "/ingredientes/search.json?filterrific[search_query]=${_searchController.text}",
      );

      if (resp != null && resp.body != null && resp.body.isNotEmpty) {
        _items = (json.decode(resp.body) as List)
            .where((i) => !widget.ingredientes.contains(i['nombre']))
            .map((i) => Ingrediente.fromJson(i))
            .toList();
      } else {
        _items = [];
      }
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

  _agregarNuevoIngrediente({bool cantNecesaria = false}) {
    _errorIngred = null;
    if (_selected != null &&
        _selected.nombre != null &&
        _selected.nombre.isNotEmpty &&
        (cantNecesaria
            ? true
            : _quantityController.text != null &&
                _quantityController.text.isNotEmpty &&
                _unidad != null &&
                _unidad.isNotEmpty)) {
      widget.setIngredientes(
        [
          ...widget.ingredientes,
          {
            "ingrediente": _selected.nombre,
            "cantidad": cantNecesaria ? "" : _quantityController.text,
            "unidad": cantNecesaria ? "Cant. necesaria" : _unidad,
          },
        ],
      );
      _searchController.clear();
      _quantityController.clear();
      _unidad = null;
      _items = null;
      _selected = null;
    } else {
      _errorIngred = "Todos los campos deben estar completos";
    }
    if (mounted) setState(() {});
  }

  _fetchUnidadesIngredientes() async {
    try {
      ResponseObject resp = await Fetcher.get(
        url: "/unidades_ingredientes.json",
      );
      if (resp != null && resp.body != null) {
        _unidadesIngredientes = (json.decode(resp.body) as List);
        if (mounted) setState(() {});
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchUnidadesIngredientes();
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
                color: Color(Provider.of<MainState>(context).activeTheme ==
                        ThemeMode.light
                    ? 0xffcccccc
                    : 0xff1a1c28),
                offset: Offset(0.0, 0.0),
              ),
              BoxShadow(
                color: Color(Provider.of<MainState>(context).activeTheme ==
                        ThemeMode.light
                    ? 0xffeeeeee
                    : 0xff2d3548),
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
        if (_items == null && _selected == null)
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
          Material(
            color: Color(
                Provider.of<MainState>(context).activeTheme == ThemeMode.light
                    ? 0xffcccccc
                    : 0x991a1c28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: _items
                  .map(
                    (item) => Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 0,
                            horizontal: 10,
                          ),
                          title: Text(
                            item.nombre,
                            style: TextStyle(
                              fontSize: 14,
                            ),
                          ),
                          onTap: () {
                            _items = null;
                            _selected = item;
                            if (mounted) setState(() {});
                          },
                        ),
                        Divider(
                          height: 1,
                          color:
                              Theme.of(context).textTheme.body1.color.withAlpha(
                                    100,
                                  ),
                        ),
                      ],
                    ),
                  )
                  .toList(),
            ),
          ),
        if (_items != null &&
            _items.length == 0 &&
            _searchController.text != null &&
            _searchController.text.isNotEmpty)
          Material(
            color: Color(
                Provider.of<MainState>(context).activeTheme == ThemeMode.light
                    ? 0xffcccccc
                    : 0x991a1c28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 0,
                    horizontal: 10,
                  ),
                  title: Text(
                    "No se encontró el ingrediente",
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                  subtitle: Text(
                    "Tocá acá para añadirlo como 'nuevo'",
                    style: TextStyle(
                      fontSize: 10,
                    ),
                  ),
                  onTap: () {
                    _items = null;
                    _selected = Ingrediente(-1, _searchController.text);
                    if (mounted) setState(() {});
                  },
                ),
                Divider(
                  height: 1,
                  color: Theme.of(context).textTheme.body1.color.withAlpha(
                        100,
                      ),
                ),
              ],
            ),
          ),
        if (_selected != null &&
            _searchController.text != null &&
            _searchController.text.isNotEmpty)
          Material(
            color: Color(
                Provider.of<MainState>(context).activeTheme == ThemeMode.light
                    ? 0xffcccccc
                    : 0x991a1c28),
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      _selected.nombre,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(width: 3),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        boxShadow: [
                          BoxShadow(
                            color: Color(
                                Provider.of<MainState>(context).activeTheme ==
                                        ThemeMode.light
                                    ? 0xffcccccc
                                    : 0xff1a1c28),
                            offset: Offset(0.0, 0.0),
                          ),
                          BoxShadow(
                            color: Color(
                                Provider.of<MainState>(context).activeTheme ==
                                        ThemeMode.light
                                    ? 0xffeeeeee
                                    : 0xff2d3548),
                            offset: Offset(0.0, 0.0),
                            spreadRadius: -12.0,
                            blurRadius: 12.0,
                          ),
                        ],
                      ),
                      child: TextFormField(
                        controller: _quantityController,
                        decoration: InputDecoration(
                          hintText: "Cant.",
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 15,
                          ),
                        ),
                        textCapitalization: TextCapitalization.sentences,
                        keyboardType: TextInputType.number,
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 3),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        boxShadow: [
                          BoxShadow(
                            color: Color(
                                Provider.of<MainState>(context).activeTheme ==
                                        ThemeMode.light
                                    ? 0xffcccccc
                                    : 0xff1a1c28),
                            offset: Offset(0.0, 0.0),
                          ),
                          BoxShadow(
                            color: Color(
                                Provider.of<MainState>(context).activeTheme ==
                                        ThemeMode.light
                                    ? 0xffeeeeee
                                    : 0xff2d3548),
                            offset: Offset(0.0, 0.0),
                            spreadRadius: -12.0,
                            blurRadius: 12.0,
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Theme(
                          data: ThemeData(
                            canvasColor: Theme.of(context).backgroundColor,
                            textTheme: Theme.of(context).textTheme,
                          ),
                          child: DropdownButton(
                            isExpanded: true,
                            hint: Text(
                              "Unid",
                              style: TextStyle(
                                fontSize: 10,
                                color: Theme.of(context)
                                    .textTheme
                                    .body1
                                    .color
                                    .withAlpha(150),
                              ),
                            ),
                            value: _unidad,
                            onChanged: _unidadesIngredientes != null &&
                                    _unidadesIngredientes.length > 0
                                ? (val) {
                                    _unidad = val;
                                    if (mounted) setState(() {});
                                  }
                                : null,
                            items: _unidadesIngredientes != null &&
                                    _unidadesIngredientes.length > 0
                                ? _unidadesIngredientes
                                    .map(
                                      (i) => DropdownMenuItem(
                                        value: i,
                                        child: Text(
                                          i,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: 11,
                                          ),
                                        ),
                                      ),
                                    )
                                    .toList()
                                : [],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 3),
                  ButtonTheme(
                    minWidth: 30,
                    child: FlatButton(
                      child: Text(
                        "C/N",
                        style: TextStyle(
                          color: Theme.of(context).accentColor,
                        ),
                      ),
                      onPressed: () => _agregarNuevoIngrediente(
                        cantNecesaria: true,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.check_circle,
                      color: Theme.of(context).accentColor,
                    ),
                    onPressed: _agregarNuevoIngrediente,
                  ),
                ],
              ),
            ),
          ),
        if (_selected != null && _errorIngred != null)
          Padding(
            padding: const EdgeInsets.all(7),
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: Text(
                _errorIngred,
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 11,
                ),
                textAlign: TextAlign.center,
                softWrap: true,
              ),
            ),
          ),
        if (widget.ingredientes != null && widget.ingredientes.length > 0)
          Wrap(
            runSpacing: 5,
            spacing: 5,
            children: <Widget>[
              ...widget.ingredientes
                  .map(
                    (i) => Chip(
                      deleteIconColor: Colors.red,
                      label: Text(
                        i['ingrediente'],
                        style: TextStyle(
                          fontSize: 10,
                        ),
                      ),
                      onDeleted: () => widget.removeIngrediente(i),
                    ),
                  )
                  .toList(),
            ],
          ),
        SizedBox(
          height: 5,
        ),
      ],
    );
  }
}
