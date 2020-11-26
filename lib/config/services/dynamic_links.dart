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
import 'package:arrancando/views/user_profile/index.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uni_links/uni_links.dart';

abstract class DynamicLinks {
  static Future<void> buildUserOAuth(BuildContext context, path) async {
    if (context != null) {
      String base64Data = path[1];
      final prefs = await SharedPreferences.getInstance();
      dynamic body = utf8.decode(base64.decode(base64Data));
      await prefs.setString(
        'activeUser',
        '$body',
      );
      context
          .read<UserState>()
          .setActiveUser(ActiveUser.fromJson(json.decode(body)));

      await CategoryWrapper.loadCategories();

      if (prefs.getInt('preferredCiudadId') == null) {
        // int ciudadId = await showDialog(
        //   context: MyGlobals.mainNavigatorKey.currentState.overlay.context,
        //   builder: (_) => DialogCategorySelect(
        //     selectCity: true,
        //     titleText: '¿Cuál es tu ciudad?',
        //     allowDismiss: false,
        //   ),
        // );

        final singleton = GlobalSingleton();

        final ciudadId = singleton.categories[SectionType.publicaciones]
            .where((c) => c.id > 0)
            .first
            .id;
        if (ciudadId != null) {
          context.read<UserState>().setPreferredCategories(
                SectionType.publicaciones,
                ciudadId,
              );
          final prefs = await SharedPreferences.getInstance();
          await prefs.setInt('preferredCiudadId', ciudadId);
        }
      }

      await ActiveUser.updateUserMetadata(context);

      await MyGlobals.mainNavigatorKey.currentState.pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (_) => MainScaffold(),
          settings: RouteSettings(name: 'Home'),
        ),
        (_) => false,
      );
    }
  }

  static Future<void> parseURI(Uri uri, BuildContext context) async {
    if (uri != null) {
      try {
        final path = uri.path.split('/');
        path.retainWhere((p) => p != null && p.isNotEmpty);

        print('Adentro');
        if (uri != null) print(uri.path);

        var _invalidUser = false;

        final prefs = await SharedPreferences.getInstance();
        final activeUser = prefs.getString('activeUser');
        if (activeUser != null) {
          final au = ActiveUser.fromJson(
            json.decode(activeUser),
          );
          if (au.id == null || au.email == null || au.authToken == null) {
            _invalidUser = true;
          }
        } else {
          _invalidUser = true;
        }

        if (path.isNotEmpty) {
          if (path.length >= 2) {
            switch (path[0]) {
              case 'publicaciones':
                if (context != null && !_invalidUser) {
                  final id = int.parse(path[1]);
                  await MyGlobals.mainNavigatorKey.currentState.push(
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
                  final id = int.parse(path[1]);
                  await MyGlobals.mainNavigatorKey.currentState.push(
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
                  final id = int.parse(path[1]);
                  await MyGlobals.mainNavigatorKey.currentState.push(
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
              case 'usuarios':
                if (context != null && !_invalidUser) {
                  final username = path[1];
                  await MyGlobals.mainNavigatorKey.currentState.push(
                    MaterialPageRoute(
                      builder: (_) => UserProfilePage(
                        user: null,
                        username: username,
                      ),
                      settings: RouteSettings(name: 'UserProfilePage'),
                    ),
                  );
                }
                break;
              case 'google-signin':
                await buildUserOAuth(context, path);
                break;
              case 'facebook-signin':
                await buildUserOAuth(context, path);
                break;
              default:
            }
          } else if (context != null) {
            // TODO: SHOULDN'T USE DELAY
            await Future.delayed(Duration(seconds: 1));
            final mainState = context.read<MainState>();
            final contentPageState = context.read<ContentPageState>();
            var q = uri.queryParameters;

            switch (q['sorted_by']) {
              case 'fecha_creacion':
                contentPageState
                    .setContentSortType(ContentSortType.fecha_creacion);
                break;
              case 'fecha_actualizacion':
                contentPageState
                    .setContentSortType(ContentSortType.fecha_actualizacion);
                break;
              case 'proximidad':
                contentPageState.setContentSortType(ContentSortType.proximidad);
                break;
              case 'puntuacion':
                contentPageState.setContentSortType(ContentSortType.puntuacion);
                break;
              case 'vistas':
                contentPageState.setContentSortType(ContentSortType.vistas);
                break;
              default:
            }

            switch (path[0]) {
              case 'publicaciones':
                if (context != null && !_invalidUser) {
                  mainState.setSelectedCategoryHome(
                    SectionType.publicaciones,
                    q['ciudad_id'] != null
                        ? int.tryParse(q['ciudad_id'])
                        : null,
                  );
                  mainState.setSelectedCategoryHome(
                    SectionType.publicaciones_categoria,
                    q['categoria_publicacion_id'] != null
                        ? int.tryParse(q['categoria_publicacion_id'])
                        : null,
                  );
                  mainState.setActivePageHome(SectionType.publicaciones);
                  await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => MainScaffold(),
                    ),
                  );
                  await MyGlobals.firebaseAnalyticsObserver.analytics
                      .setCurrentScreen(
                    screenName: 'Home/Publicaciones',
                  );
                }
                break;
              case 'recetas':
                if (context != null && !_invalidUser) {
                  mainState.setSelectedCategoryHome(
                    SectionType.recetas,
                    q['categoria_receta_id'] != null
                        ? int.tryParse(q['categoria_receta_id'])
                        : null,
                  );
                  mainState.setActivePageHome(SectionType.recetas);
                  await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => MainScaffold(),
                    ),
                  );
                  await MyGlobals.firebaseAnalyticsObserver.analytics
                      .setCurrentScreen(
                    screenName: 'Home/Recetas',
                  );
                }
                break;
              case 'pois':
                if (context != null && !_invalidUser) {
                  mainState.setSelectedCategoryHome(
                    SectionType.pois,
                    q['categoria_poi_id'] != null
                        ? int.tryParse(q['categoria_poi_id'])
                        : null,
                  );
                  mainState.setSelectedCategoryHome(
                    SectionType.pois_ciudad,
                    q['ciudad_id'] != null
                        ? int.tryParse(q['ciudad_id'])
                        : null,
                  );
                  mainState.setActivePageHome(SectionType.pois);
                  await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => MainScaffold(),
                    ),
                  );
                  await MyGlobals.firebaseAnalyticsObserver.analytics
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

  static Future<void> initUniLinks(BuildContext context) async {
    //Parse the uri that started the app
    final uri = await getInitialUri();
    if (uri != null) print(uri.path);
    await DynamicLinks.parseURI(uri, context);
    final streamURI = getUriLinksStream();
    //Parse the uri when the app is started but the user leaves it and comes back
    streamURI.listen(
      (Uri uri) => DynamicLinks.parseURI(uri, context),
      onError: (e) {
        print(e);
      },
    );
  }
}
