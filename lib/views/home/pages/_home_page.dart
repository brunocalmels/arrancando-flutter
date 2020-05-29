import 'dart:convert';

import 'package:arrancando/config/globals/enums.dart';
import 'package:arrancando/config/models/category_wrapper.dart';
import 'package:arrancando/config/models/content_wrapper.dart';
import 'package:arrancando/config/services/fetcher.dart';
import 'package:arrancando/config/state/main.dart';
import 'package:arrancando/views/cards/card_content.dart';
import 'package:arrancando/views/home/_dialog_contenidos_home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<ContentWrapper> _items = [];
  bool _fetching = true;
  int _page = 1;
  bool _noMore = false;

  Future<void> _fetchContent({bool reset = false}) async {
    if (reset) {
      _items = null;
      _fetching = true;
      _page = 1;
      _noMore = false;
    }

    int lastLength = _items != null ? _items.length : 0;
    List<String> contenidosHome = Provider.of<MainState>(context)
        .contenidosHome
        .map((ch) => ch.toString().split('.').last.toLowerCase())
        .toList();

    ResponseObject resp = await Fetcher.get(
      url:
          "/content.json?page=$_page${contenidosHome != null && contenidosHome.isNotEmpty ? ('&contenidos_home=' + json.encode(contenidosHome)) : ''}",
    );

    if (resp != null && resp.body != null)
      _items += (json.decode(resp.body) as List)
          .map((p) => ContentWrapper.fromJson(p))
          .where((p) => p.habilitado == null || p.habilitado)
          .toList();

    _page += 1;
    _noMore = false;
    if (_items != null && lastLength == _items.length) {
      _noMore = true;
      _page -= 1;
    }
    _fetching = false;
    if (mounted) setState(() {});
  }

  Widget get _plato => GestureDetector(
        onTap: () async {
          List<SectionType> _contenidos = await showDialog(
            context: context,
            builder: (_) => DialogContenidosHome(),
          );
          if (_contenidos != null) {
            await CategoryWrapper.saveContentHome(
              context,
              _contenidos,
            );
            _fetchContent(reset: true);
          }
        },
        child: Image.asset(
          "assets/images/content/index/plato-personalizar.png",
          width: MediaQuery.of(context).size.width * 0.6,
        ),
      );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchContent();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: _fetching
          ? Center(
              child: CircularProgressIndicator(),
            )
          : RefreshIndicator(
              onRefresh: _fetchContent,
              child: _items != null
                  ? _items.length > 0
                      ? Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 7),
                          child: ListView.builder(
                            itemCount: _items.length,
                            itemBuilder: (context, index) {
                              if (index == _items.length - 1 && !_noMore)
                                _fetchContent();
                              Widget item = Padding(
                                padding: const EdgeInsets.only(
                                  bottom: 20,
                                ),
                                // child: SliceContent(
                                //   content: _items[index],
                                // ),
                                child: CardContent(
                                  content: _items[index],
                                ),
                              );
                              if (index == 0)
                                return Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    _plato,
                                    SizedBox(
                                      height: 15,
                                    ),
                                    item,
                                  ],
                                );
                              else if (index == _items.length - 1 && !_noMore)
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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                _plato,
                              ],
                            ),
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
    );
  }
}
