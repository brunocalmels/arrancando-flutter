import 'package:flutter/material.dart';

class MainNewFab extends StatefulWidget {
  @override
  _MainNewFabState createState() => _MainNewFabState();
}

class _MainNewFabState extends State<MainNewFab>
    with SingleTickerProviderStateMixin {
  bool _showAll = false;

  _toggleShow() {
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
                      onPressed: () {},
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
                          onPressed: () {},
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
                      onPressed: () {},
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
                    backgroundColor:
                        _showAll ? Theme.of(context).primaryColor : null,
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
