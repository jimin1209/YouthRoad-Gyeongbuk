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
    if (state.isSending) return;
    final trimmed = text.trim();
    if (trimmed.isEmpty) return;
    final userMessage = ChatMessage(
      sender: '나',
      text: trimmed,
      timestamp: DateTime.now(),
    );
    final messagesWithUser = [...state.messages, userMessage];
    _updateState(messagesWithUser, isSending: true, error: null);
    try {
      final reply = await _repository.sendMessage(trimmed);
      final updated = [
        ...messagesWithUser,
        ChatMessage(
          sender: '봇',
          text: reply,
          timestamp: DateTime.now(),
        ),
      ];
      _updateState(updated);
    } catch (e) {
      _updateState(
        messagesWithUser,
        error: '상담을 불러오지 못했습니다. 다시 시도해 주세요.',
      );
    }
  }

  void clearError() {
    state = ChatState(
      messages: state.messages,
      isSending: state.isSending,
      error: null,
    );
  }

  void clearHistory() {
    final seed = _seedMessages();
    state = ChatState(messages: seed);
    _prefs.remove(_storageKey);
  }

  void _updateState(
    List<ChatMessage> messages, {
    bool isSending = false,
    String? error,
  }) {
    state = ChatState(messages: messages, isSending: isSending, error: error);
    _saveMessages(messages);
  }

  void _saveMessages(List<ChatMessage> messages) {
    final encoded = messages.map((m) => json.encode(m.toJson())).toList();
    _prefs.setStringList(_storageKey, encoded);
  }
}
