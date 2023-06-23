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
    _favoriteItems.clear();
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

  void addFavorite(String id, DetailedHadith hadith, String categoryTitle, int hadithIndex, bool fromSaved) {
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
        'categories': [categoryTitle,...hadith.categories!],
        'wordsMeanings': hadith.wordsMeanings!.isNotEmpty?hadith.wordsMeanings!.toList().toString():null,
        'reference': fromSaved? '${hadithIndex.toString()} من المحفوظات ' :(hadithIndex+1).toString(),
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

  void toggleFavorite(String id, DetailedHadith hadith, String categoryTitle, int hadithIndex, bool formSaved) {
    if (_favoriteIDs.contains(id)) {
      removeFavorite(id, hadith);
    } else {
      addFavorite(id, hadith, categoryTitle, hadithIndex, formSaved);
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

  Map<String,List<DetailedHadith>> _savedCategories = {};
  List _savedCategoriesIds = [];
  Map<String,String> _savedCategoriesTitles = {};
  List <String> _savedCategoriesTitlesList = [];


  Map<String,List<DetailedHadith>> get savedCategories {
    return {..._savedCategories};
  }

  Map<String,String> get savedCategoriesTitles {
    return {..._savedCategoriesTitles};
  }

  List<String> get savedCategoriesTitlesList {
    return [..._savedCategoriesTitlesList];
  }

  List get savedCategoriesIds {
    fitchSaved();
    return [..._savedCategoriesIds];
  }

  void addSaved(List<DetailedHadith> ahadith, Category category) {
    if(_savedBox.containsKey(category.id)) return;

    fitchSaved();

    _savedCategoriesIds.add(category.id);
    _savedBox.put(0, _savedCategoriesIds);

    List<Map<String, dynamic>> ahadithMap = turnAhadithToMaps(ahadith);

    _savedBox.put(category.id, ahadithMap);
    _savedBox.put('catName${category.id}', category.title);

    fitchSaved();

    notifyListeners();
  }


  void fitchSaved() {
    // _savedCategoriesIds.clear();
    _savedCategoriesIds = _savedBox.get(0,defaultValue: []);
    // _savedCategories.clear();

    _savedCategoriesTitlesList.clear();

    for(var id in _savedCategoriesIds){
      _savedCategoriesTitles.putIfAbsent(id, () => _savedBox.get('catName$id'));
      _savedCategoriesTitlesList.add(_savedBox.get('catName$id'));

      List<dynamic> ahadithMap = _savedBox.get(id);
      List<DetailedHadith> ahadith = turnMapsToAhadith(ahadithMap);
      _savedCategories.putIfAbsent(id, () => ahadith);
    }
    print('_savedCategoriesIds inside fitchSaved------------------------$_savedCategoriesIds');

    print('_savedCategoriesTitles inside fitchSaved------------------------$_savedCategoriesTitles');

    print('_savedCategoriesTitlesList inside fitchSaved------------------------$_savedCategoriesTitlesList');

    print('_savedCategories inside fitchSaved------------------------$_savedCategories');

  }

  bool isSaved(String id) {
    return _savedBox.containsKey(id);
  }

  int get savedCount {
    return _savedCategoriesIds.length;
  }


  List<Map<String, dynamic>> turnAhadithToMaps(List<DetailedHadith> ahadith) {
    List<Map<String, dynamic>> ahadithMap = ahadith
        .map((hadith) => {
      'id': hadith.id.toString(),
      'title': hadith.title.toString(),
      'hadeeth': hadith.hadeeth.toString(),
      'attribution': hadith.attribution.toString(),
      'grade': hadith.grade.toString(),
      'explanation': hadith.explanation.toString(),
      'categories': hadith.categories,
      'wordsMeanings':hadith.wordsMeanings != null? hadith.wordsMeanings!.isNotEmpty?hadith.wordsMeanings!.toString():[]: [],
      'reference': hadith.reference.toString(),

    }).toList();
    return ahadithMap;
  }

  List<DetailedHadith> turnMapsToAhadith(List<dynamic> ahadithMap) {
    List<DetailedHadith> ahadith = ahadithMap
        .map((hadith) => DetailedHadith(
      id: hadith['id']!,
      title: hadith['title']!,
      hadeeth: hadith['hadeeth']!,
      attribution: hadith['attribution']!,
      grade: hadith['grade']!,
      explanation: hadith['explanation']??[],
      categories: hadith['categories']??[],
      wordsMeanings: hadith['wordsMeanings'] != null
          ? [
        WordsMeanings(
            word:
            '${hadith['wordsMeanings'].toString().split(',')}',
            meaning: '')
      ]
          : [],
      reference: hadith['reference']!,
    ))
        .toList();
    return ahadith;
  }

}
