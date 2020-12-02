import 'dart:convert';

import 'package:arrancando/config/services/fetcher.dart';
import 'package:json_annotation/json_annotation.dart';

part 'notificacion.g.dart';

@JsonSerializable()
class Notificacion {
  final int id;
  String titulo;
  String cuerpo;
  String url;
  bool leido;
  @JsonKey(name: 'created_at')
  DateTime createdAt;
  @JsonKey(name: 'updated_at')
  DateTime updatedAt;

  Notificacion(
    this.id,
    this.titulo,
    this.cuerpo,
    this.url,
    this.leido,
    this.createdAt,
    this.updatedAt,
  );

  factory Notificacion.fromJson(Map<String, dynamic> json) =>
      _$NotificacionFromJson(json);

  Map<String, dynamic> toJson() => _$NotificacionToJson(this);

  String get fecha =>
      '${createdAt.toLocal().day.toString().padLeft(2, '0')}/${createdAt.toLocal().month.toString().padLeft(2, '0')}${createdAt.toLocal().year == DateTime.now().year ? ' ' + createdAt.toLocal().hour.toString().padLeft(2, '0') + ':' + createdAt.toLocal().minute.toString().padLeft(2, '0') : '/' + createdAt.toLocal().year.toString()}';

  static Future<List<Notificacion>> fetchUnread() async {
    final resp = await Fetcher.get(
      url: '/notificaciones/unread.json',
    );
    if (resp != null && resp.body != null) {
      return (json.decode(resp.body) as List)
          .map((n) => Notificacion.fromJson(n))
          .toList();
    }
    return [];
  }

  Future<void> markAsRead() async {
    leido = true;
    await Fetcher.put(
      url: '/notificaciones/${id}.json',
      body: {
        'leido': true,
      },
    );
  }

  static Future<void> markAllRead() async {
    await Fetcher.post(
      url: '/notificaciones/mark_all_as_read.json',
      body: {},
    );
  }
}
