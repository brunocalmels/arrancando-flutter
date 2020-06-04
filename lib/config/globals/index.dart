import 'package:arrancando/config/globals/enums.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';

abstract class MyGlobals {
  static const APP_VERSION = "2.0.8+52";

  static const bool SHOW_DEV_LOGIN = false;
  // static const bool SHOW_DEV_LOGIN = true;

  // static const String SERVER_URL = "http://192.168.0.4:3000";
  // static const String SERVER_URL = "http://192.168.0.11:5000";
  // static const String SERVER_URL = "http://192.168.43.138:5000";
  // static const String SERVER_URL = "http://192.168.1.3:5000";
  static const String SERVER_URL = "https://arrancando.herokuapp.com";
  // static const String SERVER_URL = "https://arrancando-staging.herokuapp.com";

  static const GOOGLE_CLIENT_ID =
      "585563708448-5n5f3dg0ptbbm4p3eoh1l0c4u7fhrbrl.apps.googleusercontent.com";

  static const FACEBOOK_CLIENT_ID = "909518196171089";

  static const GOOGLE_REDIRECT_URI =
      "https://arrancando.herokuapp.com/google-login";

  static const FACEBOOK_REDIRECT_URI =
      "https://arrancando.herokuapp.com/facebook-login";

  static const APPLE_REDIRECT_URI =
      "https://arrancando.herokuapp.com/apple-login";

  static const ICONOS_CATEGORIAS = {
    SectionType.home: Icons.public,
    SectionType.publicaciones: Icons.public,
    SectionType.recetas: Icons.fastfood,
    SectionType.pois: Icons.location_on,
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

  static const int MUCHO_PESO_PUBLICACION = 25000000;

  static FirebaseAnalyticsObserver firebaseAnalyticsObserver =
      FirebaseAnalyticsObserver(
    analytics: FirebaseAnalytics(),
  );

  static const VIDEO_FORMATS = ['mp4', 'mpg', 'mpeg', 'mov'];

  static const Map<String, String> IMAGENES_CATEGORIAS_RECETAS = {
    "Todos": "assets/images/icon.png",
    "Parrilla": "assets/images/content/categories/parrilla.png",
    "Asador": "assets/images/content/categories/asador.png",
    "Olla": "assets/images/content/categories/olla.png",
    "Plancha": "assets/images/content/categories/plancha.png",
    "Disco": "assets/images/content/categories/disco.png",
    "Horno": "assets/images/content/categories/horno.png",
    "Sartén": "assets/images/content/categories/sarten.png",
    "Bowl": "assets/images/content/categories/bowl.png",
    "Wok": "assets/images/content/categories/wok.png",
    "Tragos y Bebidas": "assets/images/content/categories/tragos.png",
  };

  static const List<Map<String, String>> COMPLEJIDAD = [
    {
      "label": "Fácil",
      "value": "Fácil",
    },
    {
      "label": "Media",
      "value": "Media",
    },
    {
      "label": "Dificil",
      "value": "Dificil",
    },
  ];

  static const List<String> UNIDADES = [
    "gr",
    "kg",
    "ml",
    "l",
    "unidad",
    "taza",
    "cucharada",
    "cucharadita",
  ];
}
