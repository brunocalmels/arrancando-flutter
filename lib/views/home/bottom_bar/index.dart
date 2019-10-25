import 'package:arrancando/config/globals/enums.dart';
import 'package:arrancando/views/home/bottom_bar/_item.dart';
import 'package:flutter/material.dart';

class MainBottomBar extends StatelessWidget {
  final List<BBItem> _items = [
    BBItem(
      icon: Icons.home,
      text: 'Inicio',
      value: SectionType.home,
    ),
    BBItem(
      icon: Icons.public,
      text: 'Publicaciones',
      value: SectionType.publicaciones,
    ),
    BBItem(
      icon: Icons.book,
      text: 'Recetas',
      value: SectionType.recetas,
    ),
    BBItem(
      icon: Icons.map,
      text: 'Ptos. Interés',
      value: SectionType.pois,
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
                .map(
                  (i) => BBButtonItem(
                    item: i,
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }
}
