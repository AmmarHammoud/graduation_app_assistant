import 'package:dio/dio.dart';

import 'app_logger.dart';

/// A Dio interceptor that logs all API requests and responses.
/// Captures method, endpoint, headers, query params, request body, status codes, and response data.
class ApiLoggerInterceptor extends InterceptorsWrapper {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    AppLogger.instance.debug(
      '📤 API REQUEST',
      {
        'method': options.method,
        'url': options.uri.toString(),
        'headers': options.headers,
        'queryParameters': options.queryParameters,
        'data': options.data,
        'contentType': options.contentType?.toString(),
      },
    );
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    AppLogger.instance.info(
      '📥 API RESPONSE',
      {
        'method': response.requestOptions.method,
        'url': response.requestOptions.uri.toString(),
        'statusCode': response.statusCode,
        'statusMessage': response.statusMessage,
        'data': response.data,
      },
    );
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    AppLogger.instance.error(
      '❌ API ERROR',
      {
        'method': err.requestOptions.method,
        'url': err.requestOptions.uri.toString(),
        'statusCode': err.response?.statusCode,
        'statusMessage': err.response?.statusMessage,
        'errorType': err.type.toString(),
        'errorMessage': err.message,
        'responseData': err.response?.data,
      },
    );
    super.onError(err, handler);
  }
}

