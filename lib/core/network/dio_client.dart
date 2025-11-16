import 'package:dio/dio.dart';

class DioClient {
  static final Dio dio = Dio(
    BaseOptions(
      baseUrl: "http://10.0.2.2:8080/api",
      connectTimeout: Duration(seconds: 10),
      receiveTimeout: Duration(seconds: 15),
      headers: {
        "Content-Type": "application/json",
      },
    ),
  );

  static void setToken(String token) {
    dio.options.headers["Authorization"] = "Bearer $token";
  }
}
