// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'usuario.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Usuario _$UsuarioFromJson(Map<String, dynamic> json) {
  return Usuario(
    json['id'] as int,
    json['avatar'] as String,
    json['nombre'] as String,
    json['apellido'] as String,
    json['email'] as String,
    json['username'] as String,
  );
}

Map<String, dynamic> _$UsuarioToJson(Usuario instance) => <String, dynamic>{
      'id': instance.id,
      'avatar': instance.avatar,
      'nombre': instance.nombre,
      'apellido': instance.apellido,
      'email': instance.email,
      'username': instance.username,
    };
