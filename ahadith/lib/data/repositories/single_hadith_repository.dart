import 'package:ahadith/data/models/hadith.dart';
import 'package:flutter/foundation.dart';

import '../data_providers/single_hadith_provider.dart';

class SingleHadithRepository {
  final SingleHadithDataProvider _singleHadithDataProvider;
  SingleHadithRepository(this._singleHadithDataProvider);

  Future<DetailedHadith> getHadith({required String hadithId}) async {
    final h = await _singleHadithDataProvider.getHadith(
      hadithId: hadithId,
    );
    if (h == {}) {
      return DetailedHadith(title: null);
    }
    return DetailedHadith.fromJson(h);
  }


  Future<List<DetailedHadith>> getHadiths({required List<String> hadithIds}) async {
    List<dynamic> hs = await _singleHadithDataProvider.getAHadith(ahadithIds: hadithIds);

    List<Future<DetailedHadith>> futures = hs.map((e) async {
      Map<String, dynamic> json = await e;

      String? id = json['id'];
      String? title = json['title'];
      String? hadeeth = json['hadeeth'];
      String? attribution = json['attribution'];
      String? grade = json['grade'];
      String? explanation = json['explanation'];
      List<String>? hints = json['hints']?.cast<String>();
      List<String>? categories = json['categories']?.cast<String>();
      List<String>? translations = json['translations']?.cast<String>();
      List<WordsMeanings>? wordsMeanings = json['words_meanings'] != null
          ? (json['words_meanings'] as List<dynamic>)
          .map((v) => WordsMeanings.fromJson(v))
          .toList()
          : null;
      String? reference = json['reference'];

      return DetailedHadith(
        id: id,
        title: title,
        hadeeth: hadeeth,
        explanation: explanation,
        attribution: attribution,
        reference: reference,
        grade: grade,
        wordsMeanings: wordsMeanings,
        hints: hints,
        categories: categories,
        translations: translations,
      );
    }).toList();

    List<DetailedHadith> hadiths = await Future.wait(futures);

    return hadiths;
  }
}
