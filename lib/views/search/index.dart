import 'package:arrancando/config/globals/enums.dart';
import 'package:arrancando/config/models/active_user.dart';
import 'package:arrancando/config/models/content_wrapper.dart';
import 'package:arrancando/config/state/content_page.dart';
import 'package:arrancando/config/state/main.dart';
import 'package:arrancando/config/state/user.dart';
import 'package:arrancando/views/home/pages/_content_card_page.dart';
import 'package:arrancando/views/home/pages/_poi_page.dart';
import 'package:arrancando/views/search/_search_field.dart';
import 'package:arrancando/views/search/_selector_section_type.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatefulWidget {
  final SectionType originalType;
  final String originalSearch;

  SearchPage({
    this.originalType,
    this.originalSearch,
  });

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  SectionType _type;
  // Widget _page;
  final TextEditingController _searchController = TextEditingController();
  List<ContentWrapper> _items = [];
  int _page = 1;
  bool _fetching = true;
  bool _noMore = false;
  bool _loadingMore = false;
  bool _locationDenied = false;
  final _calculatedDistance = <int, double>{};

  Future<void> _fetchContent(type, {bool keepLimit = false}) async {
    final mainState = Provider.of<MainState>(
      context,
      listen: false,
    );
    final userState = Provider.of<UserState>(
      context,
      listen: false,
    );
    final contentPageState = Provider.of<ContentPageState>(
      context,
      listen: false,
    );

    final lastLength = _items != null ? _items.length : 0;

    final selectedCategory = mainState.selectedCategoryHome[type] ??
        userState.preferredCategories[type];

    _items += await ContentWrapper.fetchItems(
      type,
      search: _searchController.text,
      categoryId: selectedCategory,
      page: _page,
      context: context,
    );

    _items = await ContentWrapper.sortItems(
      _items,
      contentPageState.sortContentBy,
      calculatedDistance: _calculatedDistance,
    );

    if (type == SectionType.pois && !_locationDenied) {
      _items.map((i) => _calculatedDistance[i.id] = i.localDistance);
    }

    if (_searchController.text[0] == '@') {
      _items.where((i) => i.user.username
          .toLowerCase()
          .contains(_searchController.text.replaceAll('@', '').toLowerCase()));
    }

    if (!keepLimit) _page += 1;

    _noMore = lastLength == _items.length ? true : false;
    _fetching = false;
    print(_fetching);
    if (mounted) setState(() {});
  }

  void _resetLimit({bool keepNumber = false}) {
    _items = [];
    _fetching = true;
    _noMore = false;
    if (!keepNumber) _page = 1;
    if (mounted) setState(() {});
  }

  void _setLoadingMore(bool val) {
    _loadingMore = val;
    if (mounted) setState(() {});
  }

  Future<void> _setLocationDenied() async {
    _locationDenied = await ActiveUser.locationPermissionDenied();
    if (mounted) setState(() {});
  }

  void _increasePage() {
    _page += 1;
    if (mounted) setState(() {});
  }

  Widget _getPage(SectionType type) {
    switch (type) {
      case SectionType.publicaciones:
        return Container(
          key: Key('publicaciones-page2'),
          child: ContentCardPage(
            type: SectionType.publicaciones,
            fetching: _fetching,
            noMore: _noMore,
            resetLimit: _resetLimit,
            fetchContent: _fetchContent,
            items: _items,
            increasePage: _increasePage,
            hideFilter: true,
          ),
        );
      case SectionType.recetas:
        return Container(
          key: Key('recetas-page2'),
          child: ContentCardPage(
            type: SectionType.recetas,
            fetching: _fetching,
            noMore: _noMore,
            resetLimit: _resetLimit,
            fetchContent: _fetchContent,
            items: _items,
            increasePage: _increasePage,
            hideFilter: true,
          ),
        );
      case SectionType.pois:
        return PoiPage(
          fetching: _fetching,
          noMore: _noMore,
          resetLimit: _resetLimit,
          fetchContent: _fetchContent,
          items: _items,
          loadingMore: _loadingMore,
          setLoadingMore: _setLoadingMore,
          setLocationDenied: _setLocationDenied,
          locationDenied: _locationDenied,
          increasePage: _increasePage,
          hideFilter: true,
        );
      default:
        return Container(
          key: Key('publicaciones-page2'),
          child: ContentCardPage(
            type: SectionType.publicaciones,
            fetching: _fetching,
            noMore: _noMore,
            resetLimit: _resetLimit,
            fetchContent: _fetchContent,
            items: _items,
            increasePage: _increasePage,
            hideFilter: true,
          ),
        );
    }
  }

  // _reloadPage() async {
  //   if (_searchController.text.isNotEmpty) {
  //     _page = null;
  //     if (mounted) setState(() {});
  //     await Future.delayed(Duration(milliseconds: 300));
  //     _page = _getPage(_type);
  //     if (mounted) setState(() {});
  //   }
  // }

  @override
  void initState() {
    super.initState();
    _type = widget.originalType;
    _searchController.text = widget.originalSearch;
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: SearchField(
          searchController: _searchController,
          onChanged: (val) {
            // _reloadPage();
            _resetLimit();
            _fetchContent(_type);
          },
        ),
        actions: <Widget>[
          SelectorSectionType(
            setActiveType: (type) {
              _type = type;
              if (mounted) setState(() {});
              // _reloadPage();
              _type = type;
              if (mounted) setState(() {});
              _resetLimit();
              _fetchContent(_type);
            },
            activeType: _type,
          ),
        ],
      ),
      body: _getPage(_type),
    );
  }
}
