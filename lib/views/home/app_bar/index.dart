import 'package:arrancando/config/globals/enums.dart';
import 'package:arrancando/config/globals/index.dart';
import 'package:arrancando/config/state/content_page.dart';
import 'package:arrancando/config/state/main.dart';
import 'package:arrancando/config/state/user.dart';
import 'package:arrancando/views/home/app_bar/_search_bar.dart';
import 'package:arrancando/views/home/filter_bottom_sheet/index.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
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
                    child: Image.asset('assets/images/icon.png'),
                  ),
                ),
              ),
            ],
          ),
          backgroundColor: Colors.white,
          title: contentState.showSearchPage
              ? SearchBar(
                  searchController: searchController,
                )
              : null,
          //     : mainState.activePageHome != SectionType.home
          //         ? CategoriesChip(
          //             fetchContent: fetchContent,
          //           )
          //         : null,
          actions: <Widget>[
            // if (!contentState.showSearchPage &&
            //     mainState.activePageHome != SectionType.home)
            //   PopupMenuButton<ContentSortType>(
            //     icon: Icon(Icons.filter_list),
            //     onSelected: (type) {
            //       contentState.setContentSortType(type);
            //       if (fetchContent != null) fetchContent();
            //     },
            //     itemBuilder: (context) => <PopupMenuItem<ContentSortType>>[
            //       if (mainState.activePageHome != SectionType.pois)
            //         PopupMenuItem(
            //           value: ContentSortType.fecha,
            //           child: Text(
            //             "Fecha",
            //             style: TextStyle(
            //                 color: contentState.sortContentBy ==
            //                         ContentSortType.fecha
            //                     ? Theme.of(context).accentColor
            //                     : null),
            //           ),
            //         ),
            //       if (mainState.activePageHome == SectionType.pois &&
            //           !Platform.isIOS)
            //         PopupMenuItem(
            //           value: ContentSortType.proximidad,
            //           child: Text(
            //             "Proximidad",
            //             style: TextStyle(
            //                 color: contentState.sortContentBy ==
            //                         ContentSortType.proximidad
            //                     ? Theme.of(context).accentColor
            //                     : null),
            //           ),
            //         ),
            //       PopupMenuItem(
            //         value: ContentSortType.puntuacion,
            //         child: Text(
            //           "Puntuación",
            //           style: TextStyle(
            //               color: contentState.sortContentBy ==
            //                       ContentSortType.puntuacion
            //                   ? Theme.of(context).accentColor
            //                   : null),
            //         ),
            //       ),
            //     ],
            //   ),

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
                  // setBottomSheetController(
                  //   MyGlobals.mainScaffoldKey.currentState.showBottomSheet(
                  //     (context) => FilterBottomSheet(
                  //       fetchContent: fetchContent,
                  //     ),
                  //   ),
                  // );
                },
                icon: Icon(
                  Icons.filter_list,
                  color: _anyFilterActive(mainState, contentState)
                      ? Theme.of(context).accentColor
                      : null,
                ),
              ),
            if (!contentState.showSearchPage &&
                mainState.activePageHome != SectionType.home)
              IconButton(
                icon: Icon(Icons.share),
                onPressed: () {
                  UserState userState = Provider.of<UserState>(
                    context,
                    listen: false,
                  );
                  ContentPageState contentPageState =
                      Provider.of<ContentPageState>(
                    context,
                    listen: false,
                  );

                  var type = mainState.activePageHome;

                  int categoryId = mainState.selectedCategoryHome[type] != null
                      ? mainState.selectedCategoryHome[type]
                      : userState.preferredCategories[type];

                  var sortBy = contentPageState.sortContentBy;

                  String rootURL = '/publicaciones';
                  String categoryParamName = "ciudad_id";

                  switch (type) {
                    case SectionType.publicaciones:
                      rootURL = '/publicaciones';
                      categoryParamName = "ciudad_id";
                      break;
                    case SectionType.recetas:
                      rootURL = '/recetas';
                      categoryParamName = "categoria_receta_id";
                      break;
                    case SectionType.pois:
                      rootURL = '/pois';
                      categoryParamName = "categoria_poi_id";
                      break;
                    default:
                  }

                  String url = "$rootURL?page=1";

                  if (categoryId != null && categoryId > 0)
                    url += "&$categoryParamName=$categoryId";

                  if (type == SectionType.publicaciones &&
                      context != null &&
                      mainState.selectedCategoryHome[
                              SectionType.publicaciones_categoria] !=
                          null &&
                      mainState.selectedCategoryHome[
                              SectionType.publicaciones_categoria] >
                          0)
                    url +=
                        '&categoria_publicacion_id=${mainState.selectedCategoryHome[SectionType.publicaciones_categoria]}';

                  if (type == SectionType.pois &&
                      context != null &&
                      mainState.selectedCategoryHome[SectionType.pois_ciudad] !=
                          null &&
                      mainState.selectedCategoryHome[SectionType.pois_ciudad] >
                          0)
                    url +=
                        '&ciudad_id=${mainState.selectedCategoryHome[SectionType.pois_ciudad]}';

                  if (sortBy != null)
                    switch (sortBy) {
                      case ContentSortType.fecha:
                        url += '&sorted_by=fecha';
                        break;
                      case ContentSortType.puntuacion:
                        url += '&sorted_by=puntuacion';
                        break;
                      case ContentSortType.proximidad:
                        url += '&sorted_by=proximidad';
                        break;
                      default:
                    }

                  Share.text(
                    'Compartir página',
                    'https://arrancando.com.ar$url',
                    'text/plain',
                  );
                },
              ),
            IconButton(
              onPressed: () {
                setSearchVisibility(!contentState.showSearchPage);
              },
              icon: Icon(
                contentState.showSearchPage ? Icons.close : Icons.search,
              ),
            ),
          ],
        );
      },
    );
  }
}
