import 'dart:io';

import 'package:arrancando/config/globals/index.dart';
import 'package:arrancando/config/services/fetcher.dart';
import 'package:arrancando/views/user/profile/index.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

abstract class NotificacionesService {
  static final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  static Future<dynamic> myBackgroundMessageHandler(
    Map<String, dynamic> message,
  ) {
    print("********************************0");
    print("********************************0");
    print("********************************0");
    print("********************************0");
    print("********************************0");

    print(message.toString());

    if (message.containsKey('data')) {
      // Handle data message
      final dynamic data = message['data'];
    }

    if (message.containsKey('notification')) {
      // Handle notification message
      final dynamic notification = message['notification'];
    }

    Navigator.of(MyGlobals.mainNavigatorKey.currentContext)
        .push(MaterialPageRoute(builder: (_) => ProfilePage()));

    // Or do other work.
    return null;
  }

  static initFirebaseNotifications() async {
    if (Platform.isIOS) {
      await _firebaseMessaging.requestNotificationPermissions(
        IosNotificationSettings(
          sound: true,
          badge: true,
          alert: true,
        ),
      );
      _firebaseMessaging.onIosSettingsRegistered.listen(
        (settings) {
          print("Settings registered");
        },
      );

      _firebaseMessaging.configure(
        onMessage: (message) async {
          print("********************************1");
          print("********************************1");
          print("********************************1");
          print("********************************1");
          print(message);
          Navigator.of(MyGlobals.mainNavigatorKey.currentContext)
              .push(MaterialPageRoute(builder: (_) => ProfilePage()));
        },
        onBackgroundMessage: myBackgroundMessageHandler,
        onLaunch: (message) async {
          print("********************************3");
          print("********************************3");
          print("********************************3");
          print("********************************3");
          print(message);
          Navigator.of(MyGlobals.mainNavigatorKey.currentContext)
              .push(MaterialPageRoute(builder: (_) => ProfilePage()));
        },
        onResume: (message) async {
          print("********************************4");
          print("********************************4");
          print("********************************4");
          print("********************************4");
          print(message);
          Navigator.of(MyGlobals.mainNavigatorKey.currentContext)
              .push(MaterialPageRoute(builder: (_) => ProfilePage()));
        },
      );
    } else {
      await _firebaseMessaging.requestNotificationPermissions();
    }
    String token = await _firebaseMessaging.getToken();
    await Fetcher.put(
      url: "/users/set_firebase_token.json",
      body: {
        "token": token,
      },
    );
  }
}
