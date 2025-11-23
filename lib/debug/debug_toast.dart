import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class DebugToastMessage {
  DebugToastMessage(this.message, this.timestamp);

  final String message;
  final DateTime timestamp;
}

class DebugToastController {
  DebugToastController._();

  static final DebugToastController instance = DebugToastController._();

  final ValueNotifier<List<DebugToastMessage>> _messages =
      ValueNotifier<List<DebugToastMessage>>(<DebugToastMessage>[]);

  final Map<String, DateTime> _lastShownAt = <String, DateTime>{};

  ValueListenable<List<DebugToastMessage>> get messages => _messages;

  void show(String message) {
    if (!kDebugMode) return;

    final now = DateTime.now();
    final last = _lastShownAt[message];
    if (last != null && now.difference(last) < const Duration(seconds: 2)) {
      return;
    }

    _lastShownAt[message] = now;
    final updated = List<DebugToastMessage>.from(_messages.value)
      ..add(DebugToastMessage(message, now));
    _messages.value = updated.takeLast(3);

    Future.delayed(const Duration(seconds: 3), () {
      final current = List<DebugToastMessage>.from(_messages.value);
      if (current.isNotEmpty && current.first.timestamp == now) {
        current.removeAt(0);
        _messages.value = current;
      }
    });
  }
}

extension _ListTrim<T> on List<T> {
  List<T> takeLast(int count) {
    if (length <= count) return List<T>.from(this);
    return sublist(length - count, length);
  }
}

class DebugToastOverlay extends StatelessWidget {
  const DebugToastOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: SafeArea(
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 28),
            child: ValueListenableBuilder<List<DebugToastMessage>>(
              valueListenable: DebugToastController.instance.messages,
              builder: (context, messages, _) {
                if (messages.isEmpty) return const SizedBox.shrink();
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: messages
                      .map((message) => _DebugToast(message: message))
                      .toList(),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _DebugToast extends StatelessWidget {
  const _DebugToast({required this.message});

  final DebugToastMessage message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 150),
        opacity: 1,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: const Color(0xFF4D8AF0),
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 6,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: Text(
              message.message,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
