import 'package:arrancando/config/globals/enums.dart';
import 'package:arrancando/config/models/content_wrapper.dart';
import 'package:arrancando/views/home/pages/_loading_widget.dart';
import 'package:arrancando/views/home/pages/fast_search/_content_tile.dart';
import 'package:arrancando/views/search/index.dart';
import 'package:flutter/material.dart';

class DataGroup extends StatelessWidget {
  final bool fetching;
  final IconData icon;
  final String title;
  final List<ContentWrapper> items;
  final SectionType type;
  final TextEditingController searchController;

  DataGroup({
    this.fetching,
    this.icon,
    this.title,
    this.items,
    this.type,
    this.searchController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          color: Colors.black12,
          height: 30,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              children: <Widget>[
                Icon(icon),
                Text(title),
              ],
            ),
          ),
        ),
        fetching
            ? LoadingWidget(
                height: 200,
              )
            : items == null
                ? Container(
                    height: 100,
                    child: Center(
                      child: Text('Ocurrió un error'),
                    ),
                  )
                : items.length == 0
                    ? Container(
                        height: 100,
                        child: Center(
                          child: Text("No se encontraron resultados"),
                        ),
                      )
                    : Column(
                        children: <Widget>[
                          ...items
                              .map(
                                (i) => ContentTile(
                                  content: i,
                                  type: type,
                                ),
                              )
                              .toList(),
                          FlatButton(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => SearchPage(
                                      originalType: type,
                                      originalSearch: searchController.text),
                                  settings: RouteSettings(name: 'Search'),
                                ),
                              );
                            },
                            child: Text("VER MÁS"),
                          ),
                        ],
                      ),
      ],
    );
  }
}
