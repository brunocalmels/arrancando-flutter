import 'package:arrancando/config/services/dynamic_links.dart';
import 'package:arrancando/config/services/fetcher.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

abstract class NotificacionesService {
  static final FirebaseMessaging _firebaseMessaging =
      FirebaseMessaging.instance;

  static Future<void> initFirebaseNotifications(BuildContext context) async {
    await _firebaseMessaging.requestPermission();

    void redirectToURI(RemoteMessage message) {
      if (message != null && message.data != null) {
        if (message.data['url'] != null) {
          DynamicLinks.parseURI(
            Uri.tryParse(message.data['url']),
            context,
          );
        }
      }
    }

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      redirectToURI(message);
    });

    FirebaseMessaging.onMessage.listen(
      (message) async {
        if (message != null && message.data != null) {
          if (message.data['url'] != null) {
            final texto = message.notification != null &&
                    message.notification != null &&
                    message.notification.body != null
                ? message.notification.body
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
                          Uri.parse(message.data['url']),
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
    );

    final token = await _firebaseMessaging.getToken();
    await Fetcher.put(
      url: '/users/set_firebase_token.json',
      body: {
        'token': token,
      },
    );

    final message = await FirebaseMessaging.instance.getInitialMessage();
    redirectToURI(message);
  }
}
