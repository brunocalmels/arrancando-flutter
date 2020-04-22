import 'package:json_annotation/json_annotation.dart';

part 'ingrediente.g.dart';

@JsonSerializable()
class Ingrediente {
  final int id;
  String nombre;

  Ingrediente(
    this.id,
    this.nombre,
  );

  factory Ingrediente.fromJson(Map<String, dynamic> json) =>
      _$IngredienteFromJson(json);

  Map<String, dynamic> toJson() => _$IngredienteToJson(this);
}
