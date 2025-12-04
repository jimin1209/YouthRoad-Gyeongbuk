import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../devtools_provider.dart';
import '../widgets/devtools_split_pane.dart';

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
    final state = ref.watch(devtoolsProvider);
    final notifier = ref.read(devtoolsProvider.notifier);
    final entries = state.providerEvents;
    final selected = state.selectedProviderEvent;
    if (entries.isEmpty) {
      return const _EmptyView(message: 'No provider events captured yet.');
    }

    final reversed = entries.reversed.toList();
    return DevtoolsSplitPane(
      list: ListView.separated(
        itemCount: reversed.length,
        separatorBuilder: (_, __) =>
            const Divider(height: 1, color: Color(0xFFE2E8F0)),
        itemBuilder: (context, index) {
          final entry = reversed[index];
          final isError = entry.error != null || entry.state == 'error';
          final subtitle = entry.error != null
              ? 'STATE: ${entry.state.toUpperCase()} • ${entry.error}'
              : 'STATE: ${entry.state.toUpperCase()}';
          return ListTile(
            dense: true,
            selected: selected == entry,
            selectedTileColor: const Color(0xFFE2E8F0),
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
            onTap: () => notifier.selectProviderEvent(entry),
          );
        },
      ),
      detail: _ProviderDetailView(entry: selected),
    );
  }

  String _formatTimestamp(DateTime time) {
    final h = time.hour.toString().padLeft(2, '0');
    final m = time.minute.toString().padLeft(2, '0');
    final s = time.second.toString().padLeft(2, '0');
    return '$h:$m:$s';
  }
}

class _ProviderDetailView extends StatelessWidget {
  const _ProviderDetailView({required this.entry});

  final ProviderEventEntry? entry;

  @override
  Widget build(BuildContext context) {
    if (entry == null) {
      return const _EmptyDetail(message: '항목을 선택해주세요.');
    }

    final payload = {
      'provider': entry!.providerName,
      'state': entry!.state,
      'error': entry!.error?.toString(),
      'stackTrace': entry!.stackTrace?.toString(),
      'timestamp': entry!.timestamp.toIso8601String(),
    };

    return Padding(
      padding: const EdgeInsets.all(12),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              entry!.providerName,
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text(_formatTimestamp(entry!.timestamp)),
            const SizedBox(height: 12),
            SelectableText(_prettyPrint(payload)),
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
