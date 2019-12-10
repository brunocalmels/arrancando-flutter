import 'package:json_annotation/json_annotation.dart';

part 'usuario.g.dart';

@JsonSerializable()
class Usuario {
  final int id;
  String avatar;
  String nombre;
  String apellido;
  String email;
  String username;

  Usuario(
    this.id,
    this.avatar,
    this.nombre,
    this.apellido,
    this.email,
    this.username,
  );

  factory Usuario.fromJson(Map<String, dynamic> json) =>
      _$UsuarioFromJson(json);

  Map<String, dynamic> toJson() => _$UsuarioToJson(this);
}
