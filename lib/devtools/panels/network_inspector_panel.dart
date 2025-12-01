import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../devtools_provider.dart';

class NetworkInspectorPanel extends ConsumerWidget {
  const NetworkInspectorPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entries = ref.watch(devtoolsProvider.select((s) => s.networkEvents));
    if (entries.isEmpty) {
      return const _EmptyView(message: 'No network requests observed yet.');
    }

    final reversed = entries.reversed.toList();
    return ListView.separated(
      itemCount: reversed.length,
      separatorBuilder: (_, __) => const Divider(height: 1, color: Color(0xFFE2E8F0)),
      itemBuilder: (context, index) {
        final event = reversed[index];
        final status = event.statusCode?.toString() ?? '--';
        final statusColor = event.isError
            ? const Color(0xFFDC2626)
            : const Color(0xFF16A34A);
        final duration = event.duration != null
            ? '${event.duration!.inMilliseconds} ms'
            : '---';
        final error = event.error?.message ?? '';
        return ListTile(
          dense: true,
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
          onTap: () => _showDetail(context, event),
        );
      },
    );
  }

  String _formatTimestamp(DateTime time) {
    final h = time.hour.toString().padLeft(2, '0');
    final m = time.minute.toString().padLeft(2, '0');
    final s = time.second.toString().padLeft(2, '0');
    return '$h:$m:$s';
  }

  void _showDetail(BuildContext context, NetworkEvent event) {
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
                  '${event.method} ${event.path}',
                  style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                ),
                const SizedBox(height: 8),
                Text('Status: ${event.statusCode ?? '-'}'),
                const SizedBox(height: 8),
                Text('Duration: ${event.duration?.inMilliseconds ?? 0} ms'),
                if (event.error != null) ...[
                  const SizedBox(height: 12),
                  const Text('Error', style: TextStyle(fontWeight: FontWeight.w700)),
                  Text(event.error!.message ?? ''),
                ],
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
