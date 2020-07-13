import 'package:arrancando/config/globals/enums.dart';
import 'package:arrancando/config/globals/index.dart';
import 'package:arrancando/config/state/content_page.dart';
import 'package:arrancando/config/state/main.dart';
import 'package:arrancando/config/state/user.dart';
import 'package:arrancando/views/general/_badge_wrapper.dart';
import 'package:arrancando/views/home/app_bar/_search_bar.dart';
import 'package:arrancando/views/home/filter_bottom_sheet/index.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class MainAppBar extends StatelessWidget {
  final Function(bool) setSearchVisibility;
  final Function fetchContent;
  final TextEditingController searchController;
  final Function(PersistentBottomSheetController) setBottomSheetController;
  final bool unreadNotificaciones;

  MainAppBar({
    this.setSearchVisibility,
    this.fetchContent,
    this.searchController,
    this.setBottomSheetController,
    this.unreadNotificaciones = false,
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
              width: kToolbarHeight,
              height: kToolbarHeight,
              child: Image.asset('assets/images/icon.png'),
            ),
          ),
          title: SearchBar(
            searchController: searchController,
            setSearchVisibility: setSearchVisibility,
          ),
          actions: <Widget>[
            // if (!contentState.showSearchPage &&
            //     mainState.activePageHome != SectionType.home)
            //   IconButton(
            //     onPressed: () {
            //       showModalBottomSheet(
            //         context: MyGlobals.mainScaffoldKey.currentContext,
            //         builder: (_) => FilterBottomSheet(
            //           fetchContent: fetchContent,
            //         ),
            //         shape: RoundedRectangleBorder(
            //           borderRadius: BorderRadius.only(
            //             topLeft: Radius.circular(15),
            //             topRight: Radius.circular(15),
            //           ),
            //         ),
            //         backgroundColor: Colors.white,
            //       );
            //     },
            //     icon: Icon(Icons.filter_list),
            //   ),
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
            if (contentState.showSearchPage)
              IconButton(
                onPressed: () {
                  setSearchVisibility(false);
                  FocusScope.of(context).unfocus();
                  SystemChannels.textInput.invokeMethod('TextInput.hide');
                  FocusManager.instance.primaryFocus.unfocus();
                },
                icon: Icon(Icons.close),
              ),
            BadgeWrapper(
              showBadge: unreadNotificaciones,
              child: IconButton(
                onPressed: () {
                  MyGlobals.mainScaffoldKey.currentState.openEndDrawer();
                },
                icon: Icon(Icons.menu),
              ),
            ),
          ],
        );
      },
    );
  }
}
