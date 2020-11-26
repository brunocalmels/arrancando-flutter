import 'package:arrancando/config/globals/enums.dart';
import 'package:arrancando/config/globals/index.dart';
import 'package:arrancando/config/models/category_wrapper.dart';
import 'package:arrancando/config/state/user.dart';
import 'package:provider/provider.dart';

class GlobalSingleton {
  static final GlobalSingleton _singleton = GlobalSingleton._internal();
  Map<SectionType, List<CategoryWrapper>> categories = {
    SectionType.publicaciones: [],
    SectionType.recetas: [],
    SectionType.pois: [],
  };

  bool askingLocationPermission = false;

  void setCategories(SectionType type, List<CategoryWrapper> list) {
    categories[type] = list;
    final st = Provider.of<UserState>(
      MyGlobals.mainNavigatorKey.currentContext,
      listen: false,
    );
    if (st.preferredCategories[type] == null) {
      if (type == SectionType.pois) {
        final verdulerias = list.firstWhere(
          (i) => i.nombre == 'Verdulerías',
          orElse: () => null,
        );
        if (verdulerias != null) {
          st.setPreferredCategories(type, verdulerias.id);
        } else {
          st.setPreferredCategories(type, list.first.id);
        }
      } else {
        st.setPreferredCategories(type, list.first.id);
      }
    }
  }

  void setAskingLocationPermission(bool val) {
    askingLocationPermission = val;
  }

  factory GlobalSingleton() {
    return _singleton;
  }

  GlobalSingleton._internal();
}
