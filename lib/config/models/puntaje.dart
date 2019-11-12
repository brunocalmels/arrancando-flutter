import 'package:arrancando/config/models/usuario.dart';
import 'package:json_annotation/json_annotation.dart';

part 'puntaje.g.dart';

@JsonSerializable()
class Puntaje {
  Usuario usuario;
  int puntaje;

  Puntaje(
    this.usuario,
    this.puntaje,
  );

  factory Puntaje.fromJson(Map<String, dynamic> json) =>
      _$PuntajeFromJson(json);

  Map<String, dynamic> toJson() => _$PuntajeToJson(this);
}
