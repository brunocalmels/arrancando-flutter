import 'package:arrancando/config/globals/enums.dart';
import 'package:arrancando/config/globals/index.dart';
import 'package:arrancando/config/state/index.dart';
import 'package:arrancando/views/home/app_bar/_categories_chip.dart';
import 'package:arrancando/views/home/app_bar/_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainAppBar extends StatelessWidget {
  final bool sent;
  final bool showSearch;
  final Function(bool) setSent;
  final Function showSearchPage;
  final Function toggleSearch;
  final TextEditingController searchController;
  final bool sortByPoints;
  final Function(bool) setSortPublicaciones;

  MainAppBar({
    this.sent,
    this.showSearch,
    this.setSent,
    this.showSearchPage,
    this.toggleSearch,
    this.searchController,
    this.sortByPoints,
    this.setSortPublicaciones,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      iconTheme: IconThemeData(
        color: Colors.black,
      ),
      leading: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.black12,
              borderRadius: BorderRadius.circular(100),
            ),
            child: Material(
              color: Colors.transparent,
              type: MaterialType.circle,
              child: InkWell(
                onTap: () {
                  MyGlobals.mainScaffoldKey.currentState.openDrawer();
                },
                child: Icon(Icons.person),
              ),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.white,
      title: showSearch
          ? SearchBar(
              setSent: setSent,
              showSearchPage: showSearchPage,
              searchController: searchController,
            )
          : Provider.of<MyState>(context).activePageHome != SectionType.home
              ? CategoriesChip()
              : null,
      actions: <Widget>[
        if (!showSearch &&
            Provider.of<MyState>(context).activePageHome ==
                SectionType.publicaciones)
          PopupMenuButton<bool>(
            icon: Icon(Icons.filter_list),
            onSelected: (val) {
              setSortPublicaciones(val);
            },
            itemBuilder: (context) => <PopupMenuItem<bool>>[
              PopupMenuItem(
                value: false,
                child: Text(
                  "Fecha",
                  style: TextStyle(
                      color:
                          !sortByPoints ? Theme.of(context).accentColor : null),
                ),
              ),
              PopupMenuItem(
                value: true,
                child: Text(
                  "Puntuación",
                  style: TextStyle(
                      color:
                          sortByPoints ? Theme.of(context).accentColor : null),
                ),
              ),
            ],
          ),
        IconButton(
          onPressed: toggleSearch,
          icon: Icon(
            showSearch ? Icons.close : Icons.search,
          ),
        ),
      ],
    );
  }
}
