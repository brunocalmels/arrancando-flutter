// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'receta.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Receta _$RecetaFromJson(Map<String, dynamic> json) {
  return Receta(
    json['id'] as int,
    json['created_at'] == null
        ? null
        : DateTime.parse(json['created_at'] as String),
    json['updated_at'] == null
        ? null
        : DateTime.parse(json['updated_at'] as String),
    json['titulo'] as String,
    json['cuerpo'] as String,
    json['ciudad_id'] as int,
    (json['imagenes'] as List)?.map((e) => e as String)?.toList(),
  );
}

Map<String, dynamic> _$RecetaToJson(Receta instance) => <String, dynamic>{
      'id': instance.id,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
      'titulo': instance.titulo,
      'cuerpo': instance.cuerpo,
      'ciudad_id': instance.ciudadId,
      'imagenes': instance.imagenes,
    };
