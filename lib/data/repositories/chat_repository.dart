import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class ChatRepository {
  ChatRepository(this._dio);

  final Dio _dio;

  Future<String> sendMessage(String text) async {
    final endpoint =
        const String.fromEnvironment('CHAT_ENDPOINT', defaultValue: '');
    if (endpoint.isEmpty) {
      throw StateError('CHAT_ENDPOINT is not provided');
    }

    try {
      final response = await _dio.post(
        endpoint,
        data: {
          'messages': [
            {'role': 'user', 'content': text},
          ],
          'metadata': {
            'source': 'YouthRoad-App',
            'version': 'v1',
          }
        },
      );

      final data = response.data;
      if (data is Map && data['reply'] is String) {
        return data['reply'] as String;
      }

      throw StateError('Invalid AI response format');
    } catch (e, st) {
      debugPrint('ChatRepository error: $e');
      debugPrint('$st');
      rethrow;
    }
  }
}
