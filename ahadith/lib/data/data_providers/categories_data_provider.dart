import 'package:dio/dio.dart';

import 'package:ahadith/constants/strings.dart';

class CategoriesDataProvider {
  late Dio dio;

  CategoriesDataProvider() {
    BaseOptions options = BaseOptions(
      baseUrl: baseUrl,
      receiveDataWhenStatusError: true,
      connectTimeout: const Duration(seconds: 60), // 60 seconds
      receiveTimeout: const Duration(seconds: 60), // 60 seconds
    );
    dio = Dio(options);
  }

  Future<List<dynamic>> getAllCategories() async {
    try {
      Response response = await dio.get('/categories/list/?language=$lang');
      return response.data;
    } catch (e) {
      return [];
    }
  }
}