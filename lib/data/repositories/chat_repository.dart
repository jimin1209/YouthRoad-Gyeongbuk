import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../core/constants/env.dart';

class ChatRepository {
  ChatRepository(this._dio);

  final Dio _dio;

  Future<String> sendMessage(String text) async {
    final endpoint = Env.chatEndpoint;
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

      debugPrint('AI response raw: ${response.data}');

      final data = response.data;

      // 1) Original format: {"reply": "..."}
      if (data is Map && data['reply'] is String) {
        return data['reply'] as String;
      }

      // 2) OpenAI / ChatCompletion-style format:
      // {
      //   "choices": [
      //     {
      //       "message": {
      //         "content": "..."
      //       }
      //     }
      //   ]
      // }
      if (data is Map &&
          data['choices'] is List &&
          (data['choices'] as List).isNotEmpty) {
        final firstChoice = (data['choices'] as List).first;
        if (firstChoice is Map &&
            firstChoice['message'] is Map &&
            firstChoice['message']['content'] is String) {
          return firstChoice['message']['content'] as String;
        }
      }

      // 3) Gateway-style: {"result": "..."}
      if (data is Map && data['result'] is String) {
        return data['result'] as String;
      }

      // 4) Plain string response
      if (data is String) {
        return data;
      }

      throw StateError('Invalid AI response format');
    } catch (e, st) {
      debugPrint('ChatRepository error: $e');
      debugPrint('$st');
      rethrow;
    }
  }
}
