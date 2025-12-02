import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../core/constants/env.dart';

class DebugLogEntry {
  DebugLogEntry({required this.timestamp, required this.message});

  final DateTime timestamp;
  final String message;
}

class DebugLogCollector {
  DebugLogCollector._();

  static final DebugLogCollector instance = DebugLogCollector._();

  final ValueNotifier<List<DebugLogEntry>> _entries =
      ValueNotifier<List<DebugLogEntry>>(<DebugLogEntry>[]);

  ValueListenable<List<DebugLogEntry>> get entries => _entries;

  void add(String message) {
    if (!kDebugMode) return;
    final updated = List<DebugLogEntry>.from(_entries.value)
      ..add(DebugLogEntry(timestamp: DateTime.now(), message: message));
    if (updated.length > 500) {
      _entries.value = updated.sublist(updated.length - 500);
    } else {
      _entries.value = updated;
    }
  }
}

class DebugLogPanel extends StatelessWidget {
  const DebugLogPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final apiKeyLabel = _maskApiKey(Env.kakaoMapApiKey);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0x1AFFFFFF),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0x33FFFFFF)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Kakao Map API Key',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  apiKeyLabel,
                  style: const TextStyle(
                    color: Colors.white,
                    fontFamily: 'monospace',
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: ValueListenableBuilder<List<DebugLogEntry>>(
            valueListenable: DebugLogCollector.instance.entries,
            builder: (context, entries, _) {
              if (entries.isEmpty) {
                return const Center(
                  child: Text(
                    'No logs yet.',
                    style: TextStyle(color: Colors.white70),
                  ),
                );
              }

              final reversed = entries.reversed.toList();
              return ListView.separated(
                itemCount: reversed.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final log = reversed[index];
                  final preview = log.message.split('\n').first;
                  return ListTile(
                    title: Text(
                      preview,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Colors.white),
                    ),
                    subtitle: Text(
                      _formatTimestamp(log.timestamp),
                      style: const TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                    onTap: () => _showLogDetail(context, log),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  String _formatTimestamp(DateTime time) {
    final h = time.hour.toString().padLeft(2, '0');
    final m = time.minute.toString().padLeft(2, '0');
    final s = time.second.toString().padLeft(2, '0');
    return '$h:$m:$s';
  }

  void _showLogDetail(BuildContext context, DebugLogEntry log) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      builder: (context) {
        return SafeArea(
          child: DraggableScrollableSheet(
            expand: false,
            initialChildSize: 0.7,
            minChildSize: 0.4,
            maxChildSize: 0.95,
            builder: (context, scrollController) {
              return Scaffold(
                appBar: AppBar(
                  title: const Text('Log Detail'),
                ),
                body: SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        log.timestamp.toLocal().toString(),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      SelectableText(
                        log.message,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  String _maskApiKey(String key) {
    if (key.isEmpty) {
      return '<empty>'; 
    }
    if (key.length <= 6) {
      return '${key[0]}***${key[key.length - 1]}';
    }
    final prefix = key.substring(0, 3);
    final suffix = key.substring(key.length - 4);
    return '$prefix***$suffix (len:${key.length})';
  }
}
