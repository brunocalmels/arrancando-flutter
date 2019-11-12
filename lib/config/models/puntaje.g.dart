// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'puntaje.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Puntaje _$PuntajeFromJson(Map<String, dynamic> json) {
  return Puntaje(
    json['usuario'] == null
        ? null
        : Usuario.fromJson(json['usuario'] as Map<String, dynamic>),
    json['puntaje'] as int,
  );
}

Map<String, dynamic> _$PuntajeToJson(Puntaje instance) => <String, dynamic>{
      'usuario': instance.usuario,
      'puntaje': instance.puntaje,
    };
