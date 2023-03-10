import 'package:arrancando/config/globals/enums.dart';
import 'package:arrancando/config/models/active_user.dart';
import 'package:arrancando/config/models/saved_content.dart';
import 'package:flutter/foundation.dart';

class UserState extends ChangeNotifier {
  ActiveUser activeUser;
  Map<SectionType, int> preferredCategories = {};
  List<SavedContent> savedContent = [];
  Map<String, int> myPuntuaciones = {};

  void setActiveUser(ActiveUser val) {
    activeUser = val;
    notifyListeners();
  }

  void setPreferredCategories(SectionType type, int val) {
    preferredCategories[type] = val;
    notifyListeners();
  }

  void toggleSavedContent(SavedContent sc) {
    List all = savedContent
        .where(
          (s) => s.id == sc.id && s.type == sc.type,
        )
        .toList();
    if (all.isEmpty) {
      savedContent.add(sc);
    } else {
      savedContent.remove(all.first);
    }
    notifyListeners();
  }

  void setMyPuntuacion(String key, int val) {
    myPuntuaciones[key] = val;
    notifyListeners();
  }
}
