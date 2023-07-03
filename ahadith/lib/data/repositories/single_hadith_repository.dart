import 'package:ahadith/data/models/hadith.dart';

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

    print('hadiths---------from SHSRepository---------:${hadiths.length}');
    return hadiths;
  }


// Future<List<DetailedHadith>> getHadiths(
  //     {required List<String> hadithIds}) async {
  //   List<dynamic> hs =
  //       await _singleHadithDataProvider.getAHadith(ahadithIds: hadithIds);
  //   List<DetailedHadith> hadiths = hs.map((e) {
  //     String? id;
  //     String? title;
  //     String? hadeeth;
  //     String? attribution;
  //     String? grade;
  //     String? explanation;
  //     List<String>? hints;
  //     List<String>? categories;
  //     List<String>? translations;
  //     List<WordsMeanings>? wordsMeanings;
  //     String? reference;
  //
  //     e.then((json) {
  //       id = json['id'];
  //       title = json['title'];
  //       hadeeth = json['hadeeth'];
  //       attribution = json['attribution'];
  //       grade = json['grade'];
  //       explanation = json['explanation'];
  //       if (json['hints'] != null) {
  //         hints = json['hints'].cast<String>()??[];
  //       }else{
  //         hints = null;
  //       }
  //       if (json['categories'] != null) {
  //         categories = json['categories'].cast<String>()??[];
  //       }else{
  //         categories = null;
  //       }
  //       if (json['translations'] != null) {
  //         translations = json['translations'].cast<String>()??[];
  //       }else{
  //         translations = null;
  //       }
  //       if (json['words_meanings'] != null) {
  //         wordsMeanings = <WordsMeanings>[];
  //         json['words_meanings'].forEach((v) {
  //           wordsMeanings!.add(WordsMeanings.fromJson(v));
  //         });
  //       }
  //       reference = json['reference'];
  //   });
  //
  //     return DetailedHadith(
  //       id: id,
  //       title: title,
  //       hadeeth: hadeeth,
  //       explanation: explanation,
  //       attribution: attribution,
  //       reference: reference,
  //       grade: grade,
  //       wordsMeanings: wordsMeanings,
  //       hints: hints,
  //       categories: categories,
  //       translations: translations,
  //     );
  //   }).toList();
  //   print('hadiths---------from SHSRepository---------:${hadiths.length}: ${hadiths}');
  //   return hadiths;
  //
  //   // hadithIds.forEach((hadithId) async {
  //   //   final h = await _singleHadithDataProvider.getHadith(hadithId: hadithId,);
  //   //   DetailedHadith hadith = DetailedHadith.fromJson(h);
  //   //   if(hadith.title != null) {
  //   //     hadiths.add(hadith);
  //   //   }
  //   // });
  //   // if(hadiths.length >= hadithIds.length){
  //   //   return hadiths;
  //   // }
  // }
}
