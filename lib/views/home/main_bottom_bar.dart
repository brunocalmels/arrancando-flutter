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

  Widget _buildItem(BuildContext context, int index, BBItem item) =>
      GestureDetector(
        child: Container(
          height: 50,
          child: Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(10),
                child: Icon(
                  item.icon,
                  color: activeItem == index
                      ? Theme.of(context).primaryColor
                      : null,
                ),
              ),
              AnimatedContainer(
                duration: Duration(milliseconds: 100),
                width: activeItem == index ? item.text.length * 8.0 : 0,
                child: Text(
                  item.text,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
            ],
          ),
        ),
        onTap: () => setActiveItem(index),
      );

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
              topRight: Radius.circular(30),
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
                    _buildItem(
                      context,
                      i,
                      item,
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

class BBItem {
  IconData icon;
  String text;

  BBItem({
    @required this.icon,
    @required this.text,
  });
}
