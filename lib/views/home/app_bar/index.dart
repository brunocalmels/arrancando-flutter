import 'package:arrancando/config/globals/enums.dart';
import 'package:arrancando/config/globals/index.dart';
import 'package:arrancando/config/services/utils.dart';
import 'package:arrancando/config/state/content_page.dart';
import 'package:arrancando/config/state/main.dart';
import 'package:arrancando/config/state/user.dart';
import 'package:arrancando/views/general/_badge_wrapper.dart';
import 'package:arrancando/views/home/app_bar/_search_bar.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainAppBar extends StatefulWidget {
  final Function(bool) setSearchVisibility;
  final Function fetchContent;
  final TextEditingController searchController;
  final Function(PersistentBottomSheetController) setBottomSheetController;
  final Function(Function(bool)) setInnerShowSearchBar;

  MainAppBar({
    this.setSearchVisibility,
    this.fetchContent,
    this.searchController,
    this.setBottomSheetController,
    this.setInnerShowSearchBar,
  });

  @override
  _MainAppBarState createState() => _MainAppBarState();
}

class _MainAppBarState extends State<MainAppBar> {
  bool _showSearchBar = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.setInnerShowSearchBar((bool val) {
        _showSearchBar = val;
        if (mounted) setState(() {});
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _showSearchBar = false;
        return true;
      },
      child: Consumer2<MainState, ContentPageState>(
        builder: (context, mainState, contentState, child) {
          return AppBar(
            leading: Center(
              child: SizedBox(
                width: kToolbarHeight,
                height: kToolbarHeight,
                child: Image.asset('assets/images/icon.png'),
              ),
            ),
            title: _showSearchBar
                ? SearchBar(
                    searchController: widget.searchController,
                    setSearchVisibility: widget.setSearchVisibility,
                  )
                : null,
            actions: <Widget>[
              if (!_showSearchBar)
                IconButton(
                  icon: Icon(
                    Icons.search,
                  ),
                  onPressed: () {
                    _showSearchBar = true;
                    widget.setSearchVisibility(true);
                    if (mounted) setState(() {});
                  },
                ),
              if (!contentState.showSearchPage &&
                  mainState.activePageHome != SectionType.home)
                IconButton(
                  icon: Icon(Icons.share),
                  onPressed: () {
                    final userState = context.read<UserState>();
                    final contentPageState = context.read<ContentPageState>();

                    var type = mainState.activePageHome;

                    final categoryId = mainState.selectedCategoryHome[type] ??
                        userState.preferredCategories[type];

                    var sortBy = contentPageState.sortContentBy[type];

                    var rootURL = '/publicaciones';
                    var categoryParamName = 'ciudad_id';

                    switch (type) {
                      case SectionType.publicaciones:
                        rootURL = '/publicaciones';
                        categoryParamName = 'ciudad_id';
                        break;
                      case SectionType.recetas:
                        rootURL = '/recetas';
                        categoryParamName = 'categoria_receta_id';
                        break;
                      case SectionType.pois:
                        rootURL = '/pois';
                        categoryParamName = 'categoria_poi_id';
                        break;
                      default:
                    }

                    var url = '$rootURL?page=1';

                    if (categoryId != null && categoryId > 0) {
                      url += '&$categoryParamName=$categoryId';
                    }

                    if (type == SectionType.publicaciones &&
                        context != null &&
                        mainState.selectedCategoryHome[
                                SectionType.publicaciones_categoria] !=
                            null &&
                        mainState.selectedCategoryHome[
                                SectionType.publicaciones_categoria] >
                            0) {
                      url +=
                          '&categoria_publicacion_id=${mainState.selectedCategoryHome[SectionType.publicaciones_categoria]}';
                    }

                    if (type == SectionType.pois &&
                        context != null &&
                        mainState.selectedCategoryHome[
                                SectionType.pois_ciudad] !=
                            null &&
                        mainState
                                .selectedCategoryHome[SectionType.pois_ciudad] >
                            0) {
                      url +=
                          '&ciudad_id=${mainState.selectedCategoryHome[SectionType.pois_ciudad]}';
                    }

                    if (sortBy != null) {
                      switch (sortBy) {
                        case ContentSortType.fecha_creacion:
                          url += '&sorted_by=fecha_creacion';
                          break;
                        case ContentSortType.fecha_actualizacion:
                          url += '&sorted_by=fecha_actualizacion';
                          break;
                        case ContentSortType.puntuacion:
                          url += '&sorted_by=puntuacion';
                          break;
                        case ContentSortType.proximidad:
                          url += '&sorted_by=proximidad';
                          break;
                        case ContentSortType.vistas:
                          url += '&sorted_by=vistas';
                          break;
                        default:
                      }
                    }

                    Share.text(
                      'Compartir p??gina',
                      'https://arrancando.com.ar$url',
                      'text/plain',
                    );
                  },
                ),
              if (contentState.showSearchPage)
                IconButton(
                  onPressed: () {
                    widget.setSearchVisibility(false);
                    Utils.unfocus(context);
                    _showSearchBar = false;
                    if (mounted) setState(() {});
                  },
                  icon: Icon(Icons.close),
                ),
              BadgeWrapper(
                showBadge: mainState.unreadNotifications > 0,
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
      ),
    );
  }
}
