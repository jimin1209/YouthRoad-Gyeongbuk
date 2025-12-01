import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../devtools_provider.dart';

class AppProviderObserver extends ProviderObserver {
  String _resolveProviderName(ProviderBase<Object?> provider) {
    if (provider.name != null && provider.name!.isNotEmpty) {
      return provider.name!;
    }
    return provider.runtimeType.toString();
  }

  @override
  void didUpdateProvider(
    ProviderBase<Object?> provider,
    Object? previousValue,
    Object? newValue,
    ProviderContainer container,
  ) {
    if (kReleaseMode) return;
    DevtoolsBinding.instance.addProviderEvent(
      ProviderEventEntry(
        providerName: _resolveProviderName(provider),
        state: _describeState(newValue),
      ),
    );
  }

  @override
  void providerDidFail(
    ProviderBase<Object?> provider,
    Object error,
    StackTrace stackTrace,
    ProviderContainer container,
  ) {
    if (kReleaseMode) return;
    DevtoolsBinding.instance.addProviderEvent(
      ProviderEventEntry(
        providerName: _resolveProviderName(provider),
        state: 'error',
        error: error,
        stackTrace: stackTrace,
      ),
    );
  }

  String _describeState(Object? value) {
    if (value is AsyncValue) {
      if (value.isLoading) return 'loading';
      if (value.hasError) return 'error';
      return 'data';
    }
    return 'data';
  }
}

class ProviderTrackerPanel extends ConsumerWidget {
  const ProviderTrackerPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entries = ref.watch(devtoolsProvider.select((s) => s.providerEvents));
    if (entries.isEmpty) {
      return const _EmptyView(message: 'No provider events captured yet.');
    }

    final reversed = entries.reversed.toList();
    return ListView.separated(
      itemCount: reversed.length,
      separatorBuilder: (_, __) => const Divider(height: 1, color: Color(0xFFE2E8F0)),
      itemBuilder: (context, index) {
        final entry = reversed[index];
        final isError = entry.error != null || entry.state == 'error';
        final subtitle = entry.error != null
            ? 'STATE: ${entry.state.toUpperCase()} • ${entry.error}'
            : 'STATE: ${entry.state.toUpperCase()}';
        return ListTile(
          dense: true,
          title: Text(
            entry.providerName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: isError ? const Color(0xFFDC2626) : const Color(0xFF0F172A),
              fontWeight: isError ? FontWeight.w700 : FontWeight.w600,
            ),
          ),
          subtitle: Text(
            subtitle,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: Text(
            _formatTimestamp(entry.timestamp),
            style: const TextStyle(fontSize: 12, color: Color(0xFF94A3B8)),
          ),
          onTap: () => _showDetail(context, entry),
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

  void _showDetail(BuildContext context, ProviderEventEntry entry) {
    final buffer = StringBuffer('State: ${entry.state.toUpperCase()}');
    if (entry.error != null) {
      buffer.writeln('\nError: ${entry.error}');
    }
    if (entry.stackTrace != null) {
      buffer.writeln('\nStackTrace:\n${entry.stackTrace}');
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    entry.providerName,
                    style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
                  ),
                  const SizedBox(height: 8),
                  Text(_formatTimestamp(entry.timestamp)),
                  const SizedBox(height: 12),
                  SelectableText(buffer.toString()),
                ],
              ),
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
