import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'debug_toast.dart';

class ProviderStatusEntry {
  ProviderStatusEntry({
    required this.providerName,
    required this.state,
    this.error,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  final String providerName;
  final String state;
  final Object? error;
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
    _entries.value = updated.takeLast(100);
  }
}

class DebugProviderObserver extends ProviderObserver {
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
    if (!kDebugMode) return;

    final name = _resolveProviderName(provider);
    final state = _describeState(newValue);
    DebugProviderTracker.instance.addEntry(
      ProviderStatusEntry(providerName: name, state: state),
    );
  }

  @override
  void providerDidFail(
    ProviderBase<Object?> provider,
    Object error,
    StackTrace stackTrace,
    ProviderContainer container,
  ) {
    if (!kDebugMode) return;

    final name = _resolveProviderName(provider);
    DebugProviderTracker.instance.addEntry(
      ProviderStatusEntry(providerName: name, state: 'error', error: error),
    );
    DebugToastController.instance
        .show('Provider "$name" error: ${error.toString()}');
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

class DebugProviderPanel extends StatelessWidget {
  const DebugProviderPanel({super.key});

  Color _stateColor(ProviderStatusEntry entry) {
    if (entry.isError) return const Color(0xFFFF4D6D);
    if (entry.state == 'loading') return const Color(0xFF4D8AF0);
    return const Color(0xFF4A5568);
  }

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
        return ListView.builder(
          itemCount: reversed.length,
          itemBuilder: (context, index) {
            final entry = reversed[index];
            return _ProviderRow(entry: entry);
          },
        );
      },
    );
  }
}

class _ProviderRow extends StatelessWidget {
  const _ProviderRow({required this.entry});

  final ProviderStatusEntry entry;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: entry.isError
                    ? const Color(0xFFFF4D6D)
                    : const Color(0xFFCBD5E0),
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                entry.providerName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: entry.isError
                      ? const Color(0xFFFF4D6D)
                      : const Color(0xFF4A5568),
                  fontWeight:
                      entry.isError ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              entry.state.toUpperCase(),
              style: TextStyle(
                color: _stateColor(entry),
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _stateColor(ProviderStatusEntry entry) {
    if (entry.isError) return const Color(0xFFFF4D6D);
    if (entry.state == 'loading') return const Color(0xFF4D8AF0);
    return const Color(0xFF4A5568);
  }
}
