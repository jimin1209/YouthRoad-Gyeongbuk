import 'dart:convert';

import 'package:flutter/foundation.dart';
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
  ChatRepository get _repository => ref.read(chatRepositoryProvider);

  static const _storageKey = 'chat_history';
  static const _thinkingMessage = '답변을 준비하고 있어요...';

  SharedPreferences? get _maybePrefs {
    try {
      return ref.read(sharedPreferencesProvider);
    } catch (e, st) {
      debugPrint('SharedPreferences 접근에 실패했습니다: $e');
      debugPrint('$st');
      return null;
    }
  }

  @override
  ChatState build() {
    final restored = _loadMessages();
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
    final thinkingMessage = ChatMessage(
      sender: '봇',
      text: _thinkingMessage,
      timestamp: DateTime.now(),
    );

    _updateState(
      [...messagesWithUser, thinkingMessage],
      isSending: true,
      error: null,
    );
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
    _safeClearStorage();
  }

  List<ChatMessage> _loadMessages() {
    try {
      final prefs = _maybePrefs;
      if (prefs == null) return [];

      final saved = prefs.getStringList(_storageKey) ?? [];
      return _restoreMessages(saved);
    } catch (e, st) {
      debugPrint('채팅 기록을 불러오지 못했습니다: $e');
      debugPrint('$st');
      return [];
    }
  }

  List<ChatMessage> _restoreMessages(List<String> saved) {
    try {
      return saved
          .map((jsonStr) => ChatMessage.fromJson(
              json.decode(jsonStr) as Map<String, dynamic>))
          .toList();
    } catch (e, st) {
      debugPrint('채팅 기록 복원에 실패했습니다: $e');
      debugPrint('$st');
      _safeClearStorage();
      return [];
    }
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
    try {
      final prefs = _maybePrefs;
      if (prefs == null) return;

      final encoded = messages
          .where((m) => m.text != _thinkingMessage)
          .map((m) => json.encode(m.toJson()))
          .toList();
      prefs.setStringList(_storageKey, encoded);
    } catch (e, st) {
      debugPrint('채팅 기록 저장 실패: $e');
      debugPrint('$st');
    }
  }

  void _safeClearStorage() {
    try {
      final prefs = _maybePrefs;
      if (prefs == null) return;

      prefs.remove(_storageKey);
    } catch (e, st) {
      debugPrint('채팅 기록 초기화 실패: $e');
      debugPrint('$st');
    }
  }
}
