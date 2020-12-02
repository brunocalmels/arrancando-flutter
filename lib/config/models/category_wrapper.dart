import 'dart:convert';

import 'package:arrancando/config/globals/global_singleton.dart';
import 'package:arrancando/config/services/fetcher.dart';
import 'package:arrancando/config/state/content_page.dart';
import 'package:arrancando/config/state/main.dart';
import 'package:flutter/widgets.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:arrancando/config/globals/enums.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'category_wrapper.g.dart';

@JsonSerializable()
class CategoryWrapper {
  final int id;
  final SectionType type;
  String nombre;
  int version;

  CategoryWrapper({
    this.id,
    this.type,
    this.nombre,
    this.version,
  });

  factory CategoryWrapper.fromJson(Map<String, dynamic> json) =>
      _$CategoryWrapperFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryWrapperToJson(this);

  static Future<void> loadCategories() async {
    final todos = CategoryWrapper(
      id: -1,
      nombre: 'Todos',
    );

    final gs = GlobalSingleton();

    var categs = <CategoryWrapper>[];

    try {
      //////
      final res0 = await Fetcher.get(
        url: '/categoria_publicaciones.json',
      );
      if (res0 != null && res0.status == 200) {
        categs = (json.decode(res0.body) as List)
            .map((e) => CategoryWrapper.fromJson(e))
            .toList();
      }
      gs.setCategories(
        SectionType.publicaciones_categoria,
        [
          todos,
          ...categs,
        ],
      );

      categs = [];

      //////
      final res1 = await Fetcher.get(
        url: '/ciudades.json',
      );
      if (res1 != null && res1.status == 200) {
        categs = (json.decode(res1.body) as List)
            .map((e) => CategoryWrapper.fromJson(e))
            .toList();
      }
      gs.setCategories(
        SectionType.publicaciones,
        [
          todos,
          ...categs,
        ],
      );
      gs.setCategories(
        SectionType.pois_ciudad,
        [
          todos,
          ...categs,
        ],
      );

      categs = [];

      //////
      final res2 = await Fetcher.get(
        url: '/categoria_recetas.json',
      );
      if (res2 != null && res2.status == 200) {
        categs = (json.decode(res2.body) as List)
            .map((e) => CategoryWrapper.fromJson(e))
            .toList();
      }
      gs.setCategories(
        SectionType.recetas,
        [
          todos,
          ...categs,
        ],
      );

      categs = [];

      //////
      final res3 = await Fetcher.get(
        url: '/categoria_pois.json',
      );
      if (res3 != null && res3.status == 200) {
        categs = (json.decode(res3.body) as List)
            .map((e) => CategoryWrapper.fromJson(e))
            .toList();
      }
      gs.setCategories(
        SectionType.pois,
        [
          todos,
          ...categs,
        ],
      );

      //////
    } catch (e) {
      print(e);
    }
  }

  static Future<void> restoreSavedFilter(
    BuildContext context,
    SectionType type,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final val = prefs.getInt(type.toString());
    if (val != null) {
      context.read<ContentPageState>().setSavedFilter(type, val);
    }
    if (type == SectionType.pois &&
        val == null &&
        GlobalSingleton().categories.isNotEmpty &&
        GlobalSingleton().categories[SectionType.pois].isNotEmpty) {
      final id = GlobalSingleton()
          .categories[SectionType.pois]
          .firstWhere((c) => c.nombre.toLowerCase() == 'arrancando market',
              orElse: () => null)
          ?.id;

      if (id != null) {
        context.read<MainState>().setSelectedCategoryHome(type, id);
      } else {
        context.read<MainState>().setSelectedCategoryHome(type, -1);
      }
    } else {
      context.read<MainState>().setSelectedCategoryHome(type, val ?? -1);
    }
  }

  static Future<void> saveFilter(
    BuildContext context,
    SectionType type,
    int val,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(type.toString(), val);
    context.read<ContentPageState>().setSavedFilter(type, val);
  }

  static Future<void> saveContentHome(
    BuildContext context,
    List<SectionType> list,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      'content-home',
      json.encode(
        list.map((i) => '$i').toList(),
      ),
    );
    context.read<MainState>().setContenidosHome(list);
  }

  static Future<void> restoreSavedShowMine(
    BuildContext context,
    SectionType type,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final val = prefs.getBool('${type.toString()}-show-mine');
    if (val != null) {
      context.read<ContentPageState>().setShowMine(type, val);
    } else {
      context.read<ContentPageState>().setShowMine(type, false);
    }
  }

  static Future<void> saveShowMine(
      BuildContext context, SectionType type, bool val) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('${type.toString()}-show-mine', val);
    context.read<ContentPageState>().setShowMine(type, val);
  }

  static Future<void> restoreContentHome(
    BuildContext context,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    // prefs.remove('content-home');
    final contentHome = prefs.getString('content-home');
    if (contentHome != null) {
      try {
        context.read<MainState>().setContenidosHome(
              (json.decode(contentHome) as List)
                  .map((i) => sectionTypeMapper[i])
                  .toList(),
            );
      } catch (e) {
        print(e);
      }
    }
  }
}

final Map<String, SectionType> sectionTypeMapper = {
  'SectionType.publicaciones': SectionType.publicaciones,
  'SectionType.recetas': SectionType.recetas,
  'SectionType.wiki': SectionType.wiki,
  'SectionType.pois': SectionType.pois,
  'SectionType.followed': SectionType.followed,
};
