import 'dart:convert';
import 'dart:io';

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

  static logout(context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('activeUser');
    Provider.of<UserState>(context, listen: false).setActiveUser(null);
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (_) => LoginPage(),
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
