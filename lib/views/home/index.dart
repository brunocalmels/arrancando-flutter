import 'package:arrancando/views/home/main_new_fab.dart';
import 'package:arrancando/views/home/pages/_home_page.dart';
import 'package:arrancando/views/home/pages/_poi_page.dart';
import 'package:arrancando/views/home/pages/_publicaciones_page.dart';
import 'package:arrancando/views/home/pages/_recetas_page.dart';
import 'package:arrancando/views/home/app_bar/index.dart';
import 'package:arrancando/views/home/main_bottom_bar.dart';
import 'package:flutter/material.dart';

class MainScaffold extends StatefulWidget {
  @override
  _MainScaffoldState createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  int _activeItem = 0;

  Widget _getPage(int index) {
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
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: Container(
          child: CustomScrollView(
            slivers: <Widget>[
              MainAppBar(
                activeItem: _activeItem,
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
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: MainNewFab(),
        bottomNavigationBar: MainBottomBar(
          activeItem: _activeItem,
          setActiveItem: (int item) {
            setState(() {
              _activeItem = item;
            });
          },
        ),
      ),
    );
  }
}
