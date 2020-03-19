import 'package:arrancando/config/globals/enums.dart';
import 'package:flutter/material.dart';

abstract class MyGlobals {
  static const bool SHOW_DEV_LOGIN = false;
  // static const bool SHOW_DEV_LOGIN = true;

  // static const String SERVER_URL = "http://192.168.0.4:5050";
  // static const String SERVER_URL = "http://192.168.0.11:5000";
  // static const String SERVER_URL = "http://192.168.43.138:5000";
  // static const String SERVER_URL = "http://192.168.1.3:5000";
  // static const String SERVER_URL = "https://arrancando.herokuapp.com";
  static const String SERVER_URL = "https://arrancando-staging.herokuapp.com";

  static const GOOGLE_CLIENT_ID =
      "585563708448-5n5f3dg0ptbbm4p3eoh1l0c4u7fhrbrl.apps.googleusercontent.com";

  static const FACEBOOK_CLIENT_ID = "909518196171089";

  static const GOOGLE_REDIRECT_URI =
      "https://arrancando.herokuapp.com/google-login";

  static const FACEBOOK_REDIRECT_URI =
      "https://arrancando.herokuapp.com/facebook-login";

  static const APPLE_REDIRECT_URI =
      "https://arrancando.herokuapp.com/apple-login";

  static const APP_VERSION = "1.1.15+30";

  static const ICONOS_CATEGORIAS = {
    SectionType.home: Icons.select_all,
    SectionType.publicaciones: Icons.public,
    SectionType.recetas: Icons.book,
    SectionType.pois: Icons.map,
  };

  static const NOMBRES_CATEGORIAS = {
    SectionType.home: "Inicio",
    SectionType.publicaciones: "Publicaciones",
    SectionType.recetas: "Recetas",
    SectionType.pois: "Ptos. Interés",
  };

  static const NOMBRES_CATEGORIAS_SINGULAR = {
    SectionType.home: "Inicio",
    SectionType.publicaciones: "Publicación",
    SectionType.recetas: "Receta",
    SectionType.pois: "Pto. Interés",
  };

  static final GlobalKey<NavigatorState> mainNavigatorKey =
      GlobalKey<NavigatorState>();
  static final GlobalKey<ScaffoldState> mainScaffoldKey =
      GlobalKey<ScaffoldState>();
}
