import 'package:arrancando/config/globals/enums.dart';
import 'package:arrancando/config/globals/index.dart';
import 'package:arrancando/config/models/active_user.dart';
import 'package:arrancando/config/models/category_wrapper.dart';
import 'package:arrancando/config/models/content_wrapper.dart';
import 'package:arrancando/config/state/content_page.dart';
import 'package:arrancando/config/state/main.dart';
import 'package:arrancando/config/state/user.dart';
import 'package:arrancando/views/general/version_checker.dart';
import 'package:arrancando/views/home/_drawer.dart';
import 'package:arrancando/views/home/main_new_fab.dart';
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
  PersistentBottomSheetController _bottomSheetController;
  List<ContentWrapper> _items;
  int _page = 1;
  bool _fetching = true;
  bool _noMore = false;
  bool _loadingMore = false;
  bool _locationDenied = false;
  Map<int, double> _calculatedDistance = {};

  Future<void> _fetchContent(type, {bool keepPage = false}) async {
    MainState mainState = Provider.of<MainState>(
      context,
      listen: false,
    );
    UserState userState = Provider.of<UserState>(
      context,
      listen: false,
    );
    ContentPageState contentPageState = Provider.of<ContentPageState>(
      context,
      listen: false,
    );

    int lastLength = _items != null ? _items.length : 0;

    int selectedCategory = mainState.selectedCategoryHome[type] != null
        ? mainState.selectedCategoryHome[type]
        : userState.preferredCategories[type];

    if (_items == null) _items = [];

    _items += await ContentWrapper.fetchItems(
      type,
      search: _searchController.text,
      categoryId: selectedCategory,
      page: _page,
      sortBy: contentPageState.sortContentBy,
      context: context,
    );

    if (type == SectionType.pois &&
        contentPageState.sortContentBy == ContentSortType.proximidad) {
      _items = await ContentWrapper.sortItems(
        _items,
        contentPageState.sortContentBy,
        calculatedDistance: _calculatedDistance,
      );
    }

    if (type == SectionType.pois && !_locationDenied)
      _items.map((i) => _calculatedDistance[i.id] = i.localDistance);

    // if (!keepPage) _page += 1;

    _noMore = false;
    if (lastLength == _items.length) {
      _noMore = true;
      _page -= 1;
    }
    _fetching = false;
    if (mounted) setState(() {});

    if (type == SectionType.pois &&
        contentPageState.sortContentBy != ContentSortType.proximidad) {
      await Future.wait(_items.map((item) => item.distancia));
      if (mounted) setState(() {});
    }
  }

  _resetLimit({bool keepNumber = false}) {
    _items = null;
    _fetching = true;
    _noMore = false;
    if (!keepNumber) _page = 1;
    if (mounted) setState(() {});
  }

  _increasePage() {
    _page += 1;
  }

  _setLoadingMore(bool val) {
    _loadingMore = val;
    if (mounted) setState(() {});
  }

  _setLocationDenied() async {
    _locationDenied = await ActiveUser.locationPermissionDenied();
    if (mounted) setState(() {});
  }

  _setSearchVisibility(bool val) {
    ContentPageState cps = Provider.of<ContentPageState>(context);
    cps.setSearchPageVisible(val);
    cps.setSearchResultsVisible(val);
    if (!val) _searchController.clear();
    if (mounted) setState(() {});
  }

  Widget _getPage(SectionType type) {
    if (!Provider.of<ContentPageState>(context).showSearchResults) {
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
              items: _items,
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
              items: _items,
            ),
          );
        case SectionType.pois:
          return PoiPage(
            fetching: _fetching,
            noMore: _noMore,
            resetLimit: _resetLimit,
            fetchContent: _fetchContent,
            increasePage: _increasePage,
            items: _items,
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

  _initUserInfo() async {
    await ActiveUser.verifyCorrectLogin(context);
    if (Provider.of<UserState>(context).activeUser != null)
      ActiveUser.updateUserMetadata(context);
    SectionType.values.forEach(
      (t) {
        CategoryWrapper.restoreSavedFilter(context, t);
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _initUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _setSearchVisibility(false);
        _bottomSheetController.close();
        if (MyGlobals.mainScaffoldKey.currentState.isDrawerOpen) return true;

        return false;
      },
      child: Scaffold(
        key: MyGlobals.mainScaffoldKey,
        drawer: HomeDrawer(),
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(55),
          child: MainAppBar(
            searchController: _searchController,
            setSearchVisibility: _setSearchVisibility,
            setBottomSheetController:
                (PersistentBottomSheetController controller) {
              _bottomSheetController = controller;
              if (mounted) setState(() {});
            },
            fetchContent: () {
              _resetLimit();
              _fetchContent(
                Provider.of<MainState>(context).activePageHome,
                keepPage: true,
              );
            },
          ),
        ),
        body: Stack(
          fit: StackFit.passthrough,
          children: <Widget>[
            _getPage(
              Provider.of<MainState>(context).activePageHome,
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
                      setSearchVisibility: _setSearchVisibility,
                    ),
                    SizedBox(
                      height: 15,
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              left: 0,
              bottom: 0,
              child: VersionChecker(),
            ),
          ],
        ),
      ),
    );
  }
}
