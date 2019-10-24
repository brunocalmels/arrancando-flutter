// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'point_of_interest.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PointOfInterest _$PointOfInterestFromJson(Map<String, dynamic> json) {
  return PointOfInterest(
    json['id'] as int,
    json['created_at'] == null
        ? null
        : DateTime.parse(json['created_at'] as String),
    json['updated_at'] == null
        ? null
        : DateTime.parse(json['updated_at'] as String),
    json['titulo'] as String,
    json['cuerpo'] as String,
    (json['latitud'] as num)?.toDouble(),
    (json['longitud'] as num)?.toDouble(),
    (json['imagenes'] as List)?.map((e) => e as String)?.toList(),
  );
}

Map<String, dynamic> _$PointOfInterestToJson(PointOfInterest instance) =>
    <String, dynamic>{
      'id': instance.id,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
      'titulo': instance.titulo,
      'cuerpo': instance.cuerpo,
      'latitud': instance.latitud,
      'longitud': instance.longitud,
      'imagenes': instance.imagenes,
    };
