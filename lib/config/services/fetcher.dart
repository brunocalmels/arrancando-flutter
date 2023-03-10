import 'dart:convert';

import 'package:arrancando/config/globals/index.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

abstract class Fetcher {
  static Future<String> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    final activeUser = prefs.getString('activeUser');
    var token;
    if (activeUser != null) token = json.decode(activeUser)['auth_token'];
    return token;
  }

  static Future<ResponseObject> get({
    @required String url,
    bool throwError = false,
  }) async {
    try {
      final token = await _getToken();
      if (token == null) throw 'Token null';

      final resp = await http.get(
        '${MyGlobals.SERVER_URL}$url',
        headers: {
          'Authorization': token,
          'Content-type': 'application/json',
        },
      );

      if (resp.statusCode < 400) {
        return ResponseObject(
          body: resp.body,
          status: resp.statusCode,
        );
      } else {
        throw resp;
      }
    } catch (e) {
      if (e is String) print(e);
      if (e is http.Response) print(e.body);
      if (throwError) {
        return ResponseObject(body: e.body.body.toString());
      } else {
        return null;
      }
    }
  }

  static Future<ResponseObject> post({
    @required String url,
    @required dynamic body,
    bool throwError = false,
    bool unauthenticated = false,
  }) async {
    try {
      var token = '';
      if (!unauthenticated) {
        token = await _getToken();
        if (token == null) throw 'Token null';
      }

      final resp = await http.post(
        '${MyGlobals.SERVER_URL}$url',
        headers: {
          'Authorization': unauthenticated ? '' : token,
          'Content-type': 'application/json',
        },
        body: json.encode(body),
      );

      if (resp.statusCode < 400) {
        return ResponseObject(
          body: resp.body,
          status: resp.statusCode,
        );
      } else {
        throw resp;
      }
    } catch (e) {
      if (e is String) print(e);
      if (e is http.Response) print(e.body);
      if (throwError) {
        return ResponseObject(
          body: e.body.toString(),
        );
      } else {
        return null;
      }
    }
  }

  static Future<ResponseObject> put({
    @required String url,
    @required dynamic body,
    bool throwError = false,
  }) async {
    try {
      final token = await _getToken();
      if (token == null) throw 'Token null';

      final resp = await http.put(
        '${MyGlobals.SERVER_URL}$url',
        headers: {
          'Authorization': token,
          'Content-type': 'application/json',
        },
        body: json.encode(body),
      );

      if (resp.statusCode < 400) {
        return ResponseObject(
          body: resp.body,
          status: resp.statusCode,
        );
      } else {
        throw resp;
      }
    } catch (e) {
      if (e is String) print(e);
      if (e is http.Response) print(e.body);
      if (throwError) {
        return ResponseObject(
          body: e.body.toString(),
        );
      } else {
        return null;
      }
    }
  }

  static Future<ResponseObject> destroy({
    @required String url,
    bool throwError = false,
  }) async {
    try {
      final token = await _getToken();
      if (token == null) throw 'Token null';

      final resp = await http.delete(
        '${MyGlobals.SERVER_URL}$url',
        headers: {
          'Authorization': token,
          'Content-type': 'application/json',
        },
      );

      if (resp.statusCode < 400) {
        return ResponseObject(
          body: resp.body,
          status: resp.statusCode,
        );
      } else {
        throw resp;
      }
    } catch (e) {
      if (e is String) print(e);
      if (e is http.Response) print(e.body);
      if (throwError) {
        return ResponseObject(
          body: e.body.toString(),
        );
      } else {
        return null;
      }
    }
  }
}

class ResponseObject {
  final String body;
  final int status;

  ResponseObject({
    this.body,
    this.status,
  });
}
