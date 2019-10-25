import 'package:arrancando/config/globals/enums.dart';
import 'package:arrancando/config/state/index.dart';
import 'package:arrancando/views/home/main_new_fab.dart';
import 'package:arrancando/views/home/pages/_home_page.dart';
import 'package:arrancando/views/home/pages/_poi_page.dart';
import 'package:arrancando/views/home/pages/_publicaciones_page.dart';
import 'package:arrancando/views/home/pages/_recetas_page.dart';
import 'package:arrancando/views/home/app_bar/index.dart';
import 'package:arrancando/views/home/bottom_bar/index.dart';
import 'package:arrancando/views/home/pages/fast_search/index.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainScaffold extends StatefulWidget {
  @override
  _MainScaffoldState createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  final TextEditingController _searchController = TextEditingController();
  bool _showSearch = false;
  bool _showSearchResults = false;
  bool _sent = false;

  _setSent(bool val) {
    if (mounted)
      setState(() {
        _sent = val;
      });
  }

  _setShowSearchResults(bool val) {
    if (mounted)
      setState(() {
        _showSearchResults = val;
      });
  }

  _toggleSearch() {
    _showSearch = !_showSearch;
    if (!_showSearch) {
      _searchController.clear();
      _setSent(false);
      _setShowSearchResults(false);
    }
    if (mounted) setState(() {});
  }

  _hideSearch() {
    _showSearch = false;
    _searchController.clear();
    _setSent(false);
    _setShowSearchResults(false);
    if (mounted) setState(() {});
  }

  Widget _getPage(SectionType value) {
    if (!_showSearchResults) {
      switch (value) {
        case SectionType.home:
          return HomePage();
        case SectionType.publicaciones:
          return PublicacionesPage();
        case SectionType.recetas:
          return RecetasPage();
        case SectionType.pois:
          return PoiPage();
        default:
          return HomePage();
      }
    } else {
      return FastSearchPage(
        sent: _sent,
        searchController: _searchController,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _hideSearch();
        return false;
      },
      child: Stack(
        fit: StackFit.passthrough,
        children: <Widget>[
          Scaffold(
            body: Container(
              child: CustomScrollView(
                slivers: <Widget>[
                  MainAppBar(
                    sent: _sent,
                    setSent: _setSent,
                    showSearchPage: _setShowSearchResults,
                    searchController: _searchController,
                    toggleSearch: _toggleSearch,
                    showSearch: _showSearch,
                  ),
                  SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        Container(
                          child: _getPage(
                            Provider.of<MyState>(context).activePageHome,
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: 0,
            bottom: 0,
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  MainNewFab(),
                  SizedBox(
                    height: 15,
                  ),
                  MainBottomBar(),
                  SizedBox(
                    height: 15,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      // floatingActionButton: MainNewFab(),
    );
  }
}
