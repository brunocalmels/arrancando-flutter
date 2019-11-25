import 'package:arrancando/config/globals/enums.dart';
import 'package:flutter/material.dart';

abstract class MyGlobals {
  static const bool SHOW_DEV_LOGIN = true;

  static const String SERVER_URL = "http://192.168.0.10:5000";
  // static const String SERVER_URL = "http://192.168.0.11:5000";
  // static const String SERVER_URL = "http://192.168.43.138:5000";

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
