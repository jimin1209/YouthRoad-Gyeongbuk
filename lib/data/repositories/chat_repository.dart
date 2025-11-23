import 'package:dio/dio.dart';

import '../../core/constants/env.dart';
import '../../domain/entities/chat_message.dart';

class ChatRepository {
  ChatRepository(this._dio);

  final Dio _dio;

  static const _apiKey = String.fromEnvironment(
    'OPENAI_API_KEY',
    defaultValue: '',
  );

  static const _fallbackText = '죄송합니다. 답변을 불러올 수 없습니다.';

  ChatMessage _fallbackMessage([String? text]) {
    return ChatMessage(
      sender: '봇',
      text: text ?? _fallbackText,
      timestamp: DateTime.now(),
    );
  }

  Future<ChatMessage> sendMessage(String prompt) async {
    // CHAT_ENDPOINT and OPENAI_API_KEY must be provided via --dart-define
    // to reach the OpenAI Chat Completions endpoint.
    if (Env.chatEndpoint.isEmpty || _apiKey.isEmpty) {
      return _fallbackMessage();
    }

    try {
      final response = await _dio.post(
        Env.chatEndpoint,
        data: {
          'model': 'gpt-4o-mini',
          'messages': [
            {'role': 'user', 'content': prompt},
          ],
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $_apiKey',
            'Content-Type': 'application/json',
          },
          sendTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 30),
        ),
      );

      final data = response.data;
      final choices = data is Map<String, dynamic>
          ? data['choices'] as List<dynamic>?
          : null;

      Map<String, dynamic>? firstChoice;
      if (choices != null &&
          choices.isNotEmpty &&
          choices.first is Map<String, dynamic>) {
        firstChoice = choices.first as Map<String, dynamic>;
      }

      final message = firstChoice?['message'];
      final messageContent = message is Map<String, dynamic>
          ? message['content']?.toString()
          : null;

      final text = (messageContent == null || messageContent.isEmpty)
          ? _fallbackText
          : messageContent;

      return _fallbackMessage(text);
    } on DioException {
      return _fallbackMessage();
    } catch (_) {
      return _fallbackMessage();
    }
  }
}
