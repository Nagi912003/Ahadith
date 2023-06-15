import 'package:ahadith/data/models/hadith.dart';

import '../data_providers/hadiths_data_provider.dart';

class HadithsRepository {
  final HadithsDataProvider _hadithsDataProvider;
  HadithsRepository(this._hadithsDataProvider);

  Future<List<Hadith>> getAllHadiths({required String categoryId, String page = '1', String perPage = '20'}) async{
    final hadiths = await _hadithsDataProvider.getAllHadiths(categoryId: categoryId, page: page, perPage: perPage);
    return hadiths.map((hadith) => Hadith.fromJson(hadith)).toList();
  }
  void close() {
    _hadithsDataProvider.close;
  }
  dispose() {
    _hadithsDataProvider.close;
  }
}