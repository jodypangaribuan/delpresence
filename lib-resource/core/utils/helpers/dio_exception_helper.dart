import 'package:dio/dio.dart';

class DioExceptionHelper {
  static String handleDioError(DioException dioException) {
    switch (dioException.type) {
      case DioExceptionType.connectionTimeout:
        return "Connection timeout. Please check your internet connection.";
      case DioExceptionType.sendTimeout:
        return "Sending request took too long. Check the internet.";
      case DioExceptionType.receiveTimeout:
        return "The server took too long to respond. Try again later.";
      case DioExceptionType.badResponse:
        return _handleBadResponse(dioException.response);
      case DioExceptionType.cancel:
        return "Request was cancelled. Try again.";
      case DioExceptionType.unknown:
        return dioException.message!.contains("SocketException")
            ? "It seems you are not connected to the internet. Check the connection."
            : "An unexpected error occurred. Try again.";
      default:
        return "An unexpected error occurred. Try again.";
    }
  }

  static String _handleBadResponse(Response? response) {
    if (response != null) {
      switch (response.statusCode) {
        case 400:
          return "Invalid request. Check the input.";
        case 401:
          return "Unauthorized. Check credentials.";
        case 403:
          return "Access denied.";
        case 404:
          return "Resource not found.";
        case 500:
          return "Server error. Try again later.";
        case 503:
          return "Service unavailable. Try again later.";
        default:
          return "Unexpected error: ${response.statusCode}. Try again.";
      }
    }
    return "An unexpected error occurred from the server. Try again later.";
  }
}
