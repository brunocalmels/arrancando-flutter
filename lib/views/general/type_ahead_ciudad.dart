import 'dart:async';
import 'dart:convert';

import 'package:arrancando/config/globals/enums.dart';
import 'package:arrancando/config/globals/global_singleton.dart';
import 'package:arrancando/config/models/category_wrapper.dart';
import 'package:arrancando/config/services/fetcher.dart';
import 'package:arrancando/config/state/user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TypeAheadCiudad extends StatefulWidget {
  final Function(CategoryWrapper) onItemTap;
  final bool insideProfile;

  TypeAheadCiudad({
    this.onItemTap,
    this.insideProfile = false,
  });

  @override
  _TypeAheadCiudadState createState() => _TypeAheadCiudadState();
}

class _TypeAheadCiudadState extends State<TypeAheadCiudad> {
  List<CategoryWrapper> _items;
  final TextEditingController _searchController = TextEditingController();
  final GlobalSingleton gs = GlobalSingleton();
  Timer _debounce;
  bool _searching = false;

  _fetchResults() async {
    if (_searchController.text != null && _searchController.text.length >= 3) {
      ResponseObject resp = await Fetcher.get(
        url: "/ciudades/search.json?term=${_searchController.text}",
      );

      if (resp != null && resp.body != null) {
        _items = (json.decode(resp.body) as List)
            .map((c) => CategoryWrapper.fromJson(c))
            .toList();
      } else {
        _items = [];
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
                color: Colors.black12.withAlpha(9),
                height: 220,
                child: ListView.builder(
                  itemCount: _items.length,
                  itemBuilder: (context, index) => ListTile(
                    title: Text(
                      _items[index].nombre,
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                    onTap: () async {
                      if (widget.onItemTap != null) {
                        widget.onItemTap(_items[index]);
                        if (widget.insideProfile) {
                          await Fetcher.put(
                            url:
                                "/users/${Provider.of<UserState>(context).activeUser.id}.json",
                            body: {
                              "user": {
                                "ciudad_id": "${_items[index].id}",
                              }
                            },
                          );
                        }
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
            if (!widget.insideProfile)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  FlatButton(
                    onPressed: () {
                      widget.onItemTap(
                        gs.categories[SectionType.publicaciones].first,
                      );
                    },
                    child: Text(
                      'TODAS LAS CIUDADES',
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).accentColor,
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
