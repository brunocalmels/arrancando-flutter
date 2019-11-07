import 'dart:convert';

import 'package:arrancando/config/globals/global_singleton.dart';
import 'package:arrancando/config/services/fetcher.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:arrancando/config/globals/enums.dart';

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
    GlobalSingleton gs = GlobalSingleton();
    try {
      //////
      ResponseObject res1 = await Fetcher.get(
        url: "/ciudades.json",
      );
      if (res1.status == 200) {
        gs.setCategories(
            SectionType.publicaciones,
            (json.decode(res1.body) as List)
                .map((e) => CategoryWrapper.fromJson(e))
                .toList());
      }
      //////
      ResponseObject res2 = await Fetcher.get(
        url: "/categoria_recetas.json",
      );
      if (res2.status == 200) {
        gs.setCategories(
            SectionType.recetas,
            (json.decode(res2.body) as List)
                .map((e) => CategoryWrapper.fromJson(e))
                .toList());
      }
      //////
      ResponseObject res3 = await Fetcher.get(
        url: "/categoria_pois.json",
      );
      if (res3.status == 200) {
        gs.setCategories(
            SectionType.pois,
            (json.decode(res3.body) as List)
                .map((e) => CategoryWrapper.fromJson(e))
                .toList());
      }
      //////
    } catch (e) {
      print(e);
    }
  }
}
