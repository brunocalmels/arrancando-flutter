import 'dart:convert';

import 'package:arrancando/config/globals/index.dart';
import 'package:arrancando/config/models/active_user.dart';
import 'package:arrancando/config/models/category_wrapper.dart';
import 'package:arrancando/config/state/index.dart';
import 'package:arrancando/views/home/index.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uni_links/uni_links.dart';

abstract class DynamicLinks {
  static initUniLinks({BuildContext context}) async {
    Stream<Uri> streamURI = getUriLinksStream();
    streamURI.listen(
      (Uri uri) async {
        if (uri != null) {
          try {
            List<String> path = uri.path.split('/');
            path.retainWhere((p) => p != null && p != "");

            if (path[0] != null && path[1] != null) {
              switch (path[0]) {
                case 'google-signin':
                  if (context != null) {
                    String base64Data = path[1];
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    dynamic body = utf8.decode(base64.decode(base64Data));
                    prefs.setString(
                      'activeUser',
                      "$body",
                    );
                    Provider.of<MyState>(context, listen: false)
                        .setActiveUser(ActiveUser.fromJson(json.decode(body)));

                    await CategoryWrapper.loadCategories();

                    MyGlobals.mainNavigatorKey.currentState.pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (_) => MainScaffold(),
                      ),
                      (_) => false,
                    );
                  }
                  break;
                default:
              }
            }
          } catch (e) {
            print(e);
          }
        }
      },
      onError: (e) {
        print(e);
      },
    );
  }
}
