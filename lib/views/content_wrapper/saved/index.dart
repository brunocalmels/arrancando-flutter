import 'dart:convert';

import 'package:arrancando/config/models/content_wrapper.dart';
import 'package:arrancando/config/models/saved_content.dart';
import 'package:arrancando/config/services/fetcher.dart';
import 'package:arrancando/config/state/index.dart';
import 'package:arrancando/views/home/pages/_loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SavedContentPage extends StatefulWidget {
  @override
  _SavedContentPageState createState() => _SavedContentPageState();
}

class _SavedContentPageState extends State<SavedContentPage> {
  List<ContentWrapper> _items;
  bool _fetching = true;

  Future<void> _fetchContent() async {
    ResponseObject resp = await Fetcher.get(
      url:
          "/content.json?data=${json.encode(Provider.of<MyState>(context, listen: false).savedContent)}",
    );

    if (resp?.body != null)
      _items = (json.decode(resp.body) as List)
          .map((p) => ContentWrapper.fromJson(p))
          .toList();

    _fetching = false;
    if (mounted) setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _fetchContent();
  }

  @override
  void didUpdateWidget(SavedContentPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    _fetchContent();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Guardadas",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
      ),
      backgroundColor: Colors.white,
      body: _fetching
          ? LoadingWidget()
          : _items != null
              ? _items.length > 0
                  ? RefreshIndicator(
                      onRefresh: _fetchContent,
                      child: ListView(
                        children: _items
                            .map(
                              (p) => ListTile(
                                title: Text(p.titulo),
                                subtitle: Text(
                                  p.cuerpo,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                trailing: IconButton(
                                  onPressed: () =>
                                      SavedContent.toggleSave(p, context),
                                  icon: Icon(
                                    SavedContent.isSaved(p, context)
                                        ? Icons.bookmark
                                        : Icons.bookmark_border,
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    )
                  : Container(
                      width: MediaQuery.of(context).size.width,
                      child: Text(
                        "No hay elementos guardados",
                        textAlign: TextAlign.center,
                      ),
                    )
              : Container(
                  width: MediaQuery.of(context).size.width,
                  child: Text(
                    "Ocurrió un error",
                    textAlign: TextAlign.center,
                  ),
                ),
    );
  }
}
