import 'dart:convert';

import 'package:arrancando/config/globals/index.dart';
import 'package:arrancando/config/models/active_user.dart';
import 'package:arrancando/config/models/category_wrapper.dart';
import 'package:arrancando/config/state/index.dart';
import 'package:arrancando/views/home/index.dart';
import 'package:arrancando/views/user/login/index.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      builder: (context) => MyState(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _loaded = false;

  _loadUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String activeUser = prefs.getString("activeUser");
    if (activeUser != null) {
      Provider.of<MyState>(context, listen: false).setActiveUser(
        ActiveUser.fromJson(
          json.decode(activeUser),
        ),
      );
    }
    if (mounted)
      setState(() {
        _loaded = true;
      });
  }

  _initApp() async {
    await _loadUser();
    if (Provider.of<MyState>(context, listen: false).activeUser != null) {
      await CategoryWrapper.loadCategories();
    }
  }

  @override
  void initState() {
    super.initState();
    _initApp();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: MyGlobals.mainNavigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'Arrancando',
      theme: ThemeData(
        fontFamily: 'Nunito',
        primaryColor: Color(0xff446622),
        accentColor: Color(0xffeab01e),
      ),
      home: !_loaded
          ? Scaffold()
          : Provider.of<MyState>(context, listen: false).activeUser == null
              ? LoginPage()
              : MainScaffold(),
    );
  }
}
