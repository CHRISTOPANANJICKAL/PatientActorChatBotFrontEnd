import 'package:dio/dio.dart';

class Endpoints {
  static String baseUrl = 'http://127.0.0.1:5000/';
  static String chats = '${baseUrl}chats';

  static String getMessages(String chatId) => '${baseUrl}get_messages/$chatId';
  static String newChat = '${baseUrl}start_chat';
  static String sendMessage = '${baseUrl}send_message';

  static String evaluate(String chatId) => '${baseUrl}evaluate/$chatId';
  static String getMetrics = '${baseUrl}metrics';
  static String saveMatrics = '${baseUrl}set_metrics';
}

class ApiHelper {
  final Dio _dio;

  ApiHelper({Dio? dio})
      : _dio = dio ?? Dio(BaseOptions(connectTimeout: Duration(seconds: 20), receiveTimeout: Duration(seconds: 20)));

  /// GET request
  Future<dynamic> get(String url, {Map<String, dynamic>? queryParams}) async {
    try {
      final response = await _dio.get(url, queryParameters: queryParams);
      return response.data;
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw 'Unexpected error: $e';
    }
  }

  /// POST request
  Future<dynamic> post(String url, {dynamic data, Map<String, dynamic>? queryParams}) async {
    try {
      final response = await _dio.post(url, data: data, queryParameters: queryParams);
      return response.data;
    } on DioException catch (e) {
      print(e);
      throw _handleDioError(e);
    } catch (e) {
      throw 'Unexpected error: $e';
    }
  }

  /// Handles Dio errors and returns user-friendly messages
  String _handleDioError(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.sendTimeout ||
        e.type == DioExceptionType.receiveTimeout) {
      return 'Connection timeout. Please try again.';
    } else if (e.type == DioExceptionType.badResponse) {
      final statusCode = e.response?.statusCode;
      final statusMessage = e.response?.statusMessage ?? '';
      return 'Request failed [$statusCode]: $statusMessage';
    } else if (e.type == DioExceptionType.unknown) {
      return 'Network error. Please check your internet connection.';
    } else if (e.type == DioExceptionType.cancel) {
      return 'Request was cancelled.';
    } else {
      print(e);
      return 'Something went wrong. Please try again.';
    }
  }
}
