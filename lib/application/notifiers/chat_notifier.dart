import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/repositories/chat_repository.dart';
import '../../domain/entities/chat_message.dart';
import '../di.dart';

class ChatState {
  const ChatState({
    required this.messages,
    this.isSending = false,
    this.error,
  });

  final List<ChatMessage> messages;
  final bool isSending;
  final String? error;
}

class ChatNotifier extends AutoDisposeNotifier<ChatState> {
  late final ChatRepository _repository;
  late final SharedPreferences _prefs;

  static const _storageKey = 'chat_history';

  @override
  ChatState build() {
    _repository = ref.read(chatRepositoryProvider);
    _prefs = ref.read(sharedPreferencesProvider);
    final saved = _prefs.getStringList(_storageKey) ?? [];
    final restored = saved
        .map((jsonStr) => ChatMessage.fromJson(
            json.decode(jsonStr) as Map<String, dynamic>))
        .toList();
    return ChatState(messages: restored.isEmpty ? _seedMessages() : restored);
  }

  List<ChatMessage> _seedMessages() => [
        ChatMessage(
          sender: '시스템',
          text: '무엇을 도와드릴까요? 정책, 지도, 상담 모두 물어보세요!',
          timestamp: DateTime.fromMillisecondsSinceEpoch(0),
        ),
      ];

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;
    final userMessage = ChatMessage(
      sender: '나',
      text: text.trim(),
      timestamp: DateTime.now(),
    );
    state = ChatState(messages: [...state.messages, userMessage], isSending: true);
    try {
      final reply = await _repository.sendMessage(text);
      final updated = [...state.messages, reply];
      state = ChatState(messages: updated, isSending: false);
      _saveMessages(updated);
    } catch (e) {
      final fallback = ChatMessage(
        sender: '봇',
        text: '잠시 후 다시 시도해주세요. 임시 답변: ${text.trim()}',
        timestamp: DateTime.now(),
      );
      final updated = [...state.messages, fallback];
      state = ChatState(messages: updated, isSending: false, error: '$e');
      _saveMessages(updated);
    }
  }

  void clearHistory() {
    final seed = _seedMessages();
    state = ChatState(messages: seed);
    _prefs.remove(_storageKey);
  }

  void _saveMessages(List<ChatMessage> messages) {
    final encoded = messages.map((m) => json.encode(m.toJson())).toList();
    _prefs.setStringList(_storageKey, encoded);
  }
}
