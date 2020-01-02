import 'package:arrancando/config/globals/enums.dart';
import 'package:arrancando/views/home/pages/_content_card_page.dart';
import 'package:arrancando/views/home/pages/_poi_page.dart';
import 'package:arrancando/views/search/_search_field.dart';
import 'package:arrancando/views/search/_selector_section_type.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  final SectionType originalType;
  final String originalSearch;

  SearchPage({
    this.originalType,
    this.originalSearch,
  });

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  SectionType _type;
  Widget _page;
  final TextEditingController _searchController = TextEditingController();

  Widget _getPage(SectionType value, String term) {
    switch (value) {
      case SectionType.publicaciones:
        return ContentCardPage(
          rootUrl: "/publicaciones",
          categoryParam: "ciudad_id",
          type: SectionType.publicaciones,
          searchTerm: term,
        );
      case SectionType.recetas:
        return ContentCardPage(
          rootUrl: "/recetas",
          categoryParam: "categoria_receta_id",
          type: SectionType.recetas,
          searchTerm: term,
        );
      case SectionType.pois:
        return PoiPage(
          searchTerm: term,
        );
      default:
        return ContentCardPage(
          rootUrl: "/publicaciones",
          categoryParam: "ciudad_id",
          type: SectionType.publicaciones,
          searchTerm: term,
        );
    }
  }

  _reloadPage() async {
    if (_searchController.text.isNotEmpty) {
      _page = null;
      if (mounted) setState(() {});
      await Future.delayed(Duration(milliseconds: 300));
      _page = _getPage(_type, _searchController.text);
      if (mounted) setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    _type = widget.originalType;
    _searchController.text = widget.originalSearch;
    _page = _getPage(_type, widget.originalSearch);
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: SearchField(
          searchController: _searchController,
          onChanged: (val) {
            _reloadPage();
          },
        ),
        actions: <Widget>[
          SelectorSectionType(
            setActiveType: (type) {
              _type = type;
              if (mounted) setState(() {});
              _reloadPage();
            },
            activeType: _type,
          ),
        ],
      ),
      // body: SingleChildScrollView(
      //   child: _page,
      // ),
      body: _page,
    );
  }
}
