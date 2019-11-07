import 'package:arrancando/config/globals/enums.dart';
import 'package:arrancando/config/models/active_user.dart';
import 'package:flutter/foundation.dart';

class MyState extends ChangeNotifier {
  ActiveUser activeUser;
  SectionType activePageHome = SectionType.home;
  Map<SectionType, int> selectedCategoryHome = {};
  Map<SectionType, int> preferredCategories = {};

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
}
