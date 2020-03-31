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
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
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
  FirebaseAnalytics analytics = FirebaseAnalytics();

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
        fontFamily: 'Monserrat',
        backgroundColor: Color(0xff242a36),
        scaffoldBackgroundColor: Color(0xff232935),
        cardColor: Color(0xff232935),
        dialogBackgroundColor: Color(0xff232935),
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        bottomSheetTheme: BottomSheetThemeData(
          backgroundColor: Color(0xff242a36),
        ),
        primaryColor: Color(0xff222835),
        accentColor: Color(0xff57b668),
        hintColor: Colors.white54,
        textTheme: TextTheme(
          body1: TextStyle(color: Colors.white),
          body2: TextStyle(color: Colors.white),
          title: TextStyle(color: Colors.white),
          display4: TextStyle(color: Colors.white),
          display3: TextStyle(color: Colors.white),
          display2: TextStyle(color: Colors.white),
          display1: TextStyle(color: Colors.white),
          headline: TextStyle(color: Colors.white),
          subhead: TextStyle(color: Colors.white),
          caption: TextStyle(color: Colors.white),
          button: TextStyle(color: Colors.white),
          subtitle: TextStyle(color: Colors.white),
          overline: TextStyle(color: Colors.white),
        ),
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
      navigatorObservers: [
        FirebaseAnalyticsObserver(analytics: analytics),
      ],
    );
  }
}
