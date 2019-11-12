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

  MainAppBar({
    this.sent,
    this.showSearch,
    this.setSent,
    this.showSearchPage,
    this.toggleSearch,
    this.searchController,
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
          CircleAvatar(
            radius: 20,
            backgroundImage: NetworkImage(
              "https://i.pinimg.com/originals/39/dc/46/39dc46a4e66b01245129a4ed0e1345ce.jpg",
            ),
            child: Material(
              color: Colors.transparent,
              type: MaterialType.circle,
              child: InkWell(
                onTap: () {
                  MyGlobals.mainScaffoldKey.currentState.openDrawer();
                },
              ),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.transparent,
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
        IconButton(
          onPressed: toggleSearch,
          icon: Icon(
            showSearch ? Icons.close : Icons.search,
          ),
        )
      ],
    );
  }
}
