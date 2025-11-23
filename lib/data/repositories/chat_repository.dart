import 'package:dio/dio.dart';

import '../../core/constants/env.dart';
import '../../domain/entities/chat_message.dart';

class ChatRepository {
  ChatRepository(this._dio);

  final Dio _dio;

  Future<ChatMessage> sendMessage(String prompt) async {
    try {
      final response = await _dio.get(Env.chatEndpoint);
      final title = response.data['title']?.toString() ?? '응답 준비됨';
      final body = response.data['body']?.toString() ?? '';
      return ChatMessage(
        sender: '봇',
        text: body.isNotEmpty ? '$title\n$body' : title,
        timestamp: DateTime.now(),
      );
    } catch (_) {
      return ChatMessage(
        sender: '봇',
        text: '네트워크가 원활하지 않아도 걱정 마세요! 임시 답변입니다: "$prompt"와 관련해 더 도와드릴까요?',
        timestamp: DateTime.now(),
      );
    }
  }
}
