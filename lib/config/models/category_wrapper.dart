import 'dart:convert';

import 'package:arrancando/config/globals/global_singleton.dart';
import 'package:arrancando/config/services/fetcher.dart';
import 'package:arrancando/config/state/content_page.dart';
import 'package:arrancando/config/state/main.dart';
import 'package:flutter/cupertino.dart';
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

  CategoryWrapper({
    this.id,
    this.type,
    this.nombre,
  });

  factory CategoryWrapper.fromJson(Map<String, dynamic> json) =>
      _$CategoryWrapperFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryWrapperToJson(this);

  static loadCategories() async {
    CategoryWrapper todos = CategoryWrapper(
      id: -1,
      nombre: "Todos",
    );

    GlobalSingleton gs = GlobalSingleton();

    List<CategoryWrapper> categs = [];

    try {
      //////
      ResponseObject res0 = await Fetcher.get(
        url: "/categoria_publicaciones.json",
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
      ResponseObject res1 = await Fetcher.get(
        url: "/ciudades.json",
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

      categs = [];

      //////
      ResponseObject res2 = await Fetcher.get(
        url: "/categoria_recetas.json",
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
      ResponseObject res3 = await Fetcher.get(
        url: "/categoria_pois.json",
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

  static restoreSavedFilter(BuildContext context, SectionType type) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int val = prefs.getInt(type.toString());
    if (val != null)
      Provider.of<ContentPageState>(context).setSavedFilter(type, val);
      Provider.of<MainState>(context).setSelectedCategoryHome(type, val);
  }

  static saveFilter(BuildContext context, SectionType type, int val) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt(type.toString(), val);
    Provider.of<ContentPageState>(context).setSavedFilter(type, val);
  }
}
