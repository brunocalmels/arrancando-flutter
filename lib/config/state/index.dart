import 'package:arrancando/config/globals/enums.dart';
import 'package:flutter/foundation.dart';

class MyState extends ChangeNotifier {
  SectionType activePageHome = SectionType.home;

  setActivePageHome(SectionType val) {
    activePageHome = val;
    notifyListeners();
  }
}
