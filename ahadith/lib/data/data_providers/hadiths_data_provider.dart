import 'package:dio/dio.dart';

import 'package:ahadith/constants/strings.dart';

class HadithsDataProvider {
  late Dio dio;

  HadithsDataProvider() {
    BaseOptions options = BaseOptions(
      baseUrl: baseUrl,
      receiveDataWhenStatusError: true,
      connectTimeout: const Duration(seconds: 60), // 60 seconds
      receiveTimeout: const Duration(seconds: 60), // 60 seconds
    );
    dio = Dio(options);
  }

  Future<List<dynamic>> getAllHadiths({required String categoryId, String page = '1', String perPage = '20'}) async {
    try {
      Response response = await dio.get('/hadeeths/list/?language=$lang&category_id=$categoryId&page=$page&per_page=$perPage');
      return response.data['data'];
    } catch (e) {
      return [];
    }
  }
  void close() {
    dio.close;
  }
  dispose() {
    dio.close;
  }
}