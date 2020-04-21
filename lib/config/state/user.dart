import 'package:arrancando/config/globals/enums.dart';
import 'package:arrancando/config/models/active_user.dart';
import 'package:arrancando/config/models/saved_content.dart';
import 'package:flutter/foundation.dart';

class UserState extends ChangeNotifier {
  ActiveUser activeUser;
  Map<SectionType, int> preferredCategories = {};
  List<SavedContent> savedContent = [];
  Map<String, int> myPuntuaciones = {};

  setActiveUser(ActiveUser val) {
    activeUser = val;
    notifyListeners();
  }

  setPreferredCategories(SectionType type, int val) {
    preferredCategories[type] = val;
    notifyListeners();
  }

  toggleSavedContent(SavedContent sc) {
    List all = savedContent
        .where(
          (s) => s.id == sc.id && s.type == sc.type,
        )
        .toList();
    if (all.length == 0) {
      savedContent.add(sc);
    } else {
      savedContent.remove(all.first);
    }
    notifyListeners();
  }

  setMyPuntuacion(String key, int val) {
    myPuntuaciones[key] = val;
    notifyListeners();
  }
}
