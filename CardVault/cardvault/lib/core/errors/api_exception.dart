import 'package:dio/dio.dart';

class ApiException implements Exception {
  const ApiException(this.message, {this.statusCode});

  final String message;
  final int? statusCode;

  factory ApiException.fromDio(DioException error) {
    final status = error.response?.statusCode;
    final data = error.response?.data;

    if (data is Map && data['message'] != null) {
      return ApiException(
        data['message'].toString(),
        statusCode: status,
      );
    }

    return ApiException(
      error.message ?? 'Network request failed',
      statusCode: status,
    );
  }

  @override
  String toString() => message;
}
