import 'package:json_annotation/json_annotation.dart';
import 'package:permission_handler/permission_handler.dart';

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

  static Future<bool> locationPermissionDenied() async {
    PermissionStatus permission = await PermissionHandler()
        .checkPermissionStatus(PermissionGroup.location);

    if (permission == PermissionStatus.denied) {
      Map<PermissionGroup, PermissionStatus> permissions =
          await PermissionHandler()
              .requestPermissions([PermissionGroup.location]);

      if (permissions.containsKey(PermissionGroup.location) &&
          permissions[PermissionGroup.location] != PermissionStatus.granted) {
        return true;
      }
    } else {
      return false;
    }
    return false;
  }
}
