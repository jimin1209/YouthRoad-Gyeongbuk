import 'package:flutter/material.dart';

import '../../widgets/app_appbar.dart';

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final List<_Message> _messages = <_Message>[
    const _Message(sender: '시스템', text: '무엇을 도와드릴까요?'),
  ];
  final TextEditingController _controller = TextEditingController();

  void _send() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _messages.add(_Message(sender: '나', text: text));
      _messages.add(const _Message(sender: '봇', text: '준비 중입니다...'));
    });
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppAppBar(title: 'AI 챗봇'),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (_, i) {
                final m = _messages[i];
                final isUser = m.sender == '나';
                final align =
                    isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start;
                final color = isUser
                    ? Theme.of(context).colorScheme.primaryContainer
                    : Theme.of(context).colorScheme.surfaceContainerLow;
                return Column(
                  crossAxisAlignment: align,
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(m.text),
                    ),
                  ],
                );
              },
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration:
                          const InputDecoration(hintText: '메시지를 입력하세요'),
                      onSubmitted: (_) => _send(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  FilledButton.icon(
                    onPressed: _send,
                    icon: const Icon(Icons.send),
                    label: const Text('보내기'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Message {
  const _Message({required this.sender, required this.text});
  final String sender;
  final String text;
}
