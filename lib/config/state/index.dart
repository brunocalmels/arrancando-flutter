import 'package:arrancando/config/globals/enums.dart';
import 'package:arrancando/config/models/active_user.dart';
import 'package:arrancando/config/models/saved_content.dart';
import 'package:flutter/foundation.dart';

class MyState extends ChangeNotifier {
  ActiveUser activeUser;
  SectionType activePageHome = SectionType.home;
  Map<SectionType, int> selectedCategoryHome = {};
  Map<SectionType, int> preferredCategories = {};
  List<SavedContent> savedContent = [];

  setActiveUser(ActiveUser val) {
    activeUser = val;
    notifyListeners();
  }

  setActivePageHome(SectionType val) {
    activePageHome = val;
    notifyListeners();
  }

  setSelectedCategoryHome(SectionType type, int val) {
    selectedCategoryHome[type] = val;
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
}
