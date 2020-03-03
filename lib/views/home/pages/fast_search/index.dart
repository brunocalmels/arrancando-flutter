import 'dart:async';
import 'dart:convert';

import 'package:arrancando/config/globals/enums.dart';
import 'package:arrancando/config/globals/index.dart';
import 'package:arrancando/config/models/content_wrapper.dart';
import 'package:arrancando/config/services/fetcher.dart';
import 'package:arrancando/views/home/pages/fast_search/_data_group.dart';
import 'package:flutter/material.dart';

class FastSearchPage extends StatefulWidget {
  final TextEditingController searchController;

  FastSearchPage({
    this.searchController,
  });

  @override
  _FastSearchPageState createState() => _FastSearchPageState();
}

class _FastSearchPageState extends State<FastSearchPage> {
  Map<String, List<ContentWrapper>> _items = {
    "publicaciones": [],
    "recetas": [],
    "pois": [],
  };
  Timer _debounce;

  Map<String, bool> _fetching = {
    "publicaciones": false,
    "recetas": false,
    "pois": false,
  };

  _fetchContent(String type) async {
    if (mounted)
      setState(() {
        _fetching[type] = true;
      });

    ResponseObject resp = await Fetcher.get(
      url: widget.searchController.text != null &&
              widget.searchController.text.isNotEmpty
          ? "/$type/search.json?term=${widget.searchController.text}&limit=3"
          : "/$type.json",
    );

    if (resp != null)
      _items[type] = (json.decode(resp.body) as List)
          .map(
            (c) => ContentWrapper.fromJson(c),
          )
          .toList();

    _fetching[type] = false;
    if (mounted) setState(() {});
  }

  _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce.cancel();
    _debounce = Timer(const Duration(milliseconds: 1000), () {
      if (widget.searchController.text.isNotEmpty) {
        _fetchContent("publicaciones");
        _fetchContent("recetas");
        _fetchContent("pois");
      }
    });
  }

  @override
  void initState() {
    super.initState();
    widget.searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    widget.searchController.removeListener(_onSearchChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        await _fetchContent("publicaciones");
        await _fetchContent("recetas");
        await _fetchContent("pois");
      },
      child: widget.searchController == null ||
              widget.searchController.text == null ||
              widget.searchController.text == ""
          ? Container(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: Text('Comenzá a escribir para buscar'),
                ),
              ),
            )
          : ListView(
              children: <Widget>[
                DataGroup(
                  fetching: _fetching["publicaciones"],
                  icon: MyGlobals.ICONOS_CATEGORIAS[SectionType.publicaciones],
                  title: "Publicaciones",
                  items: _items["publicaciones"],
                  type: SectionType.publicaciones,
                  searchController: widget.searchController,
                ),
                DataGroup(
                  fetching: _fetching["recetas"],
                  icon: MyGlobals.ICONOS_CATEGORIAS[SectionType.recetas],
                  title: "Recetas",
                  items: _items["recetas"],
                  type: SectionType.recetas,
                  searchController: widget.searchController,
                ),
                DataGroup(
                  fetching: _fetching["pois"],
                  icon: MyGlobals.ICONOS_CATEGORIAS[SectionType.pois],
                  title: "Ptos. Interés",
                  items: _items["pois"],
                  type: SectionType.pois,
                  searchController: widget.searchController,
                ),
                Container(
                  height: 130,
                  color: Color(0x05000000),
                ),
              ],
            ),
    );
  }
}
