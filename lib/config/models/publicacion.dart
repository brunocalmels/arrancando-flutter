import 'package:json_annotation/json_annotation.dart';

part 'publicacion.g.dart';

@JsonSerializable()
class Publicacion {
  final int id;
  String titulo;
  String cuerpo;
  @JsonKey(name: 'ciudad_id')
  int ciudadId;
  List<String> imagenes;

  Publicacion(
    this.id,
    this.titulo,
    this.cuerpo,
    this.ciudadId,
    this.imagenes,
  );

  factory Publicacion.fromJson(Map<String, dynamic> json) =>
      _$PublicacionFromJson(json);

  Map<String, dynamic> toJson() => _$PublicacionToJson(this);
}
