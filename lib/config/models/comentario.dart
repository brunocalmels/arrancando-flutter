import 'package:arrancando/config/models/active_user.dart';
import 'package:arrancando/config/models/puntaje.dart';
import 'package:arrancando/config/models/usuario.dart';
import 'package:arrancando/config/state/user.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:provider/provider.dart';

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
  List<Puntaje> puntajes;

  Comentario(
    this.id,
    this.createdAt,
    this.updatedAt,
    this.user,
    this.mensaje,
    this.puntajes,
  );

  factory Comentario.fromJson(Map<String, dynamic> json) =>
      _$ComentarioFromJson(json);

  Map<String, dynamic> toJson() => _$ComentarioToJson(this);

  String get fecha =>
      '${createdAt.toLocal().day.toString().padLeft(2, '0')}/${createdAt.toLocal().month.toString().padLeft(2, '0')}${createdAt.toLocal().year == DateTime.now().year ? ' ' + createdAt.toLocal().hour.toString().padLeft(2, '0') + ':' + createdAt.toLocal().minute.toString().padLeft(2, '0') : '/' + createdAt.toLocal().year.toString()}';

  bool esOwner(BuildContext context) =>
      user != null &&
      context.select<UserState, ActiveUser>((value) => value.activeUser) !=
          null &&
      user.id ==
          context.select<UserState, ActiveUser>((value) => value.activeUser).id;

  int myPuntaje(int uid) =>
      puntajes
          ?.firstWhere(
            (p) => p.usuario.id == uid,
            orElse: () => null,
          )
          ?.puntaje ??
      0;

  void addMyPuntaje(Puntaje myPuntaje) {
    var oldPuntaje = puntajes?.indexWhere(
      (p) => p.usuario.id == myPuntaje.usuario.id,
    );
    if (oldPuntaje >= 0) {
      var ps = [];
      var i = 0;
      puntajes.forEach((p) {
        if (i == oldPuntaje) {
          ps.add(myPuntaje);
        } else {
          ps.add(p);
        }
        i++;
      });
      puntajes = [...ps];
    } else {
      puntajes = [
        ...puntajes,
        myPuntaje,
      ];
    }
  }
}
