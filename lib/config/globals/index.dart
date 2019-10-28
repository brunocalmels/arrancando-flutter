import 'package:arrancando/config/globals/enums.dart';
import 'package:flutter/material.dart';

abstract class MyGlobals {
  static const bool SHOW_DEV_LOGIN = true;

  static const String SERVER_URL = "http://192.168.0.10:5000";
  // static const String SERVER_URL = "http://192.168.0.11:5000";

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

  static const TIPOS_CATEGORIAS = {
    SectionType.home: [
      'Todo',
    ],
    SectionType.publicaciones: [
      'Neuquén',
      'Cipolletti',
      'Plottier',
    ],
    SectionType.recetas: [
      'Con carne',
      'Sin carne',
      'Sin comida',
    ],
    SectionType.pois: [
      'Carne',
      'Leña',
      'Artesanos del hierro (keeeh???)',
    ],
  };
}
