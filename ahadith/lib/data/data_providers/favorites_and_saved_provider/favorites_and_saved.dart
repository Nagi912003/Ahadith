import 'package:flutter/material.dart';

import '/data/repositories/single_hadith_repository.dart';
import 'package:ahadith/data/models/hadith.dart';

class FavoritesAndSavedProvider with ChangeNotifier {

  late final SingleHadithRepository singleHadithRepository ;


  final List<String> _favoriteIDs = [];

  final List<DetailedHadith> _favoriteItems = [];

  final List<String> _savedItems = [];

  List get favoriteIDs {
    return [..._favoriteIDs];
  }
  List get favoriteItems {
    return [..._favoriteItems];
  }

  void fetshFavorites(){
    _favoriteIDs.forEach((id) {

    });
  }

  void addFavorite(String id,DetailedHadith hadith) {
    if(_favoriteIDs.contains(id)) return;
    _favoriteIDs.add(id);
    _addToFavorites(hadith);

    notifyListeners();
  }
  void _addToFavorites(DetailedHadith hadith) {
    _favoriteItems.add(hadith);
    notifyListeners();
  }

  void removeFavorite(String id,DetailedHadith hadith) {
    _favoriteIDs.remove(id);
    _removeFromFavorites(hadith);
    notifyListeners();
  }
  void _removeFromFavorites(DetailedHadith hadith) {
    _favoriteItems.remove(hadith);
    notifyListeners();
  }

  void toggleFavorite(String id,DetailedHadith hadith) {
    if(_favoriteIDs.contains(id)) {
      removeFavorite(id, hadith);
    } else {
      addFavorite(id, hadith);
    }
    // notifyListeners();
  }

  void clearFavorites() {
    _favoriteIDs.clear();
    notifyListeners();
  }

  bool isFavorite(String id) {
    return _favoriteIDs.contains(id);
  }

  int get favoriteCount {
    return _favoriteIDs.length;
  }

  List get savedItems {
    return [..._savedItems];
  }

  void addSaved(String id) {
    if(_savedItems.contains(id)) return;
    _savedItems.add(id);
    notifyListeners();
  }

  void removeSaved(String id) {
    _savedItems.remove(id);
    notifyListeners();
  }

  void toggleSaved(String id) {
    if(_savedItems.contains(id)) {
      _savedItems.remove(id);
    } else {
      _savedItems.add(id);
    }
    // notifyListeners();
  }

  void clearSaved() {
    _savedItems.clear();
    notifyListeners();
  }

  bool isSaved(String id) {
    return _savedItems.contains(id);
  }

  int get savedCount {
    return _savedItems.length;
  }
}
