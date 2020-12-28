// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'grupo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GrupoChat _$GrupoChatFromJson(Map<String, dynamic> json) {
  return GrupoChat(
    json['id'] as int,
    json['simbolo'] as String,
    json['color'] as String,
    json['nombre'] as String,
  );
}

Map<String, dynamic> _$GrupoChatToJson(GrupoChat instance) => <String, dynamic>{
      'id': instance.id,
      'simbolo': instance.simbolo,
      'color': instance.color,
      'nombre': instance.nombre,
    };
