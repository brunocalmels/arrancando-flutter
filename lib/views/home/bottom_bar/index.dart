import 'package:arrancando/views/home/bottom_bar/_item.dart';
import 'package:flutter/material.dart';

class MainBottomBar extends StatelessWidget {
  final int activeItem;
  final Function setActiveItem;

  MainBottomBar({
    this.activeItem,
    this.setActiveItem,
  });

  final List<BBItem> _items = [
    BBItem(
      icon: Icons.home,
      text: 'Inicio',
    ),
    BBItem(
      icon: Icons.public,
      text: 'Publicaciones',
    ),
    BBItem(
      icon: Icons.book,
      text: 'Recetas',
    ),
    BBItem(
      icon: Icons.map,
      text: 'Ptos. Interés',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          // width: MediaQuery.of(context).size.width * 0.7,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Colors.black45,
                blurRadius: 3,
              )
            ],
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              bottomLeft: Radius.circular(30),
              topRight: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: _items
                .asMap()
                .map(
                  (i, item) => MapEntry(
                    i,
                    BBButtonItem(
                      activeItem: activeItem,
                      index: i,
                      item: item,
                      setActiveItem: setActiveItem,
                    ),
                  ),
                )
                .values
                .toList(),
          ),
        ),
      ],
    );
  }
}
