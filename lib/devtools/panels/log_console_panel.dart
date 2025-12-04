import 'dart:convert';
import 'package:flutter/services.dart';

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
  AppLogLevel? _levelFilter;
  DevLogSource? _sourceFilter;
  bool _autoScroll = true;
  int _lastCount = 0;
  String _query = '';
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(devtoolsProvider);
    final notifier = ref.read(devtoolsProvider.notifier);
    final entries = state.logs;
    final selected = state.selectedLog;

    final filtered = entries.where((e) {
      if (_levelFilter != null && e.level != _levelFilter) return false;
      if (_sourceFilter != null && e.source != _sourceFilter) return false;
      if (_query.isNotEmpty &&
          !e.message.toLowerCase().contains(_query.toLowerCase())) {
        return false;
      }
      return true;
    }).toList();

    _maybeAutoScroll(filtered.length);

    if (filtered.isEmpty) {
      return const _EmptyView(message: 'No logs collected yet.');
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                spacing: 12,
                runSpacing: 8,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('Source:', style: TextStyle(fontWeight: FontWeight.w600)),
                      const SizedBox(width: 8),
                      DropdownButton<DevLogSource?>(
                        value: _sourceFilter,
                        items: const [
                          DropdownMenuItem(value: null, child: Text('All')),
                          DropdownMenuItem(
                            value: DevLogSource.app,
                            child: Text('App'),
                          ),
                          DropdownMenuItem(
                            value: DevLogSource.network,
                            child: Text('Network'),
                          ),
                          DropdownMenuItem(
                            value: DevLogSource.webView,
                            child: Text('WebView'),
                          ),
                        ],
                        onChanged: (value) {
                          setState(() => _sourceFilter = value);
                          if (value != null &&
                              selected != null &&
                              selected.source != value) {
                            notifier.selectLog(null);
                          }
                        },
                      ),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('Level:', style: TextStyle(fontWeight: FontWeight.w600)),
                      const SizedBox(width: 8),
                      DropdownButton<AppLogLevel?>(
                        value: _levelFilter,
                        items: const [
                          DropdownMenuItem(value: null, child: Text('All')),
                          DropdownMenuItem(value: AppLogLevel.debug, child: Text('Debug')),
                          DropdownMenuItem(value: AppLogLevel.info, child: Text('Info')),
                          DropdownMenuItem(value: AppLogLevel.warning, child: Text('Warn')),
                          DropdownMenuItem(value: AppLogLevel.error, child: Text('Error')),
                        ],
                        onChanged: (value) {
                          setState(() => _levelFilter = value);
                          if (value != null && selected != null && selected.level != value) {
                            notifier.selectLog(null);
                          }
                        },
                      ),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('Auto-scroll'),
                      Switch(
                        value: _autoScroll,
                        onChanged: (value) => setState(() => _autoScroll = value),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('Collect logs'),
                      Switch(
                        value: state.isCollectionEnabled,
                        onChanged: (_) => notifier.toggleLogCollection(),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 8),
              TextField(
                decoration: const InputDecoration(
                  hintText: 'Search message',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
                onChanged: (value) => setState(() => _query = value),
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
                  controller: _scrollController,
                  itemCount: filtered.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final log = filtered[index];
                    final color = _colorForLevel(log.level);
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
                      subtitle: Text(
                        '${_sourceLabel(log.source)} • ${log.level.name.toUpperCase()}',
                        style: const TextStyle(color: Color(0xFF475569)),
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

  Color _colorForLevel(AppLogLevel level) {
    return switch (level) {
      AppLogLevel.debug => const Color(0xFF0EA5E9),
      AppLogLevel.info => const Color(0xFF0F172A),
      AppLogLevel.warning => const Color(0xFFF59E0B),
      AppLogLevel.error => const Color(0xFFDC2626),
    };
  }

  String _sourceLabel(DevLogSource source) {
    return switch (source) {
      DevLogSource.app => 'APP',
      DevLogSource.network => 'NETWORK',
      DevLogSource.webView => 'WEBVIEW',
    };
  }

  void _maybeAutoScroll(int itemCount) {
    if (!_autoScroll || !_scrollController.hasClients) return;
    if (itemCount == _lastCount) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
      );
    });
    _lastCount = itemCount;
  }

  String _formatTimestamp(DateTime time) {
    final h = time.hour.toString().padLeft(2, '0');
    final m = time.minute.toString().padLeft(2, '0');
    final s = time.second.toString().padLeft(2, '0');
    final ms = time.millisecond.toString().padLeft(3, '0');
    return '$h:$m:$s.$ms';
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
      'source': entry!.source.name,
      'level': entry!.level.name,
      'message': entry!.message,
      'timestamp': entry!.timestamp.toIso8601String(),
      if (entry!.extra != null) 'extra': _serialize(entry!.extra),
      if (entry!.error != null) 'error': _serialize(entry!.error),
      if (entry!.stackTrace != null) 'stackTrace': _serialize(entry!.stackTrace),
    };
    final formattedPayload = _prettyPrint(payload);

    return _DetailContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '[${entry!.source.name.toUpperCase()}] ${entry!.level.name.toUpperCase()}',
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(_formatTimestamp(entry!.timestamp)),
              IconButton(
                tooltip: '복사하기',
                icon: const Icon(Icons.copy, size: 20),
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: formattedPayload));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('로그 상세가 복사되었습니다.')),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 12),
          SelectableText(formattedPayload),
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

  dynamic _serialize(dynamic value) {
    const maxLength = 2000;

    if (value is Map) {
      return value.map((key, v) => MapEntry(key.toString(), _serialize(v)));
    }
    if (value is Iterable) {
      return value.map(_serialize).toList();
    }
    if (value is num || value is bool || value == null) {
      return value;
    }

    final text = value.toString();
    if (text.length > maxLength) {
      return '${text.substring(0, maxLength)}…(truncated)';
    }
    return text;
  }

  String _formatTimestamp(DateTime time) {
    final h = time.hour.toString().padLeft(2, '0');
    final m = time.minute.toString().padLeft(2, '0');
    final s = time.second.toString().padLeft(2, '0');
    final ms = time.millisecond.toString().padLeft(3, '0');
    return '$h:$m:$s.$ms';
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
