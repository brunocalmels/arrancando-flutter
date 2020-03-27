import 'package:arrancando/config/globals/enums.dart';
import 'package:arrancando/config/state/main.dart';
import 'package:arrancando/views/general/glower.dart';
import 'package:arrancando/views/home/bottom_bar/_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainBottomBar extends StatelessWidget {
  final Function setSearchVisibility;

  MainBottomBar({
    this.setSearchVisibility,
  });

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
    // return Row(
    //   mainAxisSize: MainAxisSize.min,
    //   crossAxisAlignment: CrossAxisAlignment.center,
    //   mainAxisAlignment: MainAxisAlignment.center,
    //   children: <Widget>[
    //     Container(
    //       // width: MediaQuery.of(context).size.width * 0.7,
    //       decoration: BoxDecoration(
    //         color: Provider.of<MainState>(context).activePageHome == SectionType.home ? Theme.of(context).accentColor :  Colors.white,
    //         boxShadow: <BoxShadow>[
    //           BoxShadow(
    //             color: Colors.black45,
    //             blurRadius: 3,
    //           )
    //         ],
    //         borderRadius: BorderRadius.only(
    //           topLeft: Radius.circular(30),
    //           bottomLeft: Radius.circular(30),
    //           topRight: Radius.circular(30),
    //           bottomRight: Radius.circular(30),
    //         ),
    //       ),
    //       child: Row(
    //         mainAxisSize: MainAxisSize.min,
    //         mainAxisAlignment: MainAxisAlignment.center,
    //         children: _items
    //             .map(
    //               (i) => BBButtonItem(
    //                 item: i,
    //                 setSearchVisibility: setSearchVisibility,
    //               ),
    //             )
    //             .toList(),
    //       ),
    //     ),
    //   ],
    // );
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
            Expanded(
              child: Material(
                color: Colors.transparent,
                type: MaterialType.circle,
                child: InkWell(
                  onTap: () {
                    Provider.of<MainState>(context, listen: false)
                        .setActivePageHome(SectionType.home);
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.home,
                        color: Provider.of<MainState>(context).activePageHome ==
                                SectionType.home
                            ? Theme.of(context).accentColor
                            : Colors.white,
                      ),
                      Text(
                        "Home",
                        style: TextStyle(
                          color:
                              Provider.of<MainState>(context).activePageHome ==
                                      SectionType.home
                                  ? Theme.of(context).accentColor
                                  : Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: Material(
                color: Colors.transparent,
                type: MaterialType.circle,
                child: InkWell(
                  onTap: () {
                    Provider.of<MainState>(context, listen: false)
                        .setActivePageHome(SectionType.recetas);
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.fastfood,
                        color: Provider.of<MainState>(context).activePageHome ==
                                SectionType.recetas
                            ? Theme.of(context).accentColor
                            : Colors.white,
                      ),
                      Text(
                        "Recetas",
                        style: TextStyle(
                          color:
                              Provider.of<MainState>(context).activePageHome ==
                                      SectionType.recetas
                                  ? Theme.of(context).accentColor
                                  : Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(),
            ),
            Expanded(
              child: Material(
                color: Colors.transparent,
                type: MaterialType.circle,
                child: InkWell(
                  onTap: () {
                    Provider.of<MainState>(context, listen: false)
                        .setActivePageHome(SectionType.pois);
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.location_on,
                        color: Provider.of<MainState>(context).activePageHome ==
                                SectionType.pois
                            ? Theme.of(context).accentColor
                            : Colors.white,
                      ),
                      Text(
                        "P. Interés",
                        style: TextStyle(
                          color:
                              Provider.of<MainState>(context).activePageHome ==
                                      SectionType.pois
                                  ? Theme.of(context).accentColor
                                  : Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: Material(
                color: Colors.transparent,
                type: MaterialType.circle,
                child: InkWell(
                  onTap: () {
                    Provider.of<MainState>(context, listen: false)
                        .setActivePageHome(SectionType.home);
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.library_books,
                        color: Provider.of<MainState>(context).activePageHome ==
                                SectionType.wiki
                            ? Theme.of(context).accentColor
                            : Colors.white,
                      ),
                      Text(
                        "Wiki",
                        style: TextStyle(
                          color:
                              Provider.of<MainState>(context).activePageHome ==
                                      SectionType.wiki
                                  ? Theme.of(context).accentColor
                                  : Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
