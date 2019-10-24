import 'package:json_annotation/json_annotation.dart';

part 'receta.g.dart';

@JsonSerializable()
class Receta {
  final int id;
  @JsonKey(name: 'created_at')
  DateTime createdAt;
  @JsonKey(name: 'updated_at')
  DateTime updatedAt;
  String titulo;
  String cuerpo;
  @JsonKey(name: 'ciudad_id')
  int ciudadId;
  List<String> imagenes;

  Receta(
    this.id,
    this.createdAt,
    this.updatedAt,
    this.titulo,
    this.cuerpo,
    this.ciudadId,
    this.imagenes,
  );

  factory Receta.fromJson(Map<String, dynamic> json) =>
      _$RecetaFromJson(json);

  Map<String, dynamic> toJson() => _$RecetaToJson(this);

  get fecha => "${createdAt.toLocal().day.toString().padLeft(2, '0')}/${createdAt.toLocal().month.toString().padLeft(2, '0')}/${createdAt.toLocal().year.toString()}";
}
