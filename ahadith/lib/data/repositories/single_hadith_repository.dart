import 'package:ahadith/data/models/hadith.dart';

import '../data_providers/single_hadith_provider.dart';

class SingleHadithRepository {
  final SingleHadithDataProvider _singleHadithDataProvider;
  SingleHadithRepository(this._singleHadithDataProvider);

  Future<DetailedHadith> getHadith({required String hadithId}) async{
    final h = await _singleHadithDataProvider.getHadith(hadithId: hadithId,);
    return DetailedHadith.fromJson(h);
  }
}