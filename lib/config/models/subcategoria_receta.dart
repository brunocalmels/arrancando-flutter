import 'package:json_annotation/json_annotation.dart';

part 'subcategoria_receta.g.dart';

@JsonSerializable()
class SubcategoriaReceta {
  final int id;
  String nombre;

  SubcategoriaReceta({
    this.id,
    this.nombre,
  });

  factory SubcategoriaReceta.fromJson(Map<String, dynamic> json) =>
      _$SubcategoriaRecetaFromJson(json);

  Map<String, dynamic> toJson() => _$SubcategoriaRecetaToJson(this);
}
