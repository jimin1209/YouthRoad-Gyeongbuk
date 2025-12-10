import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../core/constants/env.dart';
import '../core/logging/app_log_level.dart';

class DebugLogEntry {
  DebugLogEntry({
    required this.timestamp,
    required this.message,
    this.level = AppLogLevel.debug,
    this.tag,
  });

  final DateTime timestamp;
  final String message;
  final AppLogLevel level;
  final String? tag;
}

class DebugLogCollector {
  DebugLogCollector._();

  static final DebugLogCollector instance = DebugLogCollector._();

  static const _maxEntries = 1000;
  static const _maxErrorEntries = 200;

  final ListQueue<DebugLogEntry> _entriesQueue = ListQueue<DebugLogEntry>();
  final ListQueue<DebugLogEntry> _errorEntriesQueue = ListQueue<DebugLogEntry>();
  final ValueNotifier<List<DebugLogEntry>> _entries =
      ValueNotifier<List<DebugLogEntry>>(<DebugLogEntry>[]);
  final ValueNotifier<List<DebugLogEntry>> _errorEntries =
      ValueNotifier<List<DebugLogEntry>>(<DebugLogEntry>[]);
  final ValueNotifier<int> _errorCount = ValueNotifier<int>(0);

  ValueListenable<List<DebugLogEntry>> get entries => _entries;
  ValueListenable<List<DebugLogEntry>> get errorEntries => _errorEntries;
  ValueListenable<int> get errorCount => _errorCount;

  void add(
    String message, {
    AppLogLevel level = AppLogLevel.debug,
    String? tag,
    DateTime? timestamp,
  }) {
    if (!kDebugMode) return;
    final entry = DebugLogEntry(
      timestamp: timestamp ?? DateTime.now(),
      message: message,
      level: level,
      tag: tag,
    );

    _entriesQueue.add(entry);
    while (_entriesQueue.length > _maxEntries) {
      _entriesQueue.removeFirst();
    }
    _entries.value = List<DebugLogEntry>.unmodifiable(_entriesQueue);

    if (_isErrorEntry(entry)) {
      _errorCount.value = _errorCount.value + 1;
      _errorEntriesQueue.add(entry);
      while (_errorEntriesQueue.length > _maxErrorEntries) {
        _errorEntriesQueue.removeFirst();
      }
      _errorEntries.value = List<DebugLogEntry>.unmodifiable(_errorEntriesQueue);
    }
  }

  bool _isErrorEntry(DebugLogEntry entry) {
    if (entry.level == AppLogLevel.error) return true;

    final lower = entry.message.toLowerCase();
    return lower.contains('error') ||
        lower.contains('[app][error]') ||
        lower.contains('exception') ||
        lower.contains('unhandled') ||
        lower.contains('fatal') ||
        lower.contains('unexpected');
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

              final reversedEntries =
                  entries.reversed.toList(growable: false);

              return ListView.separated(
                itemCount: reversedEntries.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final log = reversedEntries[index];
                  final preview = log.message.split('\n').first;
                  return ListTile(
                    title: Text(
                      preview,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Colors.white),
                    ),
                    subtitle: Text(
                      _formatLogTimestamp(log.timestamp),
                      style:
                          const TextStyle(color: Colors.white70, fontSize: 12),
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

class DebugErrorLogPanel extends StatelessWidget {
  const DebugErrorLogPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: DebugLogCollector.instance.errorCount,
      builder: (context, errorCount, _) {
        return ValueListenableBuilder<List<DebugLogEntry>>(
          valueListenable: DebugLogCollector.instance.errorEntries,
          builder: (context, entries, __) {
            if (entries.isEmpty) {
              return const Center(
                child: Text(
                  '현재 수집된 에러 로그가 없습니다.',
                  style: TextStyle(color: Colors.white70),
                ),
              );
            }

            final reversedEntries =
                entries.reversed.toList(growable: false);

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.error_outline,
                        color: Colors.redAccent,
                        size: 18,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '총 에러 로그 $errorCount개 / 표시 ${entries.length}개',
                        style: const TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),
                Expanded(
                  child: ListView.builder(
                    itemCount: reversedEntries.length,
                    itemBuilder: (context, index) {
                      final entry = reversedEntries[index];
                      final preview = entry.message.split('\n').first;
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        child: Material(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                          clipBehavior: Clip.antiAlias,
                          child: InkWell(
                            onTap: () => _showLogDetail(context, entry),
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.05),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: const Color(0x33FF6B6B)),
                              ),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                child: Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 7,
                                        vertical: 3,
                                      ),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFFF6B6B),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        entry.tag ?? '[ERROR]',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 11,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            _formatLogTimestamp(entry.timestamp),
                                            style: const TextStyle(
                                              color: Colors.white70,
                                              fontSize: 10,
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            preview,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontFamily: 'monospace',
                                              fontSize: 11.5,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

String _formatLogTimestamp(DateTime time) {
  final h = time.hour.toString().padLeft(2, '0');
  final m = time.minute.toString().padLeft(2, '0');
  final s = time.second.toString().padLeft(2, '0');
  return '$h:$m:$s';
}

void _showLogDetail(BuildContext context, DebugLogEntry log) {
  Navigator.of(context, rootNavigator: true).push(
    MaterialPageRoute<void>(
      fullscreenDialog: true,
      builder: (context) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('로그 상세'),
          ),
          body: SafeArea(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Row(
                  children: [
                    Chip(
                      label: Text(log.level.name.toUpperCase()),
                      backgroundColor: Colors.blue.shade100,
                    ),
                    const SizedBox(width: 8),
                    Chip(
                      label: Text(log.tag ?? 'NO TAG'),
                      backgroundColor: Colors.grey.shade200,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  log.timestamp.toLocal().toString(),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                const Text(
                  '메시지',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 4),
                SelectableText(
                  log.message,
                  style: const TextStyle(fontSize: 14, fontFamily: 'monospace'),
                ),
              ],
            ),
          ),
        );
      },
    ),
  );
}

String _formatLogTimestamp(DateTime time) {
  final h = time.hour.toString().padLeft(2, '0');
  final m = time.minute.toString().padLeft(2, '0');
  final s = time.second.toString().padLeft(2, '0');
  return '$h:$m:$s';
}
