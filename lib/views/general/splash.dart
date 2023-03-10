import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  final Function loadData;
  final Function toggleStart;

  SplashScreen({
    this.loadData,
    this.toggleStart,
  });

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Future<void> _trigger() async {
    if (widget.loadData != null) await widget.loadData();
    final prefs = await SharedPreferences.getInstance();
    final firstTime = prefs.getBool('firstTime');
    if (firstTime == null || firstTime == true) {
      await Future.delayed(Duration(seconds: 5));
      await prefs.setBool('firstTime', false);
    }
    if (widget.toggleStart != null) widget.toggleStart();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _trigger();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Container(
        child: Center(
          // child: Stack(
          //   fit: StackFit.passthrough,
          //   children: <Widget>[
          //     SizedBox(
          //       width: 200,
          //       height: 200,
          //       child: Image.asset(
          //         'assets/images/icon.png',
          //       ),
          //     ),
          //     Positioned(
          //       left: 70,
          //       bottom: 15,
          //       child:
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.8,
            height: MediaQuery.of(context).size.width * 0.8,
            child: FlareActor(
              // 'assets/flare/fuego.flr',
              'assets/flare/logo.flr',
              // animation: 'Fuegando',
              animation: 'Splash2',
            ),
          ),
          //       ),
          //     ],
          //   ),
        ),
      ),
    );
  }
}
