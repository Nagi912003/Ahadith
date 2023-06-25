// import 'package:dio/dio.dart';
//
// class HijriDateConversionProvider {
//   late Dio dio;
//
//   HijriDateConversionProvider() {
//     BaseOptions options = BaseOptions(
//       baseUrl: 'http://api.aladhan.com/v1/gToH',
//       receiveDataWhenStatusError: true,
//       connectTimeout: const Duration(seconds: 60), // 60 seconds
//       receiveTimeout: const Duration(seconds: 60), // 60 seconds
//     );
//     dio = Dio(options);
//   }
//
//   Future<String> getHijriDate({required String date}) async {
//     try {
//       Response response = await dio.get('/$date');
//       return response.data['data']['hijri']['date'];
//     } catch (e) {
//       return e.toString();
//     }
//   }
// }