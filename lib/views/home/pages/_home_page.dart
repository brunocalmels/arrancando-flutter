import 'dart:convert';

import 'package:arrancando/config/models/content_wrapper.dart';
import 'package:arrancando/config/services/fetcher.dart';
import 'package:arrancando/views/cards/slice_content.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<ContentWrapper> _items = [];
  bool _fetching = true;
  int _offset = -5;
  bool _noMore = false;

  Future<void> _fetchContent() async {
    int lastLength = _items != null ? _items.length : 0;
    ResponseObject resp = await Fetcher.get(
      url: "/content.json?offset=${_offset + 5}",
    );

    if (resp != null)
      _items = (json.decode(resp.body) as List)
          .map((p) => ContentWrapper.fromJson(p))
          .toList();

    _fetching = false;
    _offset += 5;
    _noMore = lastLength == _items.length ? true : false;
    if (mounted) setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _fetchContent();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: <Widget>[
          Positioned.fill(
            child: Center(
              child: Opacity(
                opacity: 0.25,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.6,
                  height: MediaQuery.of(context).size.width * 0.6,
                  child: Image.asset(
                    "assets/images/marca.jpg",
                  ),
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: _fetching
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : RefreshIndicator(
                    onRefresh: _fetchContent,
                    child: _items != null
                        ? _items.length > 0
                            ? Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 7),
                                child: ListView.builder(
                                  itemCount: _items.length,
                                  itemBuilder: (context, index) {
                                    if (index == _items.length - 1 && !_noMore)
                                      _fetchContent();
                                    Widget item = Padding(
                                      padding: const EdgeInsets.only(
                                        bottom: 20,
                                      ),
                                      child: SliceContent(
                                        content: _items[index],
                                      ),
                                    );
                                    if (index == 0)
                                      return Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          SizedBox(
                                            height: 7,
                                          ),
                                          item,
                                        ],
                                      );
                                    else if (index == _items.length - 1 &&
                                        !_noMore)
                                      return Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          item,
                                          Center(
                                            child: CircularProgressIndicator(),
                                          ),
                                        ],
                                      );
                                    else
                                      return item;
                                  },
                                ),
                              )
                            : ListView(
                                children: [
                                  Text(
                                    "No hay elementos para mostrar",
                                    textAlign: TextAlign.center,
                                  )
                                ],
                              )
                        : ListView(
                            children: [
                              Text(
                                "Ocurrió un error",
                                textAlign: TextAlign.center,
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
          )
        ],
      ),
    );
  }
}
