import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../devtools_provider.dart';
import '../widgets/devtools_split_pane.dart';

class NetworkInspectorPanel extends ConsumerWidget {
  const NetworkInspectorPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(devtoolsProvider);
    final notifier = ref.read(devtoolsProvider.notifier);
    final entries = state.networkEvents;
    final selected = state.selectedNetworkEvent;
    if (entries.isEmpty) {
      return const _EmptyView(message: 'No network requests observed yet.');
    }

    final reversed = entries.reversed.toList();
    return DevtoolsSplitPane(
      list: ListView.separated(
        itemCount: reversed.length,
        separatorBuilder: (_, __) =>
            const Divider(height: 1, color: Color(0xFFE2E8F0)),
        itemBuilder: (context, index) {
          final event = reversed[index];
          final status = event.statusCode?.toString() ?? '--';
          final statusColor = event.isError
              ? const Color(0xFFDC2626)
              : const Color(0xFF16A34A);
          final duration =
              event.duration != null ? '${event.duration!.inMilliseconds} ms' : '---';
          final error = event.error?.message ?? '';
          return ListTile(
            dense: true,
            selected: selected == event,
            selectedTileColor: const Color(0xFFE2E8F0),
            title: Text(
              '${event.method} ${event.path}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Duration: $duration'),
                if (error.isNotEmpty)
                  Text(
                    error,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Color(0xFFDC2626)),
                  ),
              ],
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  status,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: statusColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _formatTimestamp(event.timestamp),
                  style: const TextStyle(fontSize: 12, color: Color(0xFF94A3B8)),
                ),
              ],
            ),
            onTap: () => notifier.selectNetworkEvent(event),
          );
        },
      ),
      detail: _NetworkDetailView(entry: selected),
    );
  }

  String _formatTimestamp(DateTime time) {
    final h = time.hour.toString().padLeft(2, '0');
    final m = time.minute.toString().padLeft(2, '0');
    final s = time.second.toString().padLeft(2, '0');
    return '$h:$m:$s';
  }
}

class _NetworkDetailView extends StatelessWidget {
  const _NetworkDetailView({required this.entry});

  final NetworkEvent? entry;

  @override
  Widget build(BuildContext context) {
    if (entry == null) {
      return const _EmptyDetail(message: '항목을 선택해주세요.');
    }

    final payload = {
      'method': entry!.method,
      'path': entry!.path,
      'statusCode': entry!.statusCode,
      'durationMs': entry!.duration?.inMilliseconds,
      'error': entry!.error?.toString(),
      'timestamp': entry!.timestamp.toIso8601String(),
    };

    return Padding(
      padding: const EdgeInsets.all(12),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${entry!.method} ${entry!.path}',
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(_formatTimestamp(entry!.timestamp)),
            const SizedBox(height: 12),
            SelectableText(_prettyPrint(payload)),
            if (entry!.error != null) ...[
              const SizedBox(height: 12),
              const Text('Error Detail',
                  style: TextStyle(fontWeight: FontWeight.w700)),
              SelectableText(entry!.error.toString()),
            ],
          ],
        ),
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
