// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notificacion.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Notificacion _$NotificacionFromJson(Map<String, dynamic> json) {
  return Notificacion(
    json['id'] as int,
    json['titulo'] as String,
    json['cuerpo'] as String,
    json['url'] as String,
    json['leido'] as bool,
    json['created_at'] == null
        ? null
        : DateTime.parse(json['created_at'] as String),
    json['updated_at'] == null
        ? null
        : DateTime.parse(json['updated_at'] as String),
  );
}

Map<String, dynamic> _$NotificacionToJson(Notificacion instance) =>
    <String, dynamic>{
      'id': instance.id,
      'titulo': instance.titulo,
      'cuerpo': instance.cuerpo,
      'url': instance.url,
      'leido': instance.leido,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };
