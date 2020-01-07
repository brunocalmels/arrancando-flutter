import 'dart:convert';

import 'package:arrancando/config/globals/enums.dart';
import 'package:arrancando/config/globals/global_singleton.dart';
import 'package:arrancando/config/globals/index.dart';
import 'package:arrancando/config/models/active_user.dart';
import 'package:arrancando/config/models/category_wrapper.dart';
import 'package:arrancando/config/state/index.dart';
import 'package:arrancando/views/content_wrapper/show/index.dart';
// import 'package:arrancando/views/home/app_bar/_dialog_category_select.dart';
import 'package:arrancando/views/home/index.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uni_links/uni_links.dart';

abstract class DynamicLinks {
  static buildUserOAuth(context, path) async {
    if (context != null) {
      String base64Data = path[1];
      SharedPreferences prefs = await SharedPreferences.getInstance();
      dynamic body = utf8.decode(base64.decode(base64Data));
      prefs.setString(
        'activeUser',
        "$body",
      );
      Provider.of<MyState>(context, listen: false)
          .setActiveUser(ActiveUser.fromJson(json.decode(body)));

      await CategoryWrapper.loadCategories();

      if (prefs.getInt("preferredCiudadId") == null) {
        // int ciudadId = await showDialog(
        //   context: MyGlobals.mainNavigatorKey.currentState.overlay.context,
        //   builder: (_) => DialogCategorySelect(
        //     selectCity: true,
        //     titleText: "¿Cuál es tu ciudad?",
        //     allowDismiss: false,
        //   ),
        // );

        final GlobalSingleton singleton = GlobalSingleton();

        int ciudadId = singleton.categories[SectionType.publicaciones]
            .where((c) => c.id > 0)
            .first
            .id;
        if (ciudadId != null) {
          Provider.of<MyState>(context, listen: false).setPreferredCategories(
            SectionType.publicaciones,
            ciudadId,
          );
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setInt("preferredCiudadId", ciudadId);
        }
      }

      MyGlobals.mainNavigatorKey.currentState.pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (_) => MainScaffold(),
        ),
        (_) => false,
      );
    }
  }

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
                case 'publicaciones':
                  if (context != null) {
                    int id = int.parse(path[1]);

                    MyGlobals.mainNavigatorKey.currentState.push(
                      MaterialPageRoute(
                        builder: (_) => ShowPage(
                          contentId: id,
                          type: SectionType.publicaciones,
                        ),
                      ),
                    );
                  }
                  break;
                case 'recetas':
                  if (context != null) {
                    int id = int.parse(path[1]);

                    MyGlobals.mainNavigatorKey.currentState.push(
                      MaterialPageRoute(
                        builder: (_) => ShowPage(
                          contentId: id,
                          type: SectionType.recetas,
                        ),
                      ),
                    );
                  }
                  break;
                case 'pois':
                  if (context != null) {
                    int id = int.parse(path[1]);

                    MyGlobals.mainNavigatorKey.currentState.push(
                      MaterialPageRoute(
                        builder: (_) => ShowPage(
                          contentId: id,
                          type: SectionType.pois,
                        ),
                      ),
                    );
                  }
                  break;
                case 'google-signin':
                  buildUserOAuth(context, path);
                  break;
                case 'facebook-signin':
                  buildUserOAuth(context, path);
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
