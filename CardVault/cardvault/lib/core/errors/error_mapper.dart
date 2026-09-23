import 'package:dio/dio.dart';
import 'api_exception.dart';

String userFacingError(Object error) {
  if (error is ApiException) return error.message;
  if (error is DioException) return ApiException.fromDio(error).message;
  return error.toString().replaceFirst('Exception: ', '');
}
