import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:arrancando/config/globals/index.dart';
import 'package:arrancando/config/services/fetcher.dart';
import 'package:arrancando/config/state/user.dart';
import 'package:arrancando/views/user/login/index.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  static Future<bool> cameraPermissionDenied() async {
    PermissionStatus permission =
        await PermissionHandler().checkPermissionStatus(PermissionGroup.camera);

    if (permission == PermissionStatus.denied) {
      Map<PermissionGroup, PermissionStatus> permissions =
          await PermissionHandler()
              .requestPermissions([PermissionGroup.camera]);

      if (permissions.containsKey(PermissionGroup.camera) &&
          permissions[PermissionGroup.camera] != PermissionStatus.granted) {
        return true;
      }
    } else {
      return false;
    }
    return false;
  }

  static Future<bool> storagePermissionDenied() async {
    PermissionStatus permission = await PermissionHandler()
        .checkPermissionStatus(PermissionGroup.storage);

    if (permission == PermissionStatus.denied) {
      Map<PermissionGroup, PermissionStatus> permissions =
          await PermissionHandler()
              .requestPermissions([PermissionGroup.storage]);

      if (permissions.containsKey(PermissionGroup.storage) &&
          permissions[PermissionGroup.storage] != PermissionStatus.granted) {
        return true;
      }
    } else {
      return false;
    }
    return false;
  }

  static Future<bool> photosPermissionDenied() async {
    PermissionStatus permission =
        await PermissionHandler().checkPermissionStatus(PermissionGroup.photos);

    if (permission == PermissionStatus.denied) {
      Map<PermissionGroup, PermissionStatus> permissions =
          await PermissionHandler()
              .requestPermissions([PermissionGroup.photos]);

      if (permissions.containsKey(PermissionGroup.photos) &&
          permissions[PermissionGroup.photos] != PermissionStatus.granted) {
        return true;
      }
    } else {
      return false;
    }
    return false;
  }

  static logout(context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('activeUser');
    Provider.of<UserState>(context, listen: false).setActiveUser(null);
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (_) => LoginPage(),
        settings: RouteSettings(name: 'Login'),
      ),
      (_) => false,
    );
  }

  static verifyCorrectLogin(context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String activeUser = prefs.getString("activeUser");
    print('Verify active user defined');
    if (activeUser != null) {
      print('Active user is set');
      ActiveUser au = ActiveUser.fromJson(
        json.decode(activeUser),
      );
      if (au.id == null || au.email == null || au.authToken == null) {
        print('Active user lacks either id or email or token');
        ActiveUser.logout(context);
      } else if (au.authToken != null && au.authToken.split('.').length > 1) {
        try {
          String s1 = au.authToken.split('.')[1];
          Uint8List b64 = base64.decode(base64.normalize(s1));
          String decoded = utf8.decode(b64);
          dynamic jeison = json.decode(decoded);
          int exp = jeison['exp'] * 1000;
          DateTime date = DateTime.fromMillisecondsSinceEpoch(exp);
          if (date.isBefore(DateTime.now())) {
            ActiveUser.logout(context);
          } else {
            ResponseObject resp = await Fetcher.get(
              url: "/ciudades/1.json",
            );
            if (resp == null ||
                resp.body == null ||
                resp.status == null ||
                resp.status > 300) {
              ActiveUser.logout(context);
            }
          }
        } catch (e) {
          print(e);
          ActiveUser.logout(context);
        }
      }
    } else {
      print('Active user was null but the app landed on /home somehow');
      ActiveUser.logout(context);
    }
  }

  static updateUserMetadata(context) async {
    await Fetcher.put(
      url: "/users/${Provider.of<UserState>(context).activeUser.id}.json",
      body: {
        "user": {
          "app_version": "${MyGlobals.APP_VERSION}",
          "platform": "${Platform.operatingSystem}",
        }
      },
    );
  }
}
