// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'publicacion.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Publicacion _$PublicacionFromJson(Map<String, dynamic> json) {
  return Publicacion(
    json['id'] as int,
    json['titulo'] as String,
    json['cuerpo'] as String,
    json['ciudad_id'] as int,
    (json['imagenes'] as List)?.map((e) => e as String)?.toList(),
  );
}

Map<String, dynamic> _$PublicacionToJson(Publicacion instance) =>
    <String, dynamic>{
      'id': instance.id,
      'titulo': instance.titulo,
      'cuerpo': instance.cuerpo,
      'ciudad_id': instance.ciudadId,
      'imagenes': instance.imagenes,
    };
