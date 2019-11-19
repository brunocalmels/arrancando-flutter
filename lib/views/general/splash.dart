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
  _trigger() async {
    if (widget.loadData != null) await widget.loadData();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool firstTime = prefs.getBool("firstTime");
    if (firstTime == null || firstTime == true) {
      await Future.delayed(Duration(seconds: 5));
      prefs.setBool("firstTime", false);
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
      backgroundColor: Colors.white,
      body: Container(
        child: Center(
          child: Stack(
            fit: StackFit.passthrough,
            children: <Widget>[
              SizedBox(
                width: 200,
                height: 200,
                child: Image.asset(
                  "assets/images/icon-no-fire.png",
                ),
              ),
              Positioned(
                left: 70,
                bottom: 15,
                child: SizedBox(
                  width: 60,
                  height: 60,
                  child: FlareActor(
                    "assets/flare/fuego.flr",
                    animation: 'Fuegando',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
