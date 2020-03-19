import 'package:arrancando/config/globals/enums.dart';
import 'package:flutter/foundation.dart';

class ContentPageState extends ChangeNotifier {
  bool showSearchPage = false;
  bool showSearchResults = false;
  ContentSortType sortContentBy = ContentSortType.fecha;
  Map<SectionType, int> savedFilters = {
    SectionType.publicaciones: -1,
    SectionType.publicaciones_categoria: -1,
    SectionType.recetas: -1,
    SectionType.pois: -1,
  };

  setSearchPageVisible(bool val) {
    showSearchPage = val;
    notifyListeners();
  }

  setSearchResultsVisible(bool val) {
    showSearchResults = val;
    notifyListeners();
  }

  setContentSortType(ContentSortType type) {
    sortContentBy = type;
    notifyListeners();
  }

  setSavedFilter(SectionType type, int val) {
    savedFilters[type] = val;
    notifyListeners();
  }
}
