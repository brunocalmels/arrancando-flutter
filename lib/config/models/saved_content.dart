import 'dart:convert';

import 'package:arrancando/config/globals/enums.dart';
import 'package:arrancando/config/models/content_wrapper.dart';
import 'package:arrancando/config/state/user.dart';
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

  static Future<void> initSaved(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final scsString = prefs.getString('savedContent');
    if (scsString != null) {
      (json.decode(scsString) as List)
          .map(
        (s) => SavedContent.fromJson(s),
      )
          .forEach(
        (sc) {
          Provider.of<UserState>(context).toggleSavedContent(sc);
        },
      );
    }
  }

  static bool isSaved(ContentWrapper content, BuildContext context) =>
      Provider.of<UserState>(context)
          .savedContent
          .any((sc) => sc.id == content.id && sc.type == content.type);

  static Future<void> toggleSave(
    ContentWrapper content,
    BuildContext context,
  ) async {
    Provider.of<UserState>(context).toggleSavedContent(
      SavedContent(content.id, content.type),
    );
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      'savedContent',
      json.encode(Provider.of<UserState>(context).savedContent),
    );
    await content.setSaved(isSaved(content, context));
  }
}
