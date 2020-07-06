// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'active_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ActiveUser _$ActiveUserFromJson(Map<String, dynamic> json) {
  return ActiveUser(
    json['auth_token'] as String,
    json['id'] as int,
    json['nombre'] as String,
    json['apellido'] as String,
    json['email'] as String,
    json['username'] as String,
    json['avatar'] as String,
    json['url_instagram'] as String,
  );
}

Map<String, dynamic> _$ActiveUserToJson(ActiveUser instance) =>
    <String, dynamic>{
      'auth_token': instance.authToken,
      'id': instance.id,
      'nombre': instance.nombre,
      'apellido': instance.apellido,
      'email': instance.email,
      'username': instance.username,
      'avatar': instance.avatar,
      'url_instagram': instance.urlInstagram,
    };
