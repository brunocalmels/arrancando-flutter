import 'package:arrancando/views/home/main_new_fab.dart';
import 'package:arrancando/views/home/pages/_home_page.dart';
import 'package:arrancando/views/home/pages/_poi_page.dart';
import 'package:arrancando/views/home/pages/_publicaciones_page.dart';
import 'package:arrancando/views/home/pages/_recetas_page.dart';
import 'package:arrancando/views/home/app_bar/index.dart';
import 'package:arrancando/views/home/bottom_bar/index.dart';
import 'package:arrancando/views/home/pages/search/index.dart';
import 'package:flutter/material.dart';

class MainScaffold extends StatefulWidget {
  @override
  _MainScaffoldState createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  int _activeItem = 0;
  bool _showSearchResults = false;
  bool _sent = false;

  _setSent(bool val) {
    setState(() {
      _sent = val;
    });
  }

  _setShowSearchResults(bool val) {
    setState(() {
      _showSearchResults = val;
    });
  }

  Widget _getPage(int index) {
    if (!_showSearchResults) {
      switch (index) {
        case 0:
          return HomePage();
        case 1:
          return PublicacionesPage();
        case 2:
          return RecetasPage();
        case 3:
          return PoiPage();
        default:
          return HomePage();
      }
    } else {
      return SearchPage(
        activeItem: _activeItem,
        sent: _sent,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Stack(
        fit: StackFit.passthrough,
        children: <Widget>[
          Scaffold(
            body: Container(
              child: CustomScrollView(
                slivers: <Widget>[
                  MainAppBar(
                    activeItem: _activeItem,
                    sent: _sent,
                    setSent: _setSent,
                    showSearchPage: _setShowSearchResults,
                  ),
                  SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        Container(
                          child: _getPage(_activeItem),
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
                  MainBottomBar(
                    activeItem: _activeItem,
                    setActiveItem: (int item) {
                      setState(() {
                        _activeItem = item;
                      });
                    },
                  ),
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
