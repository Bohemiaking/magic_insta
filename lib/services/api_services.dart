import "dart:async";

import "package:dio/dio.dart";
import "package:pretty_dio_logger/pretty_dio_logger.dart";

class ApiService {
  final Dio _dio = Dio();
  final Duration _timeOut = const Duration(minutes: 1);

  ApiService() {
    _dio.interceptors.add(PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
        compact: false,
        maxWidth: 120));
  }

  //get method supports additional headers & authrization
  Future<Response> get(String path,
      {Map<String, dynamic>? additionalHeaders,
      CancelToken? cancelToken}) async {
    final Map<String, dynamic> headers = {};

    // if (authController.isLoggedIn == true) {
    //   headers["authorization"] = authController.authToken.value;
    // }

    if (additionalHeaders != null) {
      headers.addAll(additionalHeaders);
    }

    try {
      final response = await _dio.get(path,
          options: Options(headers: headers, sendTimeout: _timeOut),
          cancelToken: cancelToken);
      return response;
    } catch (error) {
      _handleError(error);
      rethrow;
    }
  }

  //post method supports additional headers & authrization
  Future<Response> post(String path, dynamic data,
      {Map<String, dynamic>? additionalHeaders, bool? isCustomURI}) async {
    Map<String, dynamic> headers = {};

    // if (authController.isLoggedIn == true) {
    //   headers["authorization"] = authController.authToken.value;
    // }

    if (additionalHeaders != null) {
      headers.addAll(additionalHeaders);
    }
    try {
      final response = await _dio.post(path,
          data: data,
          options: Options(headers: headers, sendTimeout: _timeOut));
      return response;
    } catch (error) {
      _handleError(error);
      rethrow;
    }
  }

  Future<void> _handleError(dynamic error) async {
    if (error is DioException) {
      final dioError = error;
      if (dioError.response != null) {
        // Handle DioError with a response (e.g., server returned an error)
        // final errorMessage = dioError.response!.data.toString();
        // CustomSnackbar.showSnackBar(dioError.response?.data["message"] ??
        //     "An unexpected error occurred.");
        // if (dioError.response?.statusCode == 401) {
        //   await authController.logout();
        //   if (context != null && context.mounted) {
        //     context.go(AppRoutes.login);
        //   }
        // }
      } else {
        // CustomSnackbar.showSnackBar("An unexpected error occurred.");
        // Handle DioError without a response (e.g., network connectivity issue)

        // CustomSnackBar.showSnackBar(
        //     CustomSnackBar.error,
        //     'Network error. Please check your connection.',
        //     CustomSnackBar.error);
      }
    } else {
      // CustomSnackbar.showSnackBar("An unexpected error occurred.");
      // Handle generic errors (e.g., unexpected errors)
      // CustomSnackBar.showSnackBar(CustomSnackBar.error,
      //     'An unexpected error occurred.', CustomSnackBar.error);
    }
  }
}
