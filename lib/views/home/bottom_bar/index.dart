import 'package:arrancando/config/globals/enums.dart';
import 'package:arrancando/config/globals/index.dart';
import 'package:arrancando/config/state/main.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainBottomBar extends StatelessWidget {
  final Function setSearchVisibility;
  final Map<SectionType, Map<String, dynamic>> _items = {
    SectionType.home: {
      'texto': 'Home',
      'icono': Icons.home,
    },
    SectionType.publicaciones: {
      'texto': 'Pubs',
      'icono': Icons.public,
    },
    SectionType.recetas: {
      'texto': 'Recetas',
      'icono': Icons.fastfood,
    },
    SectionType.pois: {
      'texto': 'Market',
      'icono': Icons.location_on,
    },
    SectionType.wiki: {
      'texto': 'Wiki',
      'icono': Icons.library_books,
    },
  };

  MainBottomBar({
    this.setSearchVisibility,
  });

  Widget _buildMenuItem(BuildContext context, SectionType type) => Expanded(
        child: Material(
          color: Colors.transparent,
          type: MaterialType.circle,
          child: InkWell(
            onTap: () {
              context.read<MainState>().setActivePageHome(type);
              MyGlobals.firebaseAnalyticsObserver.analytics.setCurrentScreen(
                screenName: 'Home/${_items[type]['texto']}',
              );
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Icon(
                  _items[type]['icono'],
                  color: context.select<MainState, SectionType>(
                              (value) => value.activePageHome) ==
                          type
                      ? Theme.of(context).accentColor
                      : null,
                ),
                Text(
                  _items[type]['texto'],
                  softWrap: false,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: context.select<MainState, SectionType>(
                                (value) => value.activePageHome) ==
                            type
                        ? Theme.of(context).accentColor
                        : null,
                  ),
                ),
              ],
            ),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: CircularNotchedRectangle(),
      notchMargin: 5,
      elevation: 30,
      color: Theme.of(context).backgroundColor,
      child: Container(
        height: 70,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildMenuItem(context, SectionType.home),
            _buildMenuItem(context, SectionType.publicaciones),
            Expanded(
              child: Container(),
            ),
            _buildMenuItem(context, SectionType.recetas),
            _buildMenuItem(context, SectionType.pois),
          ],
        ),
      ),
    );
  }
}
