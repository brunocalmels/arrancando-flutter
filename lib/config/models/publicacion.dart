import 'package:json_annotation/json_annotation.dart';

part 'publicacion.g.dart';

@JsonSerializable()
class Publicacion {
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

  Publicacion(
    this.id,
    this.createdAt,
    this.updatedAt,
    this.titulo,
    this.cuerpo,
    this.ciudadId,
    this.imagenes,
  );

  factory Publicacion.fromJson(Map<String, dynamic> json) =>
      _$PublicacionFromJson(json);

  Map<String, dynamic> toJson() => _$PublicacionToJson(this);

  get fecha => "${createdAt.toLocal().day.toString().padLeft(2, '0')}/${createdAt.toLocal().month.toString().padLeft(2, '0')}/${createdAt.toLocal().year.toString()}";
}
