import 'dart:convert';

import 'package:arrancando/config/globals/enums.dart';
import 'package:arrancando/config/globals/index.dart';
import 'package:arrancando/config/models/content_wrapper.dart';
import 'package:arrancando/config/services/fetcher.dart';
import 'package:arrancando/config/state/index.dart';
import 'package:arrancando/views/cards/card_content.dart';
import 'package:arrancando/views/home/pages/_loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ContentCardPage extends StatefulWidget {
  final String rootUrl;
  final SectionType type;
  final String categoryParam;
  final String searchTerm;

  ContentCardPage({
    @required this.rootUrl,
    @required this.type,
    @required this.categoryParam,
    this.searchTerm,
  });

  @override
  _ContentCardPageState createState() => _ContentCardPageState();
}

class _ContentCardPageState extends State<ContentCardPage> {
  List<ContentWrapper> _items;
  bool _fetching = true;

  Future<void> _fetchContent() async {
    int selectedCategory = Provider.of<MyState>(context, listen: false)
                .selectedCategoryHome[widget.type] !=
            null
        ? Provider.of<MyState>(context, listen: false)
            .selectedCategoryHome[widget.type]
        : Provider.of<MyState>(context, listen: false)
            .preferredCategories[widget.type];

    ResponseObject resp = await Fetcher.get(
      url: widget.searchTerm != null && widget.searchTerm.isNotEmpty
          ? "${widget.rootUrl}/search.json?term=${widget.searchTerm}"
          : "${widget.rootUrl}.json${selectedCategory != null ? "?" + "${widget.categoryParam}" + "=" + "$selectedCategory" : ''}",
    );

    if (resp != null)
      _items = (json.decode(resp.body) as List).map(
        (p) {
          var content = ContentWrapper.fromJson(p);
          content.type = widget.type;
          return content;
        },
      ).toList();

    _fetching = false;
    if (mounted) setState(() {});
  }

  _changeListener() {
    if (Provider.of<MyState>(context, listen: false)
            .selectedCategoryHome[widget.type] !=
        null) _fetchContent();
  }

  @override
  void initState() {
    super.initState();
    _fetchContent();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<MyState>(MyGlobals.mainNavigatorKey.currentContext)
          .addListener(_changeListener);
    });
  }

  @override
  void dispose() {
    Provider.of<MyState>(MyGlobals.mainNavigatorKey.currentContext)
        .removeListener(_changeListener);
    super.dispose();
  }

  @override
  void didUpdateWidget(ContentCardPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    _fetchContent();
  }

  @override
  Widget build(BuildContext context) {
    return _fetching
        ? LoadingWidget()
        : _items != null
            ? _items.length > 0
                ? RefreshIndicator(
                    onRefresh: _fetchContent,
                    child: ListView(
                      children: [
                        ..._items
                            .map(
                              (p) => CardContent(
                                content: p,
                              ),
                            )
                            .toList(),
                        Container(
                          height: 100,
                          color: Color(0x05000000),
                        ),
                      ],
                    ),
                  )
                : Text("No hay elementos para mostrar")
            : Text("Ocurrió un error");
  }
}
