import 'dart:convert';

import 'package:arrancando/config/globals/enums.dart';
import 'package:arrancando/config/models/content_wrapper.dart';
import 'package:arrancando/config/state/index.dart';
import 'package:flutter/cupertino.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'saved_content.g.dart';

@JsonSerializable()
class SavedContent {
  final int id;
  final SectionType type;

  SavedContent(
    this.id,
    this.type,
  );

  factory SavedContent.fromJson(Map<String, dynamic> json) =>
      _$SavedContentFromJson(json);

  Map<String, dynamic> toJson() => _$SavedContentToJson(this);

  static initSaved(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String scsString = prefs.getString("savedContent");
    if (scsString != null) {
      (json.decode(scsString) as List)
          .map(
        (s) => SavedContent.fromJson(s),
      )
          .forEach(
        (sc) {
          Provider.of<MyState>(context).toggleSavedContent(sc);
        },
      );
    }
  }

  static bool isSaved(ContentWrapper content, BuildContext context) =>
      Provider.of<MyState>(context)
          .savedContent
          .any((sc) => sc.id == content.id && sc.type == content.type);

  static toggleSave(ContentWrapper content, BuildContext context) async {
    Provider.of<MyState>(context).toggleSavedContent(
      SavedContent(content.id, content.type),
    );
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(
      "savedContent",
      json.encode(Provider.of<MyState>(context).savedContent),
    );
  }
}
