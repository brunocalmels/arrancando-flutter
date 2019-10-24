import 'package:arrancando/views/home/pages/_loading_widget.dart';
import 'package:arrancando/views/home/pages/search/_content_tile.dart';
import 'package:flutter/material.dart';

class DataGroup extends StatelessWidget {
  final bool fetching;
  final IconData icon;
  final String title;
  final List<ContentWrapper> items;

  DataGroup({
    this.fetching,
    this.icon,
    this.title,
    this.items,
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
                                ),
                              )
                              .toList(),
                          FlatButton(
                            onPressed: () {},
                            child: Text("VER MÁS"),
                          ),
                        ],
                      ),
      ],
    );
  }
}
