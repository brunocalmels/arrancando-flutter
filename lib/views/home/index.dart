import 'dart:io';

import 'package:arrancando/config/globals/enums.dart';
import 'package:arrancando/config/globals/index.dart';
import 'package:arrancando/config/models/active_user.dart';
import 'package:arrancando/config/models/category_wrapper.dart';
import 'package:arrancando/config/models/content_wrapper.dart';
import 'package:arrancando/config/models/notificacion.dart';
import 'package:arrancando/config/services/dynamic_links.dart';
import 'package:arrancando/config/services/notificaciones.dart';
import 'package:arrancando/config/services/permissions.dart';
import 'package:arrancando/config/services/utils.dart';
import 'package:arrancando/config/state/content_page.dart';
import 'package:arrancando/config/state/main.dart';
import 'package:arrancando/config/state/user.dart';
import 'package:arrancando/views/general/version_checker.dart';
import 'package:arrancando/views/home/_deferred_executor_tile.dart';
import 'package:arrancando/views/home/_dialog_confirm_leave.dart';
import 'package:arrancando/views/home/_drawer.dart';
import 'package:arrancando/views/home/_home_fab.dart';
import 'package:arrancando/views/home/pages/_content_card_page.dart';
import 'package:arrancando/views/home/pages/_home_page.dart';
import 'package:arrancando/views/home/pages/_poi_page.dart';
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
  // PersistentBottomSheetController _bottomSheetController;
  final _itemsMap = <SectionType, List<ContentWrapper>>{
    SectionType.publicaciones: null,
    SectionType.recetas: null,
    SectionType.pois: null,
  };
  int _page = 1;
  bool _fetching = true;
  bool _noMore = false;
  bool _loadingMore = false;
  bool _locationDenied = false;
  final _calculatedDistance = <int, double>{};
  // List<Notificacion> _unreadNotificaciones;
  bool _inited = false;
  Function(bool) _setShowSearchBar;

  Future<void> _fetchContent(type, {bool keepPage = false}) async {
    final mainState = context.read<MainState>();
    final userState = context.read<UserState>();
    final contentPageState = context.read<ContentPageState>();

    final lastLength = _itemsMap[mainState.activePageHome] != null
        ? _itemsMap[mainState.activePageHome].length
        : 0;

    final selectedCategory = mainState.selectedCategoryHome[type] ??
        userState.preferredCategories[type];

    if (_itemsMap[mainState.activePageHome] == null) {
      _itemsMap[mainState.activePageHome] = [];
    }

    _itemsMap[mainState.activePageHome] += await ContentWrapper.fetchItems(
      type,
      search: _searchController.text,
      categoryId: selectedCategory,
      page: _page,
      sortBy: contentPageState.sortContentBy[type],
      context: context,
    );

    if (type == SectionType.pois &&
        contentPageState.sortContentBy[type] == ContentSortType.proximidad) {
      _itemsMap[mainState.activePageHome] = await ContentWrapper.sortItems(
        _itemsMap[mainState.activePageHome],
        contentPageState.sortContentBy[type],
        calculatedDistance: _calculatedDistance,
      );
    }

    if (type == SectionType.pois &&
        !_locationDenied &&
        _itemsMap[mainState.activePageHome] != null) {
      _itemsMap[mainState.activePageHome]
          .map((i) => _calculatedDistance[i.id] = i.localDistance);
    }

    // if (!keepPage) _page += 1;

    _noMore = false;
    if (_itemsMap[mainState.activePageHome] != null &&
        lastLength == _itemsMap[mainState.activePageHome].length) {
      _noMore = true;
      _page -= 1;
    }
    _fetching = false;
    if (mounted) setState(() {});

    if (type == SectionType.pois &&
        contentPageState.sortContentBy[mainState.activePageHome] !=
            ContentSortType.proximidad &&
        _itemsMap[mainState.activePageHome] != null) {
      await Future.wait(
          _itemsMap[mainState.activePageHome].map((item) => item.distancia));
      if (mounted) setState(() {});
    }
  }

  void _resetLimit({bool keepNumber = false}) {
    _itemsMap[context.read<MainState>().activePageHome] = null;
    _fetching = true;
    _noMore = false;
    if (!keepNumber) _page = 1;
    if (mounted) setState(() {});
  }

  void _increasePage() {
    _page += 1;
  }

  void _setLoadingMore(bool val) {
    _loadingMore = val;
    if (mounted) setState(() {});
  }

  Future<void> _setLocationDenied() async {
    _locationDenied = !(await PermissionUtils.requestLocationPermission());
    if (mounted) setState(() {});
  }

  void _setSearchVisibility(bool val) {
    final cps = context.read<ContentPageState>();
    cps.setSearchPageVisible(val);
    cps.setSearchResultsVisible(val);
    if (!val) _searchController.clear();
    if (mounted) setState(() {});
  }

  bool _isSearchVisible() {
    final cps = context.read<ContentPageState>();
    return cps.showSearchPage || cps.showSearchResults;
  }

  Widget _getPage(SectionType type) {
    if (!context
        .select<ContentPageState, bool>((value) => value.showSearchResults)) {
      switch (type) {
        case SectionType.home:
          return HomePage();
        case SectionType.publicaciones:
          return Container(
            key: Key('publicaciones-page'),
            child: ContentCardPage(
              type: SectionType.publicaciones,
              fetching: _fetching,
              noMore: _noMore,
              resetLimit: _resetLimit,
              fetchContent: _fetchContent,
              increasePage: _increasePage,
              items: _itemsMap[SectionType.publicaciones],
            ),
          );
        case SectionType.recetas:
          return Container(
            key: Key('recetas-page'),
            child: ContentCardPage(
              type: SectionType.recetas,
              fetching: _fetching,
              noMore: _noMore,
              resetLimit: _resetLimit,
              fetchContent: _fetchContent,
              increasePage: _increasePage,
              items: _itemsMap[SectionType.recetas],
            ),
          );
        case SectionType.pois:
          return PoiPage(
            fetching: _fetching,
            noMore: _noMore,
            resetLimit: _resetLimit,
            fetchContent: _fetchContent,
            increasePage: _increasePage,
            items: _itemsMap[SectionType.pois],
            loadingMore: _loadingMore,
            setLoadingMore: _setLoadingMore,
            setLocationDenied: _setLocationDenied,
            locationDenied: _locationDenied,
          );
        default:
          return HomePage();
      }
    } else {
      return FastSearchPage(
        searchController: _searchController,
      );
    }
  }

  Future<void> _fetchUnreadNotificaciones() async {
    var unreadNotificaciones = await Notificacion.fetchUnread();
    context
        .read<MainState>()
        .setUnreadNotifications(unreadNotificaciones.length);
  }

  Future<void> _initUserInfo() async {
    await ActiveUser.verifyCorrectLogin(context);
    if (context.read<UserState>().activeUser != null) {
      await ActiveUser.updateUserMetadata(context);
      await Future.wait(
        SectionType.values.map(
          (t) async {
            await CategoryWrapper.restoreSavedFilter(context, t);
            await CategoryWrapper.restoreSavedShowMine(context, t);
          },
        ),
      );
      await CategoryWrapper.restoreContentHome(context);
      if (!Platform.isLinux) {
        await NotificacionesService.initFirebaseNotifications(context);
      }
      await _fetchUnreadNotificaciones();
    }
    _inited = true;
    if (mounted) setState(() {});
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _initUserInfo();
      if (!Platform.isLinux) {
        await DynamicLinks.initUniLinks(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Utils.unfocus(context);
        if (MyGlobals.mainScaffoldKey.currentState.isEndDrawerOpen) {
          return true;
        } else if (_isSearchVisible()) {
          _setSearchVisibility(false);
          _setShowSearchBar(false);
          return false;
        } else {
          final leave = await showDialog(
            context: context,
            builder: (_) => DialogConfirmLeave(),
          );
          if (leave != null && leave) {
            return true;
          }
          return false;
        }
      },
      child: Stack(
        fit: StackFit.passthrough,
        children: <Widget>[
          Scaffold(
            // backgroundColor: Theme.of(context).backgroundColor,
            key: MyGlobals.mainScaffoldKey,
            endDrawer: HomeDrawer(),
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(55),
              child: MainAppBar(
                searchController: _searchController,
                setSearchVisibility: _setSearchVisibility,
                setBottomSheetController:
                    (PersistentBottomSheetController controller) {
                  // _bottomSheetController = controller;
                  // if (mounted) setState(() {});
                },
                fetchContent: () {
                  _resetLimit();
                  _fetchContent(
                    context.read<MainState>().activePageHome,
                    keepPage: true,
                  );
                },
                // unreadNotificaciones: _unreadNotificaciones != null &&
                //     _unreadNotificaciones.length > 0,
                setInnerShowSearchBar: (Function(bool) setShowSearchBar) {
                  _setShowSearchBar = setShowSearchBar;
                  if (mounted) setState(() {});
                },
              ),
            ),
            body: _inited
                ? Stack(
                    fit: StackFit.expand,
                    children: [
                      _getPage(
                        context.select<MainState, SectionType>(
                            (value) => value.activePageHome),
                      ),
                      if (context
                              .select<ContentPageState, DeferredExecutorStatus>(
                                  (value) => value.deferredExecutorStatus) !=
                          DeferredExecutorStatus.none)
                        DeferredExecutorTile(),
                    ],
                  )
                : Center(
                    child: CircularProgressIndicator(),
                  ),

            extendBody: true,
            floatingActionButton:
                (context.select<ContentPageState, DeferredExecutorStatus>(
                          (value) => value.deferredExecutorStatus,
                        ) ==
                        DeferredExecutorStatus.none)
                    ? HomeFab()
                    : null,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            bottomNavigationBar: MainBottomBar(
              setSearchVisibility: _setSearchVisibility,
            ),
          ),
          Positioned(
            left: 0,
            bottom: 0,
            child: VersionChecker(),
          ),
        ],
      ),
    );
  }
}
