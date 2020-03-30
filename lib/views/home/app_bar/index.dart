import 'package:arrancando/config/globals/enums.dart';
import 'package:arrancando/config/globals/index.dart';
import 'package:arrancando/config/state/content_page.dart';
import 'package:arrancando/config/state/main.dart';
import 'package:arrancando/views/home/app_bar/_search_bar.dart';
import 'package:arrancando/views/home/filter_bottom_sheet/index.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainAppBar extends StatelessWidget {
  final Function(bool) setSearchVisibility;
  final Function fetchContent;
  final TextEditingController searchController;
  final Function(PersistentBottomSheetController) setBottomSheetController;

  MainAppBar({
    this.setSearchVisibility,
    this.fetchContent,
    this.searchController,
    this.setBottomSheetController,
  });

  _anyFilterActive(MainState mainState, ContentPageState contentPageState) {
    if (mainState.activePageHome != SectionType.publicaciones) {
      if (mainState.activePageHome == SectionType.pois) return true;
      if (mainState.selectedCategoryHome[mainState.activePageHome] != -1 &&
          mainState.selectedCategoryHome[mainState.activePageHome] != null)
        return true;
    } else {
      if (mainState.selectedCategoryHome[mainState.activePageHome] != -1 ||
          (mainState.selectedCategoryHome[
                      SectionType.publicaciones_categoria] !=
                  -1 &&
              mainState.selectedCategoryHome[
                      SectionType.publicaciones_categoria] !=
                  null)) return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<MainState, ContentPageState>(
      builder: (context, mainState, contentState, child) {
        return AppBar(
          leading: Center(
            child: SizedBox(
              width: 40,
              height: 40,
              child: Image.asset('assets/images/icon.png'),
            ),
          ),
          title: SearchBar(
            searchController: searchController,
            setSearchVisibility: setSearchVisibility,
          ),
          actions: <Widget>[
            if (!contentState.showSearchPage &&
                mainState.activePageHome != SectionType.home)
              IconButton(
                onPressed: () {
                  showModalBottomSheet(
                    context: MyGlobals.mainScaffoldKey.currentContext,
                    builder: (_) => FilterBottomSheet(
                      fetchContent: fetchContent,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15),
                      ),
                    ),
                    backgroundColor: Colors.white,
                  );
                },
                icon: Icon(
                  Icons.filter_list,
                  color: _anyFilterActive(mainState, contentState)
                      ? Theme.of(context).accentColor
                      : null,
                ),
              ),
            if (contentState.showSearchPage)
              IconButton(
                onPressed: () {
                  setSearchVisibility(false);
                },
                icon: Icon(Icons.close),
              ),
            IconButton(
              onPressed: () {
                MyGlobals.mainScaffoldKey.currentState.openEndDrawer();
              },
              icon: Icon(Icons.menu),
            ),
            IconButton(
              onPressed: () {
                MyGlobals.mainScaffoldKey.currentState.openEndDrawer();
              },
              icon: Icon(Icons.menu),
            ),
          ],
        );
      },
    );
  }
}
