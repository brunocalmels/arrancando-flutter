import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'grupo.g.dart';

@JsonSerializable()
class GrupoChat {
  final int id;
  final String simbolo;
  final String color;
  final String nombre;

  GrupoChat(
    this.id,
    this.simbolo,
    this.color,
    this.nombre,
  );

  factory GrupoChat.fromJson(Map<String, dynamic> json) =>
      _$GrupoChatFromJson(json);

  Map<String, dynamic> toJson() => _$GrupoChatToJson(this);

  Color get toColor {
    try {
      return Color(
        int.tryParse(
              color.split('#').last.toLowerCase(),
              radix: 16,
            ) +
            0xFF000000,
      );
    } catch (e) {
      // Ignore
      print(e);
    }
    return Colors.black;
  }
}
