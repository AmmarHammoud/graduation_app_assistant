import 'package:dio/dio.dart';
import 'package:graduation_app_assistant/core/services/token_storage.dart';
import '../utils/backend_endpoints.dart';
import 'database_service.dart';
import 'api_logger_interceptor.dart';

class ApiService implements DatabaseService {
  final Dio dio;

  ApiService()
    : dio = Dio(
        BaseOptions(
          baseUrl: BackendEndPoint.apiUrl,
          connectTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 30),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
        ) {
        // Add API logger interceptor first (logs all requests/responses)
        dio.interceptors.add(ApiLoggerInterceptor());

        // Add token injection interceptor
        dio.interceptors.add(
          InterceptorsWrapper(
            onRequest: (options, handler) async {
              String? accessToken = await TokenStorage().readAccess();
              if (accessToken != null &&
                  accessToken.isNotEmpty &&
                  options.headers['Authorization'] == null) {
                options.headers['Authorization'] = 'Bearer $accessToken';
              }
              return handler.next(options);
            },
          ),
        );
      }

  @override
  Future addData({
    required String endpoint,
    required dynamic data,
    String? rowid,
  }) async {
    final Response res = await dio.post(endpoint + (rowid ?? ''), data: data);
    return res.data;
  }

  @override
  Future getData({
    required String endpoint,
    String? rowid,
    Map<String, dynamic>? quary,
  }) async {
    final Response res = await dio.get(
      endpoint + (rowid ?? ''),
      queryParameters: quary,
    );
    return res.data;
  }

  @override
  Future deleteData({required String endpoint, String? rowid}) async {
    final Response res = await dio.delete(endpoint + (rowid ?? ''));
    return res.data;
  }

  @override
  Future updateData({
    required String endpoint,
    String? rowid,
    dynamic data,
  }) async {
    final Response res = await dio.put(endpoint + (rowid ?? ''), data: data);
    return res.data;
  }
}
