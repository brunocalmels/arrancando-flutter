import 'package:arrancando/config/globals/enums.dart';
import 'package:arrancando/config/globals/index.dart';
import 'package:arrancando/config/models/category_wrapper.dart';
import 'package:arrancando/config/state/index.dart';
import 'package:provider/provider.dart';

class GlobalSingleton {
  static final GlobalSingleton _singleton = GlobalSingleton._internal();
  Map<SectionType, List<CategoryWrapper>> categories = {
    SectionType.publicaciones: [],
    SectionType.recetas: [],
    SectionType.pois: [],
  };

  setCategories(SectionType type, List<CategoryWrapper> list) {
    categories[type] = list;
    MyState st = Provider.of<MyState>(
      MyGlobals.mainNavigatorKey.currentContext,
      listen: false,
    );
    if (st.preferredCategories[type] == null)
      st.setPreferredCategories(type, list.first.id);
  }

  factory GlobalSingleton() {
    return _singleton;
  }

  GlobalSingleton._internal();
}
