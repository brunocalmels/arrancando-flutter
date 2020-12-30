import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:arrancando/config/globals/enums.dart';
import 'package:arrancando/config/globals/index.dart';
import 'package:arrancando/config/models/active_user.dart';
import 'package:arrancando/config/models/category_wrapper.dart';
import 'package:arrancando/config/models/saved_content.dart';
import 'package:arrancando/config/services/utils.dart';
import 'package:arrancando/config/state/content_page.dart';
import 'package:arrancando/config/state/main.dart';
import 'package:arrancando/config/state/user.dart';
import 'package:arrancando/views/general/splash.dart';
import 'package:arrancando/views/home/index.dart';
import 'package:arrancando/views/user/login/index.dart';
import 'package:desktop_window/desktop_window.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sentry/sentry.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  var sentry = SentryClient(
    dsn:
        'https://b6b7f8734d044fe4b3f424207df9462f@o418745.ingest.sentry.io/5370030',
  );

  FlutterError.onError = (details, {bool forceReport = false}) {
    try {
      if (kReleaseMode) {
        sentry.captureException(
          exception: details.exception,
          stackTrace: details.stack,
        );
      }
    } catch (e) {
      print('Sending report to sentry.io failed: $e');
    } finally {
      // Also use Flutter's pretty error logging to the device's console.
      FlutterError.dumpErrorToConsole(details, forceReport: forceReport);
    }
  };

  if (Platform.isLinux) {
    await DesktopWindow.setMaxWindowSize(Size(350, 600));
    await DesktopWindow.setWindowSize(Size(350, 600));
  }

  runZoned(
    () => runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => MainState(),
          ),
          ChangeNotifierProvider(
            create: (context) => UserState(),
          ),
          ChangeNotifierProvider(
            create: (context) => ContentPageState(),
          ),
        ],
        child: MyApp(),
      ),
    ),
    onError: (error, stackTrace) {
      try {
        if (kReleaseMode) {
          sentry.captureException(
            exception: error,
            stackTrace: stackTrace,
          );
        }
      } catch (e) {
        print('Sending report to sentry.io failed: $e');
        print('Original error: $error');
      }
    },
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

  Future<void> _loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    final activeUser = prefs.getString('activeUser');
    final preferredCiudadId = prefs.getInt('preferredCiudadId');
    if (activeUser != null) {
      context.read<UserState>().setActiveUser(
            ActiveUser.fromJson(
              json.decode(activeUser),
            ),
          );
      _isLoggedIn = true;
    }
    if (preferredCiudadId != null) {
      context.read<UserState>().setPreferredCategories(
            SectionType.publicaciones,
            preferredCiudadId,
          );
    }
    if (mounted) setState(() {});
  }

  Future<void> _initApp() async {
    await Utils.restoreThemeMode(context);
    await _loadUser();
    if (_isLoggedIn) {
      // ignore: unawaited_futures
      CategoryWrapper.loadCategories();
      await SavedContent.initSaved(context);
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!Platform.isLinux) {
        await Firebase.initializeApp();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: MyGlobals.mainNavigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'Arrancando',
      themeMode: Utils.activeTheme(context) ?? ThemeMode.dark,
      theme: ThemeData(
        fontFamily: 'Monserrat',
        backgroundColor: Colors.grey,
        scaffoldBackgroundColor: Colors.white,
        cardColor: Colors.grey,
        dialogBackgroundColor: Colors.grey,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        bottomSheetTheme: BottomSheetThemeData(
          backgroundColor: Colors.grey,
        ),
        primaryColor: Colors.grey,
        accentColor: Colors.black,
        hintColor: Colors.black54,
        textTheme: TextTheme(
          bodyText2: TextStyle(color: Colors.black),
          bodyText1: TextStyle(color: Colors.black),
          headline6: TextStyle(color: Colors.black),
          headline1: TextStyle(color: Colors.black),
          headline2: TextStyle(color: Colors.black),
          headline3: TextStyle(color: Colors.black),
          headline4: TextStyle(color: Colors.black),
          headline5: TextStyle(color: Colors.black),
          subtitle1: TextStyle(color: Colors.black),
          caption: TextStyle(color: Colors.black),
          button: TextStyle(color: Colors.black),
          subtitle2: TextStyle(color: Colors.black),
          overline: TextStyle(color: Colors.black),
        ),
      ),
      darkTheme: ThemeData(
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
        colorScheme: ColorScheme.light(
          primary: Color(0xff57b668),
        ),
        textTheme: TextTheme(
          bodyText2: TextStyle(color: Colors.white),
          bodyText1: TextStyle(color: Colors.white),
          headline6: TextStyle(color: Colors.white),
          headline1: TextStyle(color: Colors.white),
          headline2: TextStyle(color: Colors.white),
          headline3: TextStyle(color: Colors.white),
          headline4: TextStyle(color: Colors.white),
          headline5: TextStyle(color: Colors.white),
          subtitle1: TextStyle(color: Colors.white),
          caption: TextStyle(color: Colors.white),
          button: TextStyle(color: Colors.white),
          subtitle2: TextStyle(color: Colors.white),
          overline: TextStyle(color: Colors.white),
        ),
        appBarTheme: AppBarTheme(
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
        ),
      ),
      home: !_loaded
          ? SplashScreen(
              loadData: _initApp,
              toggleStart: () {
                _loaded = true;
                if (mounted) setState(() {});
              },
            )
          : _isLoggedIn
              ? MainScaffold()
              : LoginPage(),
      navigatorObservers: !(Platform.isAndroid || Platform.isIOS)
          ? []
          : [
              MyGlobals.firebaseAnalyticsObserver,
            ],
    );
  }
}
