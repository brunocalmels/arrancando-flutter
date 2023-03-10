import 'package:arrancando/config/globals/enums.dart';
import 'package:flutter/foundation.dart';

class ContentPageState extends ChangeNotifier {
  bool showSearchPage = false;
  bool showSearchResults = false;
  Map<SectionType, ContentSortType> sortContentBy = {
    SectionType.publicaciones: ContentSortType.fecha_creacion,
    SectionType.recetas: ContentSortType.fecha_creacion,
    SectionType.pois: ContentSortType.puntuacion,
  };
  Map<SectionType, int> savedFilters = {
    SectionType.publicaciones: -1,
    SectionType.publicaciones_categoria: -1,
    SectionType.recetas: -1,
    SectionType.pois: -1,
    SectionType.pois_ciudad: -1,
  };
  Map<SectionType, bool> showMine = {
    SectionType.publicaciones: false,
    SectionType.recetas: false,
    SectionType.pois: false,
  };
  DeferredExecutorStatus deferredExecutorStatus = DeferredExecutorStatus.none;

  void setSearchPageVisible(bool val) {
    showSearchPage = val;
    notifyListeners();
  }

  void setSearchResultsVisible(bool val) {
    showSearchResults = val;
    notifyListeners();
  }

  void setContentSortType(SectionType type, ContentSortType val) {
    sortContentBy[type] = val;
    notifyListeners();
  }

  void setSavedFilter(SectionType type, int val) {
    savedFilters[type] = val;
    notifyListeners();
  }

  void setShowMine(SectionType type, bool val) {
    showMine[type] = val;
    notifyListeners();
  }

  void setDeferredExecutorStatus(DeferredExecutorStatus val) {
    deferredExecutorStatus = val;
    notifyListeners();
  }
}
