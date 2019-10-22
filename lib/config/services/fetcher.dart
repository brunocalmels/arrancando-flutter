import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

abstract class Fetcher {
  static Future get({
    @required String url,
    bool throwError = false,
  }) {
    try {
      return http.get(
        url,
        headers: {
          "Authorization": "",
          "Content-type": "application/json",
        },
      );
    } catch (e) {
      print(e);
      if (throwError)
        throw e;
      else
        return null;
    }
  }

  static Future post({
    @required String url,
    @required dynamic body,
    bool throwError = false,
    bool unauthenticated = false,
  }) {
    try {
      return http.post(
        url,
        headers: {
          "Authorization": unauthenticated ? "" : "",
          "Content-type": "application/json",
        },
        body: json.encode(body),
      );
    } catch (e) {
      print(e);
      if (throwError)
        throw e;
      else
        return null;
    }
  }

  static Future put({
    @required String url,
    @required dynamic body,
    bool throwError = false,
  }) {
    try {
      return http.put(
        url,
        headers: {
          "Authorization": "",
          "Content-type": "application/json",
        },
        body: json.encode(body),
      );
    } catch (e) {
      print(e);
      if (throwError)
        throw e;
      else
        return null;
    }
  }

  static Future destroy({
    @required String url,
    @required dynamic body,
    bool throwError = false,
  }) {
    try {
      return http.delete(
        url,
        headers: {
          "Authorization": "",
          "Content-type": "application/json",
        },
      );
    } catch (e) {
      print(e);
      if (throwError)
        throw e;
      else
        return null;
    }
  }
}
