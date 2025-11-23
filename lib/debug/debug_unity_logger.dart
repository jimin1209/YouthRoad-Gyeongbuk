import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class UnityLogEntry {
  UnityLogEntry({required this.message, DateTime? timestamp})
      : timestamp = timestamp ?? DateTime.now();

  final String message;
  final DateTime timestamp;
}

class DebugUnityLogger {
  DebugUnityLogger._();

  static final DebugUnityLogger instance = DebugUnityLogger._();

  final ValueNotifier<List<UnityLogEntry>> _entries =
      ValueNotifier<List<UnityLogEntry>>(<UnityLogEntry>[]);

  ValueListenable<List<UnityLogEntry>> get entries => _entries;

  void log(String message) {
    if (!kDebugMode) return;
    final updated = List<UnityLogEntry>.from(_entries.value)
      ..add(UnityLogEntry(message: message));
    _entries.value = updated.takeLast(200);
  }
}

extension _ListClip<T> on List<T> {
  List<T> takeLast(int count) {
    if (length <= count) return List<T>.from(this);
    return sublist(length - count, length);
  }
}

class DebugUnityPanel extends StatelessWidget {
  const DebugUnityPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<UnityLogEntry>>(
      valueListenable: DebugUnityLogger.instance.entries,
      builder: (context, entries, _) {
        if (entries.isEmpty) {
          return const Center(
            child: Text(
              'No Unity events yet.',
              style: TextStyle(color: Colors.white70),
            ),
          );
        }
        final reversed = entries.reversed.toList();
        return ListView.builder(
          itemCount: reversed.length,
          itemBuilder: (context, index) {
            final entry = reversed[index];
            return _UnityRow(entry: entry);
          },
        );
      },
    );
  }
}

class _UnityRow extends StatelessWidget {
  const _UnityRow({required this.entry});

  final UnityLogEntry entry;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFA8C5FF),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  '[UNITY]',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  entry.message,
                  style: const TextStyle(
                    color: Colors.white,
                    fontFamily: 'monospace',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
