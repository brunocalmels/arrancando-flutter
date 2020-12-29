// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mensaje.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MensajeChat _$MensajeChatFromJson(Map<String, dynamic> json) {
  return MensajeChat(
    json['id'] as int,
    json['grupo_chat_id'] as int,
    json['usuario'] == null
        ? null
        : Usuario.fromJson(json['usuario'] as Map<String, dynamic>),
    json['created_at'] == null
        ? null
        : DateTime.parse(json['created_at'] as String),
    json['updated_at'] == null
        ? null
        : DateTime.parse(json['updated_at'] as String),
    json['mensaje'] as String,
    json['type'] as String,
  );
}

Map<String, dynamic> _$MensajeChatToJson(MensajeChat instance) =>
    <String, dynamic>{
      'id': instance.id,
      'grupo_chat_id': instance.grupoChatId,
      'usuario': instance.usuario,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
      'mensaje': instance.mensaje,
      'type': instance.type,
    };
