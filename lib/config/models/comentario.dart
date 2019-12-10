import 'package:arrancando/config/models/usuario.dart';
import 'package:json_annotation/json_annotation.dart';

part 'comentario.g.dart';

@JsonSerializable()
class Comentario {
  final int id;
  @JsonKey(name: 'created_at')
  DateTime createdAt;
  @JsonKey(name: 'updated_at')
  DateTime updatedAt;
  Usuario user;
  String mensaje;

  Comentario(
    this.id,
    this.createdAt,
    this.updatedAt,
    this.user,
    this.mensaje,
  );

  factory Comentario.fromJson(Map<String, dynamic> json) =>
      _$ComentarioFromJson(json);

  Map<String, dynamic> toJson() => _$ComentarioToJson(this);

  get fecha =>
      "${createdAt.toLocal().day.toString().padLeft(2, '0')}/${createdAt.toLocal().month.toString().padLeft(2, '0')}${createdAt.toLocal().year == DateTime.now().year ? ' ' + createdAt.toLocal().hour.toString().padLeft(2, '0') + ':' + createdAt.toLocal().minute.toString().padLeft(2, '0') : '/' + createdAt.toLocal().year.toString()}";
}
