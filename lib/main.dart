import 'dart:convert';

import 'package:arrancando/config/globals/enums.dart';
import 'package:arrancando/config/globals/index.dart';
import 'package:arrancando/config/models/active_user.dart';
import 'package:arrancando/config/models/category_wrapper.dart';
import 'package:arrancando/config/models/saved_content.dart';
import 'package:arrancando/config/services/dynamic_links.dart';
import 'package:arrancando/config/state/content_page.dart';
import 'package:arrancando/config/state/main.dart';
import 'package:arrancando/config/state/user.dart';
import 'package:arrancando/views/general/splash.dart';
import 'package:arrancando/views/home/index.dart';
import 'package:arrancando/views/user/login/index.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(
    MultiProvider(
      providers: <SingleChildCloneableWidget>[
        ChangeNotifierProvider(
          create: (BuildContext context) => MainState(),
        ),
        ChangeNotifierProvider(
          create: (BuildContext context) => UserState(),
        ),
        ChangeNotifierProvider(
          create: (BuildContext context) => ContentPageState(),
        ),
      ],
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
  bool _isLoggedIn = false;

  _loadUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String activeUser = prefs.getString("activeUser");
    int preferredCiudadId = prefs.getInt("preferredCiudadId");
    if (activeUser != null) {
      Provider.of<UserState>(context, listen: false).setActiveUser(
        ActiveUser.fromJson(
          json.decode(activeUser),
        ),
      );
      _isLoggedIn = true;
    }
    if (preferredCiudadId != null) {
      Provider.of<UserState>(context, listen: false).setPreferredCategories(
        SectionType.publicaciones,
        preferredCiudadId,
      );
    }
    if (mounted) setState(() {});
  }

  _initApp() async {
    DynamicLinks.initUniLinks(
      context: context,
    );
    await _loadUser();
    if (_isLoggedIn) {
      await CategoryWrapper.loadCategories();
      await SavedContent.initSaved(context);
    }
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
          ? SplashScreen(
              loadData: _initApp,
              toggleStart: () {
                if (mounted)
                  setState(() {
                    _loaded = true;
                  });
              },
            )
          : _isLoggedIn ? MainScaffold() : LoginPage(),
    );
  }
}
