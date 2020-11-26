import 'dart:async';
import 'dart:convert';

import 'package:arrancando/config/globals/enums.dart';
import 'package:arrancando/config/globals/index.dart';
import 'package:arrancando/config/models/content_wrapper.dart';
import 'package:arrancando/config/models/usuario.dart';
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
  String _lastSearchValue;

  final _items = <String, List<ContentWrapper>>{
    'publicaciones': [],
    'recetas': [],
    'pois': [],
  };
  Timer _debounce;
  List<Usuario> _usuarios = [];

  final _fetching = <String, bool>{
    'publicaciones': false,
    'recetas': false,
    'pois': false,
    'usuarios': false,
  };

  Future<void> _fetchContent(String type) async {
    _fetching[type] = true;
    if (mounted) setState(() {});

    final resp = await Fetcher.get(
      url: widget.searchController.text != null &&
              widget.searchController.text.isNotEmpty
          ? '/$type/search.json?term=${Uri.encodeComponent(widget.searchController.text.replaceAll('@', ''))}&limit=3'
          : '/$type.json',
    );

    if (resp != null) {
      _items[type] = (json.decode(resp.body) as List)
          .map(
            (c) => ContentWrapper.fromJson(c),
          )
          .where(
            (p) =>
                (p.habilitado == null || p.habilitado) &&
                (widget.searchController.text[0] == '@'
                    ? p.user.username.toLowerCase().contains(widget
                        .searchController.text
                        .replaceAll('@', '')
                        .toLowerCase())
                    : true),
          )
          .toList();
    }

    _fetching[type] = false;
    if (mounted) setState(() {});
  }

  Future<void> _fetchUsuarios() async {
    _fetching['usuarios'] = true;
    if (mounted) setState(() {});

    final resp = await Fetcher.get(
      url: widget.searchController.text != null &&
              widget.searchController.text.isNotEmpty
          ? '/users/usernames.json?search=${Uri.encodeComponent(widget.searchController.text.replaceAll('@', ''))}&limit=3'
          : '/users/usernames.json?search=&limit=3',
    );

    if (resp != null) {
      _usuarios = (json.decode(resp.body) as List)
          .map(
            (c) => Usuario.fromJson(c),
          )
          .toList();
    }

    _fetching['usuarios'] = false;
    if (mounted) setState(() {});
  }

  void _onSearchChanged() {
    if (_lastSearchValue != widget.searchController.text) {
      if (_debounce?.isActive ?? false) _debounce.cancel();
      _debounce = Timer(const Duration(milliseconds: 1000), () {
        if (widget.searchController.text.isNotEmpty) {
          _fetchContent('publicaciones');
          _fetchContent('recetas');
          _fetchContent('pois');
          _fetchUsuarios();
          _lastSearchValue = widget.searchController.text;
          if (mounted) setState(() {});
        }
      });
    }
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
        await _fetchContent('publicaciones');
        await _fetchContent('recetas');
        await _fetchContent('pois');
        await _fetchUsuarios();
      },
      child: widget.searchController == null ||
              widget.searchController.text == null ||
              widget.searchController.text == ''
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
                  fetching: _fetching['usuarios'],
                  icon: Icons.account_circle,
                  title: 'Usuarios',
                  itemsUsuarios: _usuarios,
                  searchController: widget.searchController,
                  isUsers: true,
                ),
                DataGroup(
                  fetching: _fetching['publicaciones'],
                  icon: MyGlobals.ICONOS_CATEGORIAS[SectionType.publicaciones],
                  title: 'Publicaciones',
                  items: _items['publicaciones'],
                  type: SectionType.publicaciones,
                  searchController: widget.searchController,
                ),
                DataGroup(
                  fetching: _fetching['recetas'],
                  icon: MyGlobals.ICONOS_CATEGORIAS[SectionType.recetas],
                  title: 'Recetas',
                  items: _items['recetas'],
                  type: SectionType.recetas,
                  searchController: widget.searchController,
                ),
                DataGroup(
                  fetching: _fetching['pois'],
                  icon: MyGlobals.ICONOS_CATEGORIAS[SectionType.pois],
                  title: 'Market',
                  items: _items['pois'],
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
