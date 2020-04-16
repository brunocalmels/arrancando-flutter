import 'dart:convert';

import 'package:arrancando/config/globals/enums.dart';
import 'package:arrancando/config/globals/global_singleton.dart';
import 'package:arrancando/config/globals/index.dart';
import 'package:arrancando/config/models/active_user.dart';
import 'package:arrancando/config/models/category_wrapper.dart';
import 'package:arrancando/config/state/content_page.dart';
import 'package:arrancando/config/state/main.dart';
import 'package:arrancando/config/state/user.dart';
import 'package:arrancando/views/content_wrapper/show/index.dart';
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
      Provider.of<UserState>(context, listen: false)
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
          Provider.of<UserState>(context, listen: false).setPreferredCategories(
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
          settings: RouteSettings(name: 'Home'),
        ),
        (_) => false,
      );
    }
  }

  static _parseURI(Uri uri, context) async {
    if (uri != null) {
      try {
        List<String> path = uri.path.split('/');
        path.retainWhere((p) => p != null && p.isNotEmpty);

        print("Adentro");
        if (uri != null) print(uri.path);

        bool _invalidUser = false;

        SharedPreferences prefs = await SharedPreferences.getInstance();
        String activeUser = prefs.getString("activeUser");
        if (activeUser != null) {
          ActiveUser au = ActiveUser.fromJson(
            json.decode(activeUser),
          );
          if (au.id == null || au.email == null || au.authToken == null) {
            _invalidUser = true;
          }
        } else {
          _invalidUser = true;
        }

        if (path.length >= 1) {
          if (path.length >= 2) {
            int id = int.parse(path[1]);

            switch (path[0]) {
              case 'publicaciones':
                if (context != null && !_invalidUser) {
                  MyGlobals.mainNavigatorKey.currentState.push(
                    MaterialPageRoute(
                      builder: (_) => ShowPage(
                        contentId: id,
                        type: SectionType.publicaciones,
                      ),
                      settings: RouteSettings(name: 'Publicaciones#$id'),
                    ),
                  );
                }
                break;
              case 'recetas':
                if (context != null && !_invalidUser) {
                  MyGlobals.mainNavigatorKey.currentState.push(
                    MaterialPageRoute(
                      builder: (_) => ShowPage(
                        contentId: id,
                        type: SectionType.recetas,
                      ),
                      settings: RouteSettings(name: 'Recetas#$id'),
                    ),
                  );
                }
                break;
              case 'pois':
                if (context != null && !_invalidUser) {
                  MyGlobals.mainNavigatorKey.currentState.push(
                    MaterialPageRoute(
                      builder: (_) => ShowPage(
                        contentId: id,
                        type: SectionType.pois,
                      ),
                      settings: RouteSettings(name: 'Pois#$id'),
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
          } else if (context != null) {
            // TODO: SHOULDN'T USE DELAY
            await Future.delayed(Duration(seconds: 1));
            MainState mainState = Provider.of<MainState>(
              context,
              listen: false,
            );
            ContentPageState contentPageState = Provider.of<ContentPageState>(
              context,
              listen: false,
            );
            var q = uri.queryParameters;

            switch (q['sorted_by']) {
              case 'fecha':
                contentPageState.setContentSortType(ContentSortType.fecha);
                break;
              case 'proximidad':
                contentPageState.setContentSortType(ContentSortType.proximidad);
                break;
              case 'puntuacion':
                contentPageState.setContentSortType(ContentSortType.puntuacion);
                break;
              default:
            }

            switch (path[0]) {
              case 'publicaciones':
                if (context != null && !_invalidUser) {
                  mainState.setSelectedCategoryHome(
                    SectionType.publicaciones,
                    int.tryParse(q['ciudad_id']),
                  );
                  mainState.setSelectedCategoryHome(
                    SectionType.publicaciones_categoria,
                    int.tryParse(q['categoria_publicacion_id']),
                  );
                  mainState.setActivePageHome(SectionType.publicaciones);
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => MainScaffold(),
                    ),
                  );
                  MyGlobals.firebaseAnalyticsObserver.analytics
                      .setCurrentScreen(
                    screenName: 'Home/Publicaciones',
                  );
                }
                break;
              case 'recetas':
                if (context != null && !_invalidUser) {
                  mainState.setSelectedCategoryHome(
                    SectionType.recetas,
                    int.tryParse(q['categoria_receta_id']),
                  );
                  mainState.setActivePageHome(SectionType.recetas);
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => MainScaffold(),
                    ),
                  );
                  MyGlobals.firebaseAnalyticsObserver.analytics
                      .setCurrentScreen(
                    screenName: 'Home/Recetas',
                  );
                }
                break;
              case 'pois':
                if (context != null && !_invalidUser) {
                  mainState.setSelectedCategoryHome(
                    SectionType.pois,
                    int.tryParse(q['categoria_poi_id']),
                  );
                  mainState.setSelectedCategoryHome(
                    SectionType.pois_ciudad,
                    int.tryParse(q['ciudad_id']),
                  );
                  mainState.setActivePageHome(SectionType.pois);
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => MainScaffold(),
                    ),
                  );
                  MyGlobals.firebaseAnalyticsObserver.analytics
                      .setCurrentScreen(
                    screenName: 'Home/Pois',
                  );
                }
                break;
            }
          }
        }
      } catch (e) {
        print(e);
      }
    }
  }

  static initUniLinks({BuildContext context}) async {
    //Parse the uri that started the app
    Uri uri = await getInitialUri();
    print("Afuera");
    if (uri != null) print(uri.path);
    _parseURI(uri, context);
    Stream<Uri> streamURI = getUriLinksStream();
    //Parse the uri when the app is started but the user leaves it and comes back
    streamURI.listen(
      (Uri uri) => _parseURI(uri, context),
      onError: (e) {
        print(e);
      },
    );
  }
}
