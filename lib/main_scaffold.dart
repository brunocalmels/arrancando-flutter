import 'package:arrancando/general/app_bar.dart';
import 'package:flutter/material.dart';

class MainScaffold extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: Container(
          child: CustomScrollView(
            slivers: <Widget>[
              MainAppBar(),
              SliverFillRemaining(
                child: Container(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
