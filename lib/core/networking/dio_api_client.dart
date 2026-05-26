import 'package:chat_bot/core/constants/app_constants.dart';
import 'package:chat_bot/core/errors/app_exception.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class DioApiClient {
  late final Dio _dio;

  DioApiClient() {
    _dio = Dio(
      BaseOptions(
        baseUrl: AppConstants.baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          if (kDebugMode) {
            print('REQUEST[${options.method}] => PATH: ${options.path}');
          }
          return handler.next(options);
        },
        onResponse: (response, handler) {
          if (kDebugMode) {
            print(
              'RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}',
            );
          }
          return handler.next(response);
        },
        onError: (DioException e, handler) {
          if (kDebugMode) {
            print(
              'ERROR[${e.response?.statusCode}] => PATH: ${e.requestOptions.path}',
            );
          }
          return handler.next(e);
        },
      ),
    );
  }

  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Maps a [DioException] to a typed [AppException].
  /// Throws — never returns — so callers get the correct type.
  Never _handleError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        throw const NetworkException('Connection timed out. Please try again.');
      case DioExceptionType.connectionError:
        throw const NetworkException('No internet connection.');
      case DioExceptionType.badResponse:
        throw ServerException(
          _messageFromStatusCode(error.response?.statusCode),
          statusCode: error.response?.statusCode,
        );
      case DioExceptionType.cancel:
        throw const NetworkException('Request was cancelled.');
      default:
        throw const NetworkException('Something went wrong. Please try again.');
    }
  }

  String _messageFromStatusCode(int? statusCode) {
    return switch (statusCode) {
      400 => 'Bad request.',
      401 => 'Unauthorized — check your API key.',
      403 => 'Forbidden.',
      404 => 'Resource not found.',
      429 => 'Rate limit reached. Try again later.',
      500 => 'Internal server error.',
      502 => 'Bad gateway.',
      _ => 'Server error (${statusCode ?? 'unknown'}).',
    };
  }
}
