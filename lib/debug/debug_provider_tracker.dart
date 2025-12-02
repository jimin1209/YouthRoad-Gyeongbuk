import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'debug_toast.dart';

class ProviderStatusEntry {
  ProviderStatusEntry({
    required this.providerName,
    required this.state,
    this.error,
    this.stackTrace,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  final String providerName;
  final String state;
  final Object? error;
  final StackTrace? stackTrace;
  final DateTime timestamp;

  bool get isError => error != null || state.toLowerCase() == 'error';
}

class DebugProviderTracker {
  DebugProviderTracker._();

  static final DebugProviderTracker instance = DebugProviderTracker._();

  final ValueNotifier<List<ProviderStatusEntry>> _entries =
      ValueNotifier<List<ProviderStatusEntry>>(<ProviderStatusEntry>[]);

  ValueListenable<List<ProviderStatusEntry>> get entries => _entries;

  void addEntry(ProviderStatusEntry entry) {
    if (!kDebugMode) return;
    final updated = List<ProviderStatusEntry>.from(_entries.value)..add(entry);
    if (updated.length > 100) {
      _entries.value = updated.sublist(updated.length - 100);
    } else {
      _entries.value = updated;
    }
  }
}

class DebugProviderObserver extends ProviderObserver {
  String _resolveProviderName(ProviderBase<Object?> provider) {
    if (provider.name != null && provider.name!.isNotEmpty) {
      return provider.name!;
    }
    return provider.runtimeType.toString();
  }

  String _describeState(Object? value) {
    if (value is AsyncValue) {
      if (value.isLoading) return 'loading';
      if (value.hasError) return 'error';
      return 'data';
    }
    if (value == null) {
      return 'null';
    }
    return value.runtimeType.toString();
  }

  void _recordEntry(
    ProviderBase<Object?> provider, {
    required String state,
    Object? error,
    StackTrace? stackTrace,
  }) {
    if (!kDebugMode) return;
    try {
      final name = _resolveProviderName(provider);
      DebugProviderTracker.instance.addEntry(
        ProviderStatusEntry(
          providerName: name,
          state: state,
          error: error,
          stackTrace: stackTrace,
        ),
      );
    } catch (observerError, observerStackTrace) {
      debugPrint(
        'DebugProviderObserver error while recording provider (${provider.name ?? provider.runtimeType}): '
        '$observerError\n$observerStackTrace',
      );
    }
  }

  @override
  void didAddProvider(
    ProviderBase<Object?> provider,
    Object? value,
    ProviderContainer container,
  ) {
    _recordEntry(provider, state: 'added (${_describeState(value)})');
  }

  @override
  void didUpdateProvider(
    ProviderBase<Object?> provider,
    Object? previousValue,
    Object? newValue,
    ProviderContainer container,
  ) {
    _recordEntry(provider, state: _describeState(newValue));
  }

  @override
  void providerDidFail(
    ProviderBase<Object?> provider,
    Object error,
    StackTrace stackTrace,
    ProviderContainer container,
  ) {
    _recordEntry(
      provider,
      state: 'error',
      error: error,
      stackTrace: stackTrace,
    );
    DebugToastController.instance
        .show('Provider "${_resolveProviderName(provider)}" error: ${error.toString()}');
  }

  @override
  void didDisposeProvider(ProviderBase<Object?> provider, ProviderContainer container) {
    _recordEntry(provider, state: 'disposed');
  }
}

class DebugProviderPanel extends StatelessWidget {
  const DebugProviderPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<ProviderStatusEntry>>(
      valueListenable: DebugProviderTracker.instance.entries,
      builder: (context, entries, _) {
        if (entries.isEmpty) {
          return const Center(
            child: Text(
              'No provider activity yet.',
              style: TextStyle(color: Colors.white70),
            ),
          );
        }

        final reversed = entries.reversed.toList();
        return ListView.separated(
          itemCount: reversed.length,
          separatorBuilder: (_, __) => const Divider(height: 1, color: Colors.white24),
          itemBuilder: (context, index) {
            final entry = reversed[index];
            final preview = entry.error?.toString().split('\n').first ?? '';

            return Material(
              color: Colors.transparent,
              child: ListTile(
                dense: true,
                title: Text(
                  entry.providerName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: entry.isError
                        ? const Color(0xFFFF4D6D)
                        : const Color(0xFF4A5568),
                    fontWeight: entry.isError ? FontWeight.w700 : FontWeight.w600,
                  ),
                ),
                subtitle: Text(
                  entry.isError
                      ? 'STATE: ${entry.state.toUpperCase()} • $preview'
                      : 'STATE: ${entry.state.toUpperCase()}',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.white70),
                ),
                trailing: const Icon(Icons.chevron_right, color: Colors.white70),
                onTap: () => _showProviderDetail(context, entry),
              ),
            );
          },
        );
      },
    );
  }

  void _showProviderDetail(BuildContext context, ProviderStatusEntry entry) {
    final stateLabel = entry.state.toUpperCase();
    final buffer = StringBuffer('State: $stateLabel');
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
          child: Scaffold(
            appBar: AppBar(
              title: Text(entry.providerName),
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Updated: ${entry.timestamp.toLocal()}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'State: $stateLabel',
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 12),
                  SelectableText(
                    buffer.toString(),
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
