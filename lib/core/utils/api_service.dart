import 'package:dio/dio.dart';

class ApiService {
  final Dio dio = Dio();

  Future<Response> post({
    required Map<String, dynamic> body,
    required String url,
    required String token,
    String? contentType,
  }) async {
    var response = await dio.post(
      url,
      data: FormData.fromMap(body),
      options: Options(
        contentType: 'application/x-www-form-urlencoded',
        headers: {
          'Authorization': 'Bearer $token',
        },
      ),
    );

    return response;
  }
}
