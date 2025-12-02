import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/logging/app_log_level.dart';
import '../devtools_provider.dart';

class LogConsolePanel extends ConsumerStatefulWidget {
  const LogConsolePanel({super.key});

  @override
  ConsumerState<LogConsolePanel> createState() => _LogConsolePanelState();
}

class _LogConsolePanelState extends ConsumerState<LogConsolePanel> {
  AppLogLevel? _filter;

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(devtoolsProvider);
    final notifier = ref.read(devtoolsProvider.notifier);
    final entries = state.logs;
    final selected = state.selectedLog;
    final filtered = _filter == null
        ? entries
        : entries.where((e) => e.level == _filter).toList();

    if (filtered.isEmpty) {
      return const _EmptyView(message: 'No logs collected yet.');
    }

    final reversed = filtered.reversed.toList();
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            children: [
              const Text(
                'Filter:',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(width: 8),
              DropdownButton<AppLogLevel?>(
                value: _filter,
                items: const [
                  DropdownMenuItem(value: null, child: Text('All')),
                  DropdownMenuItem(value: AppLogLevel.info, child: Text('Info')),
                  DropdownMenuItem(value: AppLogLevel.warning, child: Text('Warn')),
                  DropdownMenuItem(value: AppLogLevel.error, child: Text('Error')),
                ],
                onChanged: (value) {
                  setState(() => _filter = value);
                  if (value != null && selected != null && selected.level != value) {
                    notifier.selectLog(null);
                  }
                },
              ),
            ],
          ),
        ),
        const Divider(height: 1),
        Expanded(
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: ListView.separated(
                  itemCount: reversed.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final log = reversed[index];
                    final color = switch (log.level) {
                      AppLogLevel.info => const Color(0xFF0F172A),
                      AppLogLevel.warning => const Color(0xFFF59E0B),
                      AppLogLevel.error => const Color(0xFFDC2626),
                    };
                    return ListTile(
                      dense: true,
                      selected: selected == log,
                      selectedTileColor: const Color(0xFFE2E8F0),
                      title: Text(
                        log.message,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: color),
                      ),
                      trailing: Text(
                        _formatTimestamp(log.timestamp),
                        style: const TextStyle(fontSize: 12, color: Color(0xFF94A3B8)),
                      ),
                      onTap: () => notifier.selectLog(log),
                    );
                  },
                ),
              ),
              const VerticalDivider(width: 1, color: Color(0xFFE2E8F0)),
              Expanded(
                flex: 3,
                child: _LogDetailView(
                  entry: selected,
                ),
              ),
            ],
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
}

class _LogDetailView extends StatelessWidget {
  const _LogDetailView({required this.entry});

  final DevLogEntry? entry;

  @override
  Widget build(BuildContext context) {
    if (entry == null) {
      return const _EmptyDetail(message: '항목을 선택해주세요.');
    }

    final payload = {
      'level': entry!.level.name,
      'message': entry!.message,
      'timestamp': entry!.timestamp.toIso8601String(),
    };

    return _DetailContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Level: ${entry!.level.name.toUpperCase()}',
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
          ),
          const SizedBox(height: 8),
          Text(_formatTimestamp(entry!.timestamp)),
          const SizedBox(height: 12),
          SelectableText(_prettyPrint(payload)),
        ],
      ),
    );
  }

  String _prettyPrint(Map<String, dynamic> data) {
    try {
      return const JsonEncoder.withIndent('  ').convert(data);
    } catch (_) {
      return data.toString();
    }
  }

  String _formatTimestamp(DateTime time) {
    final h = time.hour.toString().padLeft(2, '0');
    final m = time.minute.toString().padLeft(2, '0');
    final s = time.second.toString().padLeft(2, '0');
    return '$h:$m:$s';
  }
}

class _DetailContainer extends StatelessWidget {
  const _DetailContainer({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: SingleChildScrollView(
        child: child,
      ),
    );
  }
}

class _EmptyDetail extends StatelessWidget {
  const _EmptyDetail({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        message,
        style: const TextStyle(color: Color(0xFF94A3B8)),
      ),
    );
  }
}

class _EmptyView extends StatelessWidget {
  const _EmptyView({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        message,
        style: const TextStyle(color: Color(0xFF94A3B8)),
      ),
    );
  }
}
