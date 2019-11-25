import 'dart:convert';

import 'package:arrancando/config/globals/enums.dart';
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
  bool _fetching = false;

  Future<void> _fetchContent() async {
    ResponseObject resp = await Fetcher.get(
      url: "/content.json",
    );

    if (resp != null)
      _items = (json.decode(resp.body) as List).map(
        (p) {
          var content = ContentWrapper.fromJson(p);
          content.type = SectionType.values.firstWhere(
            (v) => v.toString() == p['type'],
          );
          return content;
        },
      ).toList();

    _fetching = false;
    if (mounted) setState(() {});
  }

  @override
  void initState() {
    super.initState();
    // _fetchContent();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
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
                : _items != null
                    ? _items.length > 0
                        ? RefreshIndicator(
                            onRefresh: _fetchContent,
                            child: ListView(
                              children: [
                                ..._items
                                    .map(
                                      (p) => Padding(
                                        padding: const EdgeInsets.only(
                                          bottom: 30,
                                        ),
                                        child: SliceContent(
                                          content: p,
                                        ),
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
                        : Text(
                            "No hay elementos para mostrar",
                            textAlign: TextAlign.center,
                          )
                    : Text(
                        "Ocurrió un error",
                        textAlign: TextAlign.center,
                      ),
          )
        ],
      ),
    );
  }
}
