import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../devtools_provider.dart';

class DevtoolsWebViewBridge {
  const DevtoolsWebViewBridge._();

  static const channelName = 'DevToolsConsole';

  static JavaScriptChannel channel() {
    return JavaScriptChannel(
      name: channelName,
      onMessageReceived: (message) {
        DevtoolsBinding.instance.addWebViewConsole(
          WebViewConsoleEntry(level: 'info', message: message.message, source: 'channel'),
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
    final entries = ref.watch(devtoolsProvider.select((s) => s.webViewEvents));
    if (entries.isEmpty) {
      return const _EmptyView(message: 'No WebView console messages yet.');
    }

    final reversed = entries.reversed.toList();
    return ListView.separated(
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
