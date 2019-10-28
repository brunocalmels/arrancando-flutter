import 'package:arrancando/config/globals/enums.dart';
import 'package:arrancando/config/models/active_user.dart';
import 'package:flutter/foundation.dart';

class MyState extends ChangeNotifier {
  ActiveUser activeUser;
  SectionType activePageHome = SectionType.home;

  setActiveUser(ActiveUser val) {
    activeUser = val;
    notifyListeners();
  }

  setActivePageHome(SectionType val) {
    activePageHome = val;
    notifyListeners();
  }
}
