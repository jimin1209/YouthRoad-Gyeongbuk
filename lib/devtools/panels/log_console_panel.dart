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
    final entries = ref.watch(devtoolsProvider.select((s) => s.logs));
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
                onChanged: (value) => setState(() => _filter = value),
              ),
            ],
          ),
        ),
        const Divider(height: 1),
        Expanded(
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
                onTap: () => _showDetail(context, log),
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

  void _showDetail(BuildContext context, DevLogEntry log) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Level: ${log.level.name.toUpperCase()}',
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 8),
                Text(log.timestamp.toString()),
                const SizedBox(height: 12),
                SelectableText(log.message),
              ],
            ),
          ),
        );
      },
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
