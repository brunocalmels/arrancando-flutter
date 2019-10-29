import 'package:arrancando/config/globals/enums.dart';
import 'package:arrancando/config/models/category_wrapper.dart';

class GlobalSingleton {
  static final GlobalSingleton _singleton = GlobalSingleton._internal();
  Map<SectionType, List<CategoryWrapper>> categories = {
    SectionType.publicaciones: [],
    SectionType.recetas: [],
    SectionType.pois: [],
  };

  setCategories(SectionType type, List<CategoryWrapper> list) {
    categories[type] = list;
  }

  factory GlobalSingleton() {
    return _singleton;
  }

  GlobalSingleton._internal();
}
