import 'package:dio/dio.dart';

import 'package:ahadith/constants/strings.dart';

class SingleHadithDataProvider {
  late Dio dio;

  SingleHadithDataProvider() {
    BaseOptions options = BaseOptions(
      baseUrl: baseUrl,
      receiveDataWhenStatusError: true,
      connectTimeout: const Duration(seconds: 60), // 60 seconds
      receiveTimeout: const Duration(seconds: 60), // 60 seconds
    );
    dio = Dio(options);
  }

  Future<Map<String, dynamic>> getHadith({required String hadithId}) async {
    try {
      Response response = await dio.get('/hadeeths/one/?language=$lang&id=$hadithId');
      return response.data;
    } catch (e) {
      print('------------------------error in SHProvider------------------------: $e');
      return {};
    }
  }
  // void close() {
  //   dio.close;
  // }
  // dispose() {
  //   dio.close;
  // }
}