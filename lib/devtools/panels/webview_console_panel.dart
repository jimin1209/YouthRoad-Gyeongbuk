import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../devtools_provider.dart';
import '../widgets/devtools_split_pane.dart';

class DevtoolsWebViewBridge {
  static const channelName = 'DevtoolsConsole';

  static void attachTo(WebViewController controller) {
    controller.addJavaScriptChannel(
      channelName,
      onMessageReceived: (message) {
        debugPrint('[WEBVIEW_CONSOLE] ${message.message}');
        DevtoolsBinding.instance.addWebViewConsole(
          WebViewConsoleEntry(
            level: 'info',
            message: message.message,
            source: 'channel',
          ),
        );
      },
    );
  }

  static void forwardConsole(JavaScriptConsoleMessage message) {
    if (kReleaseMode) return;
    DevtoolsBinding.instance.addWebViewConsole(
      WebViewConsoleEntry(
        level: message.level.name,
        message: message.message,
        source: null,
      ),
    );
  }
}

class WebViewConsolePanel extends ConsumerWidget {
  const WebViewConsolePanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(devtoolsProvider);
    final notifier = ref.read(devtoolsProvider.notifier);
    final entries = state.webViewEvents;
    final selected = state.selectedWebViewEvent;
    if (entries.isEmpty) {
      return const _EmptyView(message: 'No WebView console messages yet.');
    }

    final reversed = entries.reversed.toList();
    return DevtoolsSplitPane(
      list: ListView.separated(
        itemCount: reversed.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final entry = reversed[index];
          final color = entry.level.toLowerCase().contains('error')
              ? const Color(0xFFDC2626)
              : entry.level.toLowerCase().contains('warn')
                  ? const Color(0xFFF59E0B)
                  : const Color(0xFF0F172A);
          return ListTile(
            dense: true,
            selected: selected == entry,
            selectedTileColor: const Color(0xFFE2E8F0),
            title: Text(
              entry.message,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: color),
            ),
            subtitle: Text(
              '${entry.level.toUpperCase()} • ${entry.source ?? 'console'}',
            ),
            trailing: Text(
              _formatTimestamp(entry.timestamp),
              style: const TextStyle(fontSize: 12, color: Color(0xFF94A3B8)),
            ),
            onTap: () => notifier.selectWebViewEvent(entry),
          );
        },
      ),
      detail: _WebViewDetailView(entry: selected),
    );
  }

  String _formatTimestamp(DateTime time) {
    final h = time.hour.toString().padLeft(2, '0');
    final m = time.minute.toString().padLeft(2, '0');
    final s = time.second.toString().padLeft(2, '0');
    return '$h:$m:$s';
  }
}

class _WebViewDetailView extends StatelessWidget {
  const _WebViewDetailView({required this.entry});

  final WebViewConsoleEntry? entry;

  @override
  Widget build(BuildContext context) {
    if (entry == null) {
      return const _EmptyDetail(message: '항목을 선택해주세요.');
    }

    final payload = {
      'level': entry!.level,
      'message': entry!.message,
      'source': entry!.source,
      'timestamp': entry!.timestamp.toIso8601String(),
    };

    return Padding(
      padding: const EdgeInsets.all(12),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              entry!.message,
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
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
