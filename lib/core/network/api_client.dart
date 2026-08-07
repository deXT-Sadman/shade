import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../constants/app_constants.dart';
import '../error/exceptions.dart';

/// Callback fired when a 401 is received globally — used to trigger logout.
typedef OnUnauthorized = void Function();

class ApiClient {
  final Dio dio;
  final FlutterSecureStorage secureStorage;
  final OnUnauthorized? onUnauthorized;

  ApiClient({
    required this.secureStorage,
    this.onUnauthorized,
  }) : dio = Dio(
          BaseOptions(
            baseUrl: dotenv.env['BASE_URL'] ?? AppConstants.baseUrl,
            connectTimeout: AppConstants.apiTimeout,
            receiveTimeout: AppConstants.apiTimeout,
            sendTimeout: AppConstants.apiTimeout,
            contentType: 'application/json',
          ),
        ) {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await secureStorage.read(key: AppConstants.kJwtToken);
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (DioException error, handler) async {
          if (error.response?.statusCode == 401) {
            await secureStorage.delete(key: AppConstants.kJwtToken);
            onUnauthorized?.call();
          }
          return handler.next(error);
        },
      ),
    );

    if (const bool.fromEnvironment('dart.vm.product') == false) {
      dio.interceptors.add(
        LogInterceptor(requestBody: true, responseBody: true),
      );
    }
  }

  /// Wraps a Dio call and maps DioException -> domain-level exceptions.
  Future<Response> safeRequest(Future<Response> Function() request) async {
    try {
      return await request();
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout ||
          e.type == DioExceptionType.connectionError) {
        throw NetworkException();
      }
      if (e.response?.statusCode == 401) {
        throw UnauthorizedException();
      }
      final message = e.response?.data is Map
          ? (e.response?.data['message']?.toString() ?? 'Server error occurred')
          : 'Server error occurred';
      throw ServerException(message);
    }
  }
}
