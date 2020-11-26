import 'dart:io';

import 'package:arrancando/config/services/dynamic_links.dart';
import 'package:arrancando/config/services/fetcher.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

abstract class NotificacionesService {
  static final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  static Future<void> initFirebaseNotifications(BuildContext context) async {
    if (Platform.isIOS) {
      await _firebaseMessaging.requestNotificationPermissions(
        IosNotificationSettings(
          sound: true,
          badge: true,
          alert: true,
        ),
      );
    } else {
      await _firebaseMessaging.requestNotificationPermissions();
    }
    _firebaseMessaging.onIosSettingsRegistered.listen(
      (settings) {
        print('Settings registered');
      },
    );

    _firebaseMessaging.configure(
      onMessage: (message) async {
        if (message != null && message['data'] != null) {
          if (message['data']['url'] != null) {
            String texto = message['notification'] != null &&
                    message['notification'] != null &&
                    message['notification']['body'] != null
                ? message['notification']['body']
                : 'Nueva notificación';

            OverlayEntry entry;

            entry = OverlayEntry(
              builder: (_) => Positioned(
                top: 0,
                left: 0,
                child: SafeArea(
                  child: Material(
                    color: Color(0xff161a25),
                    child: InkWell(
                      onTap: () {
                        entry?.remove();
                        entry = null;
                        DynamicLinks.parseURI(
                          Uri.parse(message['data']['url']),
                          context,
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color(0xff161a25),
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 5,
                              color: Colors.black12,
                            ),
                          ],
                        ),
                        width: MediaQuery.of(context).size.width,
                        padding: const EdgeInsets.all(20),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Text(texto),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );

            Overlay.of(context).insert(entry);

            await Future.delayed(Duration(seconds: 5));

            entry?.remove();
            entry = null;
          }
        }
      },
      onLaunch: (message) async {
        if (message != null && message['data'] != null) {
          if (message['data']['url'] != null) {
            await DynamicLinks.parseURI(
              Uri.parse(message['data']['url']),
              context,
            );
          }
        }
      },
      onResume: (message) async {
        if (message != null && message['data'] != null) {
          if (message['data']['url'] != null) {
            await DynamicLinks.parseURI(
              Uri.parse(message['data']['url']),
              context,
            );
          }
        }
      },
    );

    final token = await _firebaseMessaging.getToken();
    await Fetcher.put(
      url: '/users/set_firebase_token.json',
      body: {
        'token': token,
      },
    );
  }
}
