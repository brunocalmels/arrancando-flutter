import 'package:arrancando/config/globals/enums.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class MainState extends ChangeNotifier {
  ThemeMode activeTheme;
  SectionType activePageHome = SectionType.home;
  Map<SectionType, int> selectedCategoryHome = {};
  List<SectionType> contenidosHome = [];
  int unreadNotifications = 0;

  void setActivePageHome(SectionType val) {
    if (val != null) {
      activePageHome = val;
      notifyListeners();
    }
  }

  void setSelectedCategoryHome(SectionType type, int val) {
    selectedCategoryHome[type] = val;
    notifyListeners();
  }

  void setContenidosHome(List<SectionType> list) {
    contenidosHome = list;
    notifyListeners();
  }

  void setActiveTheme(ThemeMode theme) {
    activeTheme = theme;
    notifyListeners();
  }

  void setUnreadNotifications(int val) {
    unreadNotifications = val;
    notifyListeners();
  }
}
