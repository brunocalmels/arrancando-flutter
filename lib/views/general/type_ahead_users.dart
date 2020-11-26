import 'dart:async';
import 'dart:convert';

import 'package:arrancando/config/globals/index.dart';
import 'package:arrancando/config/models/usuario.dart';
import 'package:arrancando/config/services/fetcher.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class TypeAheadUsers extends StatefulWidget {
  @override
  _TypeAheadUsersState createState() => _TypeAheadUsersState();
}

class _TypeAheadUsersState extends State<TypeAheadUsers> {
  List<Usuario> _items;
  final TextEditingController _searchController = TextEditingController();
  Timer _debounce;
  bool _searching = false;

  Future<void> _fetchResults() async {
    if (_searchController.text != null && _searchController.text.length >= 3) {
      final resp = await Fetcher.get(
        url: '/users/usernames.json?search=${_searchController.text}',
      );

      _items = [];

      if (resp != null && resp.body != null) {
        _items = [
          ..._items,
          ...(json.decode(resp.body) as List)
              .map((c) => Usuario.fromJson(c))
              .toList()
        ];
      }
    }

    _searching = false;

    if (mounted) setState(() {});
  }

  void _searchTerm(text) {
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
        'Buscar nombres de usuario para añadir link',
        style: TextStyle(
          fontSize: 13,
        ),
        textAlign: TextAlign.center,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
      content: Container(
        height: 180,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Buscar',
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
              if (_items != null && _items.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(7),
                  child: Text(
                    '(${_items.length} items)',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 10,
                    ),
                  ),
                ),
              if (_items != null && _items.isNotEmpty)
                Container(
                  color: Colors.black12.withAlpha(9),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: _items
                        .map(
                          (item) => Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                Navigator.of(context).pop(item);
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 5),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    CircleAvatar(
                                      radius: 20,
                                      backgroundImage:
                                          item != null && item.avatar != null
                                              ? CachedNetworkImageProvider(
                                                  '${MyGlobals.SERVER_URL}${item.avatar}',
                                                )
                                              : null,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                      child: Text(
                                        '@${item.username}',
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
              if (_items != null && _items.isEmpty)
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
          child: Text('Cancelar'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
