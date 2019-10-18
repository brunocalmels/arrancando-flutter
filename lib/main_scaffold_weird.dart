import 'package:flutter/material.dart';

class MainScaffoldWeird extends StatefulWidget {
  @override
  _MainScaffoldWeirdState createState() => _MainScaffoldWeirdState();
}

class _MainScaffoldWeirdState extends State<MainScaffoldWeird> {
  double _w = 0;
  double _l = 0;
  double _h = 0;
  double _s = 100;

  _setBarLarge() {
    _l = MediaQuery.of(context).size.width * 0.05;
    _w = MediaQuery.of(context).size.width * 0.9;
    _h = MediaQuery.of(context).size.height * 0.75;
    _s = 100;
    setState(() {});
  }

  _setBarSmall() {
    _l = MediaQuery.of(context).size.width * 0.125;
    _w = MediaQuery.of(context).size.width * 0.75;
    _h = 60;
    _s = 35;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _setBarLarge();
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: Container(
          color: Colors.red,
          child: CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                iconTheme: IconThemeData(
                  color: Colors.black,
                ),
                floating: true,
                flexibleSpace: Container(
                  color: Colors.black12,
                  child: Center(
                    child: Text('Hola'),
                  ),
                ),
                backgroundColor: Colors.transparent,
                expandedHeight: 85,
                snap: false,
              ),
              SliverFillRemaining(
                child: Stack(
                  fit: StackFit.passthrough,
                  children: <Widget>[
                    Center(
                      child: RaisedButton(
                        onPressed: () {
                          // Navigator.of(context).push(
                          //   MaterialPageRoute(
                          //     builder: (_) => MainScaffoldWeird(),
                          //   ),
                          // );
                        },
                      ),
                    ),
                    AnimatedPositioned(
                      duration: Duration(milliseconds: 150),
                      bottom: 0,
                      left: _l,
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 150),
                        width: _w,
                        height: _h,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30),
                          ),
                        ),
                        child: Center(
                          child: Container(
                            child: Wrap(
                              direction: Axis.horizontal,
                              alignment: WrapAlignment.spaceEvenly,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: <Widget>[
                                IconButton(
                                  iconSize: _s,
                                  onPressed: () {
                                    if (_h == 60) {
                                      _setBarLarge();
                                    } else {
                                      _setBarSmall();
                                    }
                                  },
                                  icon: Icon(
                                    Icons.home,
                                    size: _s,
                                  ),
                                ),
                                IconButton(
                                  iconSize: _s,
                                  onPressed: () {
                                    if (_h == 60) {
                                      _setBarLarge();
                                    } else {
                                      _setBarSmall();
                                    }
                                  },
                                  icon: Icon(
                                    Icons.home,
                                    size: _s,
                                  ),
                                ),
                                IconButton(
                                  iconSize: _s,
                                  onPressed: () {
                                    if (_h == 60) {
                                      _setBarLarge();
                                    } else {
                                      _setBarSmall();
                                    }
                                  },
                                  icon: Icon(
                                    Icons.home,
                                    size: _s,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
