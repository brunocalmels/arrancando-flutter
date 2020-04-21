import 'package:arrancando/config/globals/enums.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';

abstract class MyGlobals {
  static const APP_VERSION = "1.2.7+43";

  // static const bool SHOW_DEV_LOGIN = false;
  static const bool SHOW_DEV_LOGIN = true;

  static const String SERVER_URL = "http://192.168.0.4:5050";
  // static const String SERVER_URL = "http://192.168.0.11:5000";
  // static const String SERVER_URL = "http://192.168.43.138:5000";
  // static const String SERVER_URL = "http://192.168.1.3:5000";
  // static const String SERVER_URL = "https://arrancando.herokuapp.com";
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
  static const List CATEGORIAS_RECETA = [
    {
      "id": 1,
      "titulo": "Parrilla",
      "imagen": "assets/images/content/categories/parrilla.png",
    },
    {
      "id": 2,
      "titulo": "Asador",
      "imagen": "assets/images/content/categories/asador.png",
    },
    {
      "id": 3,
      "titulo": "Olla",
      "imagen": "assets/images/content/categories/olla.png",
    },
    {
      "id": 4,
      "titulo": "Plancha",
      "imagen": "assets/images/content/categories/plancha.png",
    },
    {
      "id": 5,
      "titulo": "Disco",
      "imagen": "assets/images/content/categories/disco.png",
    },
    {
      "id": 6,
      "titulo": "Horno",
      "imagen": "assets/images/content/categories/horno.png",
    },
    {
      "id": 7,
      "titulo": "Sarten",
      "imagen": "assets/images/content/categories/sarten.png",
    },
    {
      "id": 8,
      "titulo": "Al Bowl",
      "imagen": "assets/images/content/categories/bowl.png",
    },
    {
      "id": 9,
      "titulo": "Al Wok",
      "imagen": "assets/images/content/categories/wok.png",
    },
  ];

  static const List SUBCATEGORIAS_RECETA = [
    {
      "id": 1,
      "titulo": "Carne roja",
    },
    {
      "id": 2,
      "titulo": "Carne blanca",
    },
    {
      "id": 3,
      "titulo": "Vegatales",
    },
    {
      "id": 4,
      "titulo": "Frutos",
    },
    {
      "id": 5,
      "titulo": "Frutos secos",
    },
    {
      "id": 6,
      "titulo": "Especias",
    },
  ];

  static const List<String> INGREDIENTES = [
    "Papa",
    "Batata",
    "Manzana",
    "Oregano",
    "Pepino",
  ];
}
