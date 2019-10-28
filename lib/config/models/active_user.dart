import 'package:json_annotation/json_annotation.dart';

part 'active_user.g.dart';

@JsonSerializable()
class ActiveUser {
  @JsonKey(name: "auth_token")
  String authToken;
  int id;
  String nombre;
  String apellido;
  String email;
  String username;
  String avatar;

  ActiveUser(
    this.authToken,
    this.id,
    this.nombre,
    this.apellido,
    this.email,
    this.username,
    this.avatar,
  );

  factory ActiveUser.fromJson(Map<String, dynamic> json) =>
      _$ActiveUserFromJson(json);

  Map<String, dynamic> toJson() => _$ActiveUserToJson(this);
}
