import 'package:arrancando/config/globals/enums.dart';
import 'package:flutter/foundation.dart';

class ContentPageState extends ChangeNotifier {
  bool showSearchPage = false;
  bool showSearchResults = false;
  ContentSortType sortContentBy = ContentSortType.fecha;
  bool fetchContent = false;
  bool fetchMoreContent = false;

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

  setFetchContent(bool val) {
    fetchContent = val;
    notifyListeners();
  }

  setFetchMoreContent(bool val) {
    fetchContent = val;
    notifyListeners();
  }
}
