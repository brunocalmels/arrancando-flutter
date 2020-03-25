import 'package:arrancando/config/globals/enums.dart';
import 'package:arrancando/views/content_wrapper/new/index.dart';
import 'package:flutter/material.dart';

class MainNewFab extends StatefulWidget {
  @override
  _MainNewFabState createState() => _MainNewFabState();
}

class _MainNewFabState extends State<MainNewFab>
    with SingleTickerProviderStateMixin {
  bool _showAll = false;

  _toggleShow() {
    if (mounted)
      setState(() {
        _showAll = !_showAll;
      });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          AnimatedSize(
            vsync: this,
            duration: Duration(milliseconds: 150),
            curve: Curves.easeInOutBack,
            child: AnimatedOpacity(
              duration: Duration(milliseconds: 150),
              opacity: _showAll ? 1 : 0,
              child: Container(
                width: _showAll ? 200 : 0,
                height: _showAll ? 90 : 0,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    FloatingActionButton(
                      heroTag: "new-publicaciones",
                      onPressed: () {
                        _toggleShow();
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => NewContent(
                              type: SectionType.publicaciones,
                            ),
                            settings: RouteSettings(name: 'Publicaciones#New'),
                          ),
                        );
                      },
                      child: Icon(
                        Icons.public,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Column(
                      children: <Widget>[
                        FloatingActionButton(
                          heroTag: "new-recetas",
                          onPressed: () {
                            _toggleShow();
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => NewContent(
                                  type: SectionType.recetas,
                                ),
                                settings: RouteSettings(name: 'Recetas#New'),
                              ),
                            );
                          },
                          child: Icon(
                            Icons.book,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    FloatingActionButton(
                      heroTag: "new-pois",
                      onPressed: () {
                        _toggleShow();
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => NewContent(
                              type: SectionType.pois,
                            ),
                            settings: RouteSettings(name: 'Pois#New'),
                          ),
                        );
                      },
                      child: Icon(
                        Icons.map,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 40,
                height: 40,
                child: FittedBox(
                  child: FloatingActionButton(
                    backgroundColor: _showAll ? Colors.red[700] : null,
                    onPressed: _toggleShow,
                    child: Icon(
                      _showAll ? Icons.close : Icons.add,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
