import 'package:arrancando/config/models/usuario.dart';
import 'package:json_annotation/json_annotation.dart';

part 'mensaje.g.dart';

@JsonSerializable()
class MensajeChat {
  final int id;
  @JsonKey(name: 'grupo_chat_id')
  final int grupoChatId;
  final Usuario usuario;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;
  final String mensaje;
  String type;

  MensajeChat(
    this.id,
    this.grupoChatId,
    this.usuario,
    this.createdAt,
    this.updatedAt,
    this.mensaje, [
    this.type,
  ]);

  factory MensajeChat.fromJson(Map<String, dynamic> json) =>
      _$MensajeChatFromJson(json);

  Map<String, dynamic> toJson() => _$MensajeChatToJson(this);
}
