import 'dart:convert';
import 'dart:io';

import 'package:arrancando/config/globals/index.dart';
import 'package:arrancando/config/models/usuario.dart';
import 'package:arrancando/config/services/fetcher.dart';
import 'package:arrancando/config/state/user.dart';
import 'package:arrancando/views/user/login/index.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

part 'active_user.g.dart';

@JsonSerializable()
class ActiveUser {
  @JsonKey(name: 'auth_token')
  String authToken;
  int id;
  String nombre;
  String apellido;
  String email;
  String username;
  String avatar;
  @JsonKey(name: 'url_instagram')
  String urlInstagram;

  ActiveUser(
    this.authToken,
    this.id,
    this.nombre,
    this.apellido,
    this.email,
    this.username,
    this.avatar,
    this.urlInstagram,
  );

  factory ActiveUser.fromJson(Map<String, dynamic> json) =>
      _$ActiveUserFromJson(json);

  Map<String, dynamic> toJson() => _$ActiveUserToJson(this);

  Usuario get getUsuario => Usuario(
        id,
        avatar,
        nombre,
        apellido,
        email,
        username,
        urlInstagram,
      );

  // static Future<bool> locationPermissionDenied() async {
  //   final gs = GlobalSingleton();

  //   if (!gs.askingLocationPermission) {
  //     gs.setAskingLocationPermission(true);

  //     final permission = await PermissionHandler()
  //         .checkPermissionStatus(PermissionGroup.location);

  //     if (permission == PermissionStatus.denied) {
  //       final permissions = await PermissionHandler()
  //           .requestPermissions([PermissionGroup.location]);

  //       if (permissions.containsKey(PermissionGroup.location) &&
  //           permissions[PermissionGroup.location] != PermissionStatus.granted) {
  //         gs.setAskingLocationPermission(false);
  //         return true;
  //       }
  //     } else {
  //       gs.setAskingLocationPermission(false);
  //       return false;
  //     }
  //   }
  //   return false;
  // }

  // static Future<bool> cameraPermissionDenied() async {
  //   final permission =
  //       await PermissionHandler().checkPermissionStatus(PermissionGroup.camera);

  //   if (permission == PermissionStatus.denied) {
  //     final permissions = await PermissionHandler()
  //         .requestPermissions([PermissionGroup.camera]);

  //     if (permissions.containsKey(PermissionGroup.camera) &&
  //         permissions[PermissionGroup.camera] != PermissionStatus.granted) {
  //       return true;
  //     }
  //   } else {
  //     return false;
  //   }
  //   return false;
  // }

  // static Future<bool> storagePermissionDenied() async {
  //   final permission = await PermissionHandler()
  //       .checkPermissionStatus(PermissionGroup.storage);

  //   if (permission == PermissionStatus.denied) {
  //     final permissions = await PermissionHandler()
  //         .requestPermissions([PermissionGroup.storage]);

  //     if (permissions.containsKey(PermissionGroup.storage) &&
  //         permissions[PermissionGroup.storage] != PermissionStatus.granted) {
  //       return true;
  //     }
  //   } else {
  //     return false;
  //   }
  //   return false;
  // }

  // static Future<bool> photosPermissionDenied() async {
  //   final permission =
  //       await PermissionHandler().checkPermissionStatus(PermissionGroup.photos);

  //   if (permission == PermissionStatus.denied) {
  //     final permissions = await PermissionHandler()
  //         .requestPermissions([PermissionGroup.photos]);

  //     if (permissions.containsKey(PermissionGroup.photos) &&
  //         permissions[PermissionGroup.photos] != PermissionStatus.granted) {
  //       return true;
  //     }
  //   } else {
  //     return false;
  //   }
  //   return false;
  // }

  static Future<void> logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('activeUser');
    context.read<UserState>().setActiveUser(null);
    await Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (_) => LoginPage(),
        settings: RouteSettings(name: 'Login'),
      ),
      (_) => false,
    );
  }

  static Future<void> verifyCorrectLogin(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final activeUser = prefs.getString('activeUser');
    // Verify active user defined
    if (activeUser != null) {
      // Active user is set
      final au = ActiveUser.fromJson(
        json.decode(activeUser),
      );
      if (au.id == null || au.email == null || au.authToken == null) {
        // Active user lacks either id or email or token
        await ActiveUser.logout(context);
      } else if (au.authToken != null && au.authToken.split('.').length > 1) {
        try {
          final s1 = au.authToken.split('.')[1];
          final b64 = base64.decode(base64.normalize(s1));
          final decoded = utf8.decode(b64);
          final jeison = json.decode(decoded);
          int exp = jeison['exp'] * 1000;
          final date = DateTime.fromMillisecondsSinceEpoch(exp);
          if (date.isBefore(DateTime.now())) {
            await ActiveUser.logout(context);
          } else {
            final resp = await Fetcher.get(
              url: '/ciudades/1.json',
            );
            if (resp == null ||
                resp.body == null ||
                resp.status == null ||
                resp.status > 300) {
              await ActiveUser.logout(context);
            }
          }
        } catch (e) {
          print(e);
          await ActiveUser.logout(context);
        }
      }
    } else {
      // Active user was null but the app landed on /home somehow
      await ActiveUser.logout(context);
    }
  }

  static Future<void> updateUserMetadata(BuildContext context) async {
    await Fetcher.put(
      url: '/users/${context.read<UserState>().activeUser.id}.json',
      body: {
        'user': {
          'app_version': '${MyGlobals.APP_VERSION}',
          'platform': '${Platform.operatingSystem}',
        }
      },
    );
  }
}
