import 'dart:io';

import 'package:arrancando/config/globals/global_singleton.dart';
import 'package:permission_handler/permission_handler.dart';

abstract class PermissionUtils {
  static Future<bool> requestLocationPermission() async {
    final gs = GlobalSingleton();

    if (!Platform.isLinux) {
      gs.setAskingLocationPermission(true);
      try {
        final status = await Permission.locationWhenInUse.status;
        if (status.isUndetermined) {
          final granted = await Permission.locationWhenInUse.request();
          return granted.isGranted;
        } else if (status.isDenied) {
          final granted = await Permission.locationWhenInUse.request();
          return granted.isGranted;
        } else if (status.isPermanentlyDenied) {
          return false;
        } else if (status.isGranted) {
          return true;
        }
      } catch (e) {
        print(e);
      }
      gs.setAskingLocationPermission(false);
      return false;
    }
    return true;
  }

  static Future<bool> requestCameraPermission() async {
    if (!Platform.isLinux) {
      try {
        final status = await Permission.camera.status;
        if (status.isUndetermined) {
          final granted = await Permission.camera.request();
          return granted.isGranted;
        } else if (status.isDenied) {
          final granted = await Permission.camera.request();
          return granted.isGranted;
        } else if (status.isPermanentlyDenied) {
          return false;
        } else if (status.isGranted) {
          return true;
        }
      } catch (e) {
        print(e);
      }
      return false;
    }
    return true;
  }

  static Future<bool> requestStoragePermission() async {
    if (!Platform.isLinux) {
      try {
        final status = await Permission.storage.status;
        if (status.isUndetermined) {
          final granted = await Permission.storage.request();
          return granted.isGranted;
        } else if (status.isDenied) {
          final granted = await Permission.storage.request();
          return granted.isGranted;
        } else if (status.isPermanentlyDenied) {
          return false;
        } else if (status.isGranted) {
          return true;
        }
      } catch (e) {
        print(e);
      }
      return false;
    }
    return true;
  }
}
