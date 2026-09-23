import 'package:dio/dio.dart';

class ApiClient {
  ApiClient({String? baseUrl})
      : _dio = Dio(
          BaseOptions(
            baseUrl: baseUrl ?? ApiConfig.baseUrl,
            connectTimeout: const Duration(seconds: 5),
            receiveTimeout: const Duration(seconds: 10),
            sendTimeout: const Duration(seconds: 10),
            headers: const {
              'Accept': 'application/json',
              'Content-Type': 'application/json',
            },
          ),
        );

  final Dio _dio;

  Future<dynamic> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    final response = await _dio.get(
      path,
      queryParameters: queryParameters,
    );
    return response.data;
  }

  Future<dynamic> post(
    String path, {
    Object? data,
    Map<String, dynamic>? headers,
  }) async {
    final response = await _dio.post(
      path,
      data: data,
      options: Options(headers: headers),
    );
    return response.data;
  }

  Future<dynamic> patch(
    String path, {
    Object? data,
  }) async {
    final response = await _dio.patch(path, data: data);
    return response.data;
  }
}

/// Change only this value when moving the Flutter app between devices.
///
/// Linux/Desktop:
///   http://127.0.0.1:8080
///
/// Android emulator:
///   http://10.0.2.2:8080
///
/// Physical Android phone:
///   http://YOUR_LAPTOP_IP:8080
class ApiConfig {
  static const baseUrl = 'http://127.0.0.1:8080';
}
