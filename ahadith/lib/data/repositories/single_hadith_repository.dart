import 'package:ahadith/data/models/hadith.dart';

import '../data_providers/single_hadith_provider.dart';

class SingleHadithRepository {
  final SingleHadithDataProvider _singleHadithDataProvider;
  SingleHadithRepository(this._singleHadithDataProvider);

  Future<DetailedHadith> getHadith({required String hadithId}) async{
    final h = await _singleHadithDataProvider.getHadith(hadithId: hadithId,);
    return DetailedHadith.fromJson(h);
  }

  Future<List<DetailedHadith>> getHadiths({required List<String> hadithIds}) async{
    List<DetailedHadith> hadiths = [];
    int ahadithCount = 0;
    hadithIds.forEach((hadithId) async {
      ahadithCount++;
      final h = await _singleHadithDataProvider.getHadith(hadithId: hadithId,);
      DetailedHadith hadith = DetailedHadith.fromJson(h);
      if(hadith.title != null) {
        hadiths.add(hadith);
      }
      // if(ahadithCount == 20) {
      //   ahadithCount = 0;
      //   await Future.delayed(const Duration(seconds: 1,milliseconds: 500));
      // }
    });
    return hadiths;
  }
}