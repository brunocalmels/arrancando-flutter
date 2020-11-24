import 'dart:convert';

import 'package:arrancando/config/globals/enums.dart';
import 'package:arrancando/config/globals/index.dart';
import 'package:arrancando/config/models/usuario.dart';
import 'package:arrancando/config/services/fetcher.dart';
import 'package:arrancando/config/state/content_page.dart';
import 'package:arrancando/views/home/pages/_loading_widget.dart';
import 'package:arrancando/views/search/_search_field.dart';
import 'package:arrancando/views/user_profile/index.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchPageUsers extends StatefulWidget {
  final String originalSearch;

  SearchPageUsers({
    this.originalSearch,
  });

  @override
  _SearchPageUsersState createState() => _SearchPageUsersState();
}

class _SearchPageUsersState extends State<SearchPageUsers> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  List<Usuario> _items = [];
  int _page = 1;
  bool _fetching = true;
  bool _noMore = false;

  Future<void> _fetchContent({bool keepLimit = false}) async {
    int lastLength = _items != null ? _items.length : 0;

    ResponseObject resp = await Fetcher.get(
      url: _searchController.text != null && _searchController.text.isNotEmpty
          ? "/users/usernames.json?search=${Uri.encodeComponent(_searchController.text.replaceAll('@', ''))}&page=$_page"
          : "/users/usernames.json?search=&page=$_page",
    );

    if (resp != null)
      _items += (json.decode(resp.body) as List)
          .map(
            (c) => Usuario.fromJson(c),
          )
          .toList();

    if (!keepLimit) _page += 1;

    _noMore = (lastLength == _items.length || _items.length < 8) ? true : false;
    _fetching = false;
    print(_fetching);
    if (mounted) setState(() {});
  }

  _resetLimit({bool keepNumber = false}) {
    _items = [];
    _fetching = true;
    _noMore = false;
    if (!keepNumber) _page = 1;
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _scrollController?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _searchController.text = widget.originalSearch;
    if (mounted) setState(() {});
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _resetLimit();
      _fetchContent();
      Provider.of<ContentPageState>(context)
          .setContentSortType(ContentSortType.fecha_creacion);
      _scrollController.addListener(
        () {
          if (_scrollController.offset >=
                  _scrollController.position.maxScrollExtent &&
              !_scrollController.position.outOfRange &&
              !_noMore) {
            _fetchContent();
          }
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: SearchField(
          searchController: _searchController,
          onChanged: (val) {
            _resetLimit();
            _fetchContent();
          },
        ),
      ),
      body: _fetching
          ? LoadingWidget()
          : RefreshIndicator(
              onRefresh: () {
                _resetLimit();
                return _fetchContent();
              },
              child: _items != null
                  ? _items.length > 0
                      ? ListView.builder(
                          controller: _scrollController,
                          itemCount: _items.length,
                          itemBuilder: (context, index) {
                            Widget item = Padding(
                              padding: const EdgeInsets.only(bottom: 15),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (_) => UserProfilePage(
                                          user: _items[index],
                                        ),
                                        settings: RouteSettings(
                                          name: "UserProfilePage",
                                        ),
                                      ),
                                    );
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 10,
                                      horizontal: 15,
                                    ),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        CircleAvatar(
                                          radius: 20,
                                          backgroundImage: _items[index] !=
                                                      null &&
                                                  _items[index].avatar != null
                                              ? CachedNetworkImageProvider(
                                                  "${MyGlobals.SERVER_URL}${_items[index].avatar}",
                                                )
                                              : null,
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Expanded(
                                          child: Text(
                                            "@${_items[index].username}",
                                            style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );

                            if (index == _items.length - 1) {
                              if (!_noMore && _items.length > 1)
                                return Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    item,
                                    Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.37,
                                      child: Center(
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              else
                                return Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    item,
                                    Container(
                                      height: 100,
                                      color: Color(0x05000000),
                                    ),
                                  ],
                                );
                            } else
                              return item;
                          },
                        )
                      : ListView(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              child: Text(
                                "No hay elementos para mostrar",
                                textAlign: TextAlign.center,
                              ),
                            )
                          ],
                        )
                  : ListView(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          child: Text(
                            "Ocurrió un error",
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Text(
                          "(Si el problema persiste, cerrá sesión y volvé a iniciar)",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
            ),
    );
  }
}
