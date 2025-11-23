import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class NetworkLogEntry {
  NetworkLogEntry({
    required this.method,
    required this.path,
    this.statusCode,
    this.duration,
    required this.timestamp,
    required this.category,
  });

  final String method;
  final String path;
  final int? statusCode;
  final Duration? duration;
  final DateTime timestamp;
  final String category;

  bool get isSuccess => statusCode != null && statusCode! < 400;
}

class DebugNetworkLogger {
  DebugNetworkLogger._();

  static final DebugNetworkLogger instance = DebugNetworkLogger._();

  final ValueNotifier<List<NetworkLogEntry>> _entries =
      ValueNotifier<List<NetworkLogEntry>>(<NetworkLogEntry>[]);

  ValueListenable<List<NetworkLogEntry>> get entries => _entries;

  void attachTo(Dio dio) {
    if (!kDebugMode) return;
    final alreadyAttached = dio.interceptors.any(
      (interceptor) => interceptor is _DebugNetworkInterceptor,
    );
    if (alreadyAttached) return;

    dio.interceptors.add(_DebugNetworkInterceptor(this));
  }

  void add(NetworkLogEntry entry) {
    if (!kDebugMode) return;
    final updated = List<NetworkLogEntry>.from(_entries.value)..add(entry);
    _entries.value = updated.takeLast(200);
  }
}

extension _ListTail<T> on List<T> {
  List<T> takeLast(int count) {
    if (length <= count) return List<T>.from(this);
    return sublist(length - count, length);
  }
}

class _DebugNetworkInterceptor extends Interceptor {
  _DebugNetworkInterceptor(this.logger);

  final DebugNetworkLogger logger;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.extra['_startTime'] = DateTime.now();
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    _record(response.requestOptions, response.statusCode);
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    _record(err.requestOptions, err.response?.statusCode);
    super.onError(err, handler);
  }

  void _record(RequestOptions options, int? statusCode) {
    final start = options.extra['_startTime'] as DateTime?;
    final duration =
        start != null ? DateTime.now().difference(start) : Duration.zero;
    final uri = Uri.parse(options.uri.toString());
    final path = uri.path;
    if (kDebugMode) {
      debugPrint(
        '[DebugNetworkLogger] ${options.method} $path '
        'status=$statusCode duration=${duration.inMilliseconds}ms',
      );
    }
    logger.add(
      NetworkLogEntry(
        method: options.method,
        path: path,
        statusCode: statusCode,
        duration: duration,
        timestamp: DateTime.now(),
        category: _categoryFor(path),
      ),
    );
  }

  String _categoryFor(String path) {
    if (path.contains('/policies')) return 'policy';
    if (path.contains('/institutions') || path.contains('/departments')) {
      return 'institution';
    }
    return 'other';
  }
}

class DebugNetworkPanel extends StatefulWidget {
  const DebugNetworkPanel({super.key});

  @override
  State<DebugNetworkPanel> createState() => _DebugNetworkPanelState();
}

class _DebugNetworkPanelState extends State<DebugNetworkPanel> {
  String _filter = 'all';

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Wrap(
              spacing: 8,
              children: [
                _FilterChip(
                  label: 'All',
                  selected: _filter == 'all',
                  onSelected: () => setState(() => _filter = 'all'),
                ),
                _FilterChip(
                  label: '정책 API',
                  selected: _filter == 'policy',
                  onSelected: () => setState(() => _filter = 'policy'),
                  color: const Color(0xFF4D8AF0),
                ),
                _FilterChip(
                  label: '기관/부서 API',
                  selected: _filter == 'institution',
                  onSelected: () => setState(() => _filter = 'institution'),
                  color: const Color(0xFF7A63F1),
                ),
              ],
            ),
          ),
          Expanded(
            child: ValueListenableBuilder<List<NetworkLogEntry>>(
              valueListenable: DebugNetworkLogger.instance.entries,
              builder: (context, entries, _) {
                final filtered = entries.reversed
                    .where((entry) => _filter == 'all' || entry.category == _filter)
                    .toList();
                if (filtered.isEmpty) {
                  return const Center(
                    child: Text(
                      'No network logs yet.',
                      style: TextStyle(color: Colors.white70),
                    ),
                  );
                }
                return ListView.builder(
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final entry = filtered[index];
                    return _NetworkCard(entry: entry);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onSelected,
    this.color,
  });

  final String label;
  final bool selected;
  final VoidCallback onSelected;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final activeColor = color ?? const Color(0xFFCBD5E0);
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      labelStyle: TextStyle(
        color: selected ? Colors.white : const Color(0xFF4A5568),
        fontWeight: FontWeight.w600,
      ),
      backgroundColor: Colors.white,
      selectedColor: activeColor,
      side: const BorderSide(color: Color(0xFFE2E8F0)),
      onSelected: (_) => onSelected(),
    );
  }
}

class _NetworkCard extends StatelessWidget {
  const _NetworkCard({required this.entry});

  final NetworkLogEntry entry;

  @override
  Widget build(BuildContext context) {
    final badgeLabel = entry.category == 'policy'
        ? '정책 API'
        : entry.category == 'institution'
            ? '기관 API'
            : '기타';
    final badgeColor = entry.category == 'policy'
        ? const Color(0xFF4D8AF0)
        : entry.category == 'institution'
            ? const Color(0xFF7A63F1)
            : const Color(0xFF4A5568);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: const Color(0xFFE2E8F0)),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _Badge(
                    label: entry.method,
                    color: entry.isSuccess
                        ? const Color(0xFF4D8AF0)
                        : const Color(0xFFFF4D6D),
                  ),
                  const SizedBox(width: 8),
                  if (entry.duration != null)
                    Text(
                      '${entry.duration!.inMilliseconds} ms',
                      style: const TextStyle(
                        color: Color(0xFF4A5568),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  const Spacer(),
                  Text(
                    entry.statusCode?.toString() ?? '--',
                    style: TextStyle(
                      color: entry.isSuccess
                          ? const Color(0xFF2F855A)
                          : const Color(0xFFFF4D6D),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                entry.path,
                style: const TextStyle(
                  color: Color(0xFF1A202C),
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 6),
              _Badge(
                label: badgeLabel,
                color: badgeColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
