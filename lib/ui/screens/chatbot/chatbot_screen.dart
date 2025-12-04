import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/entities/chat_message.dart';
import '../../../application/notifiers/chat_notifier.dart';
import '../../../application/providers.dart' show chatProvider;
import '../../../core/constants/app_strings.dart';
import '../../widgets/app_appbar.dart';
import '../../widgets/global_error_view.dart';

class ChatbotScreen extends ConsumerStatefulWidget {
  const ChatbotScreen({super.key});

  @override
  ConsumerState<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends ConsumerState<ChatbotScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<ChatState>(chatProvider, (previous, next) {
      if ((previous?.messages.length ?? 0) != next.messages.length) {
        _scrollToBottom();
      }
    });

    final chatState = ref.watch(chatProvider);
    final notifier = ref.read(chatProvider.notifier);
    final error = chatState.error;

    return Scaffold(
      appBar: AppAppBar(
        title: AppStrings.chatbotTitle,
        actions: [
          IconButton(
            onPressed: () async {
              final confirmed = await _confirmClear();
              if (confirmed == true) {
                notifier.clearHistory();
              }
            },
            icon: const Icon(Icons.delete_outline),
            tooltip: '대화 초기화',
          ),
        ],
      ),

      /// 🔥 핵심 수정 — SizedBox.expand 제거 (문제의 근본 원인)
      body: SafeArea(
        child: Column(
          children: [
            if (error != null)
              Expanded(
                child: GlobalErrorView(
                  message: error,
                  onRetry: notifier.clearError,
                ),
              )
            else
              Expanded(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.only(bottom: 12),
                    itemCount: chatState.messages.length,
                    itemBuilder: (context, index) {
                      final message = chatState.messages[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: _ChatBubble(message: message),
                      );
                    },
                  ),
                ),
              ),
            if (chatState.isSending)
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                child: LinearProgressIndicator(minHeight: 2),
              ),
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 14),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      maxLines: 3,
                      minLines: 1,
                      enabled: !chatState.isSending,
                      decoration: const InputDecoration(
                        hintText: '궁금한 정책, 지역, 상담 내용을 입력해 주세요',
                        border: OutlineInputBorder(),
                        isDense: true,
                      ),
                      onSubmitted: (_) => _send(notifier, chatState.isSending),
                    ),
                  ),
                  const SizedBox(width: 8),
                  SizedBox(
                    height: 48,
                    child: chatState.isSending
                        ? const Padding(
                            padding: EdgeInsets.all(12),
                            child: CircularProgressIndicator(strokeWidth: 2.2),
                          )
                        : FilledButton.icon(
                            onPressed: () =>
                                _send(notifier, chatState.isSending),
                            icon: const Icon(Icons.send),
                            label: const Text('보내기'),
                          ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _send(ChatNotifier notifier, bool isSending) {
    if (isSending) return;
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    notifier.sendMessage(text);
    _controller.clear();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    });
  }

  Future<bool?> _confirmClear() async {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('대화 기록을 지울까요?'),
          content: const Text('모든 메시지가 삭제되고 초기 안내 메시지만 남습니다.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('취소'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('삭제'),
            ),
          ],
        );
      },
    );
  }
}

class _ChatBubble extends StatelessWidget {
  const _ChatBubble({required this.message});

  final ChatMessage message;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isUser = message.sender == '나';
    final isSystem = message.sender == '시스템';
    final alignment = isSystem
        ? Alignment.center
        : isUser
            ? Alignment.centerRight
            : Alignment.centerLeft;
    final background = isSystem
        ? theme.colorScheme.surfaceVariant
        : isUser
            ? theme.colorScheme.primary
            : theme.colorScheme.surfaceContainerHighest;
    final textStyle = isUser
        ? theme.textTheme.bodyMedium?.copyWith(color: Colors.white)
        : theme.textTheme.bodyMedium;

    return Align(
      alignment: alignment,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.sizeOf(context).width * 0.78,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          message.text,
          style: isSystem
              ? theme.textTheme.bodySmall
                  ?.copyWith(color: theme.colorScheme.outline)
              : textStyle,
          softWrap: true,
        ),
      ),
    );
  }
}
