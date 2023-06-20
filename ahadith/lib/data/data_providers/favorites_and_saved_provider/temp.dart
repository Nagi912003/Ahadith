import 'package:ahadith/data/models/category.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:ahadith/data/models/hadith.dart';

class FavoritesAndSavedProvider with ChangeNotifier {
  final Box _favoriteBox = Hive.box('favorites');


  FavoritesAndSavedProvider() {
    fitchFavorites();
  }



  List _favoriteIDs = [];
  final List<DetailedHadith> _favoriteItems = [];

  Set get favoriteIDs {
    fitchFavorites();
    return {..._favoriteIDs};
  }

  List get favoriteItems {
    fitchFavorites();
    return [..._favoriteItems];
  }

  void fitchFavorites() {
    _favoriteIDs = _favoriteBox.get(0, defaultValue: []);
    for (var id in _favoriteIDs) {
      if(!_favoriteItems.any((element) => element.id == id)){
        _favoriteItems.add(
          DetailedHadith(
            id: id,
            title: _favoriteBox.get(id)['title'],
            hadeeth: _favoriteBox.get(id)['hadeeth'],
            attribution: _favoriteBox.get(id)['attribution'],
            grade: _favoriteBox.get(id)['grade'],
            explanation: _favoriteBox.get(id)['explanation'],
            categories: _favoriteBox.get(id)['categories'],
            wordsMeanings: _favoriteBox.get(id)['wordsMeanings'] != null
                ? [
              WordsMeanings(
                  word:
                  '${_favoriteBox.get(id)['wordsMeanings'].toString().split(',')}',
                  meaning: '')
            ]
                : [],
            reference: _favoriteBox.get(id)['reference'],
          ),
        );
      }
    }
  }

  void addFavorite(String id, DetailedHadith hadith) {
    fitchFavorites();

    if(_favoriteIDs.contains(id)) return;

    _favoriteIDs.add(id);
    _favoriteBox.put(0, _favoriteIDs);

    _favoriteIDs = _favoriteBox.get(0) ?? [];

    _favoriteBox.put(
      hadith.id,
      {
        'id': hadith.id,
        'title': hadith.title,
        'hadeeth': hadith.hadeeth,
        'attribution': hadith.attribution,
        'grade': hadith.grade,
        'explanation': hadith.explanation,
        'categories': hadith.categories,
        'wordsMeanings': hadith.wordsMeanings!.isNotEmpty?hadith.wordsMeanings!.toList().toString():null,
        'reference': hadith.reference,
      },
    );

    fitchFavorites();

    notifyListeners();
  }

  void removeFavorite(String id, DetailedHadith hadith) {
    // _favoriteBox.clear();
    fitchFavorites();

    if(_favoriteIDs.contains(id)){

      _favoriteIDs.remove(id);
      _favoriteBox.put(0, _favoriteIDs);

      _favoriteBox.delete(hadith.id);

      fitchFavorites();

      notifyListeners();
    }
  }

  void toggleFavorite(String id, DetailedHadith hadith) {
    if (_favoriteIDs.contains(id)) {
      removeFavorite(id, hadith);
    } else {
      addFavorite(id, hadith);
    }
    // notifyListeners();
  }

  void clearFavorites() {
    _favoriteIDs.clear();
    _favoriteBox.clear();
    notifyListeners();
  }

  bool isFavorite(String id) {
    fitchFavorites();
    return _favoriteIDs.contains(id);
  }

  int get favoriteCount {
    fitchFavorites();
    return _favoriteIDs.length;
  }




  //-------------------- Saved --------------------

  final Box _savedBox = Hive.box('saved');

  final Map<String,List<DetailedHadith>> _savedCategories = {};


  Map<String,List<DetailedHadith>> get savedCategories {
    return {..._savedCategories};
  }

  void addSaved(List<DetailedHadith> ahadith, Category category) {
    if(_savedCategories.containsKey(category.id)) return;

    List<Map<String, String?>> ahadithMap = turnAhadithToMaps(ahadith);

    _savedBox.put(category.id, ahadithMap);


    notifyListeners();
  }

  List<Map<String, String?>> turnAhadithToMaps(List<DetailedHadith> ahadith) {
    List<Map<String, String?>> ahadithMap = ahadith
        .map((hadith) => {
      'id': hadith.id.toString(),
      'title': hadith.title.toString(),
      'hadeeth': hadith.hadeeth.toString(),
      'attribution': hadith.attribution.toString(),
      'grade': hadith.grade.toString(),
      'explanation': hadith.explanation.toString(),
      'categories': hadith.categories.toString(),
      'wordsMeanings': hadith.wordsMeanings!.isNotEmpty?hadith.wordsMeanings!.toList().toString():null,
      'reference': hadith.reference.toString(),

    }).toList();
    return ahadithMap;
  }

  // bool isSaved(String id) {
  //   // return _savedCategories.contains(id);
  // }

  int get savedCount {
    return _savedCategories.length;
  }
}
