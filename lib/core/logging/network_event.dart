import 'package:dio/dio.dart';

/// Captures metadata about outbound HTTP calls so it can be forwarded to
/// Crashlytics or Sentry.
class NetworkLogEvent {
  NetworkLogEvent({
    required this.method,
    required this.uri,
    this.statusCode,
    this.duration,
    this.errorMessage,
    this.requestBody,
    this.responseBody,
    Map<String, dynamic>? extra,
    DateTime? timestamp,
  })  : timestamp = timestamp ?? DateTime.now(),
        extra = extra ?? const {};

  final String method;
  final Uri uri;
  final int? statusCode;
  final Duration? duration;
  final String? errorMessage;
  final Object? requestBody;
  final Object? responseBody;
  final Map<String, dynamic> extra;
  final DateTime timestamp;

  bool get isError =>
      errorMessage != null || (statusCode != null && statusCode! >= 400);

  factory NetworkLogEvent.fromResponse(Response response) {
    final startedAt = response.requestOptions.extra['startedAt'] as DateTime?;
    return NetworkLogEvent(
      method: response.requestOptions.method,
      uri: response.requestOptions.uri,
      statusCode: response.statusCode,
      duration: startedAt != null ? DateTime.now().difference(startedAt) : null,
      responseBody: response.data,
      extra: {
        'requestHeaders': Map<String, String>.fromEntries(
          response.requestOptions.headers.entries
              .where((entry) => entry.key.toLowerCase() != 'authorization')
              .map(
                (entry) => MapEntry(entry.key, entry.value.toString()),
              ),
        ),
        'query': response.requestOptions.queryParameters,
      },
    );
  }

  factory NetworkLogEvent.fromError(DioException error) {
    final startedAt = error.requestOptions.extra['startedAt'] as DateTime?;
    return NetworkLogEvent(
      method: error.requestOptions.method,
      uri: error.requestOptions.uri,
      statusCode: error.response?.statusCode,
      duration: startedAt != null ? DateTime.now().difference(startedAt) : null,
      errorMessage: error.message,
      responseBody: error.response?.data,
      extra: {
        'requestHeaders': Map<String, String>.fromEntries(
          error.requestOptions.headers.entries
              .where((entry) => entry.key.toLowerCase() != 'authorization')
              .map(
                (entry) => MapEntry(entry.key, entry.value.toString()),
              ),
        ),
        'query': error.requestOptions.queryParameters,
      },
    );
  }
}
