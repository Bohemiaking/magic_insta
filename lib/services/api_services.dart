import "dart:async";

import "package:dio/dio.dart";
import "package:flutter/material.dart";
import "package:magic_insta/utils/widgets/custom_snackbar.dart";
import "package:pretty_dio_logger/pretty_dio_logger.dart";

class ApiService {
  final Dio _dio = Dio();
  final Duration _timeOut = const Duration(minutes: 1);

  ApiService() {
    _dio.interceptors.add(
      PrettyDioLogger(
        requestHeader: false,
        requestBody: true,
        responseBody: false,
        responseHeader: false,
        error: true,
        compact: true,
        maxWidth: 120,
      ),
    );
  }

  //get method supports additional headers & authrization
  Future<Response> get(
    BuildContext context,
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? additionalHeaders,
  }) async {
    final Map<String, dynamic> headers = {};

    if (additionalHeaders != null) {
      headers.addAll(additionalHeaders);
    }

    try {
      final response = await _dio.get(
        path,
        queryParameters: queryParameters,
        options: Options(
          headers: headers,
          sendTimeout: _timeOut,
          receiveTimeout: _timeOut,
        ),
      );
      return response;
    } catch (error) {
      if (context.mounted) {
        _handleError(context, error);
      }
      rethrow;
    }
  }

  //post method supports additional headers & authrization
  Future<Response> post(
    BuildContext context,
    String path,
    dynamic data, {
    Map<String, dynamic>? additionalHeaders,
  }) async {
    Map<String, dynamic> headers = {};

    if (additionalHeaders != null) {
      headers.addAll(additionalHeaders);
    }
    try {
      final response = await _dio.post(
        path,
        data: data,
        options: Options(
          headers: headers,
          sendTimeout: _timeOut,
          receiveTimeout: _timeOut,
        ),
      );
      return response;
    } catch (error) {
      if (context.mounted) {
        _handleError(context, error);
      }
      rethrow;
    }
  }

  Future<void> _handleError(BuildContext context, dynamic error) async {
    if (error is DioException) {
      final dioError = error;
      if (dioError.response != null) {
        // Handle DioError with a response (e.g., server returned an error)
        if (dioError.response?.statusCode == 400) {
          CustomSnackbar.showSnackBar(
            context,
            dioError.response?.data["error"]["type"] ??
                "An unexpected error occurred.",
          );
        }
      } else {
        // CustomSnackbar.showSnackBar("An unexpected error occurred.");
        // Handle DioError without a response (e.g., network connectivity issue)
        CustomSnackbar.showSnackBar(context, "An unexpected error occurred.");
      }
    } else {
      // CustomSnackbar.showSnackBar("An unexpected error occurred.");
      // Handle generic errors (e.g., unexpected errors)
      CustomSnackbar.showSnackBar(context, "An unexpected error occurred.");
    }
  }
}
