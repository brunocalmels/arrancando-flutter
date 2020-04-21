import 'package:arrancando/config/globals/enums.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class MainState extends ChangeNotifier {
  ThemeMode activeTheme;
  SectionType activePageHome = SectionType.home;
  Map<SectionType, int> selectedCategoryHome = {};
  List<SectionType> contenidosHome = [];

  setActivePageHome(SectionType val) {
    if (val != null) {
      activePageHome = val;
      notifyListeners();
    }
  }

  setSelectedCategoryHome(SectionType type, int val) {
    selectedCategoryHome[type] = val;
    notifyListeners();
  }

  setContenidosHome(List<SectionType> list) {
    contenidosHome = list;
    notifyListeners();
  }

  setActiveTheme(ThemeMode theme) {
    activeTheme = theme;
    notifyListeners();
  }
}
