import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/logging/app_log_level.dart';

const _maxLogCount = 400;
const _maxProviderCount = 200;
const _maxNetworkCount = 200;
const _maxWebViewCount = 200;
const Object _sentinel = Object();

enum DevLogSource { app, provider, network, webView }

class DevLogEntry {
  DevLogEntry({
    required this.level,
    required this.message,
    this.source = DevLogSource.app,
    this.error,
    this.stackTrace,
    Map<String, dynamic>? extra,
    DateTime? timestamp,
  })  : timestamp = timestamp ?? DateTime.now(),
        extra = extra == null ? null : Map.unmodifiable(extra);

  final DevLogSource source;
  final AppLogLevel level;
  final String message;
  final Object? error;
  final StackTrace? stackTrace;
  final Map<String, dynamic>? extra;
  final DateTime timestamp;
}

class ProviderEventEntry {
  ProviderEventEntry({
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
}

class NetworkEvent {
  NetworkEvent({
    required this.method,
    required this.path,
    this.statusCode,
    this.duration,
    this.error,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  final String method;
  final String path;
  final int? statusCode;
  final Duration? duration;
  final DioException? error;
  final DateTime timestamp;

  bool get isError => (statusCode ?? 0) >= 400 || error != null;
}

class WebViewConsoleEntry {
  WebViewConsoleEntry({
    required this.level,
    required this.message,
    this.source,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  final String level;
  final String message;
  final String? source;
  final DateTime timestamp;
}

class DevtoolsState {
  const DevtoolsState({
    this.isOpen = false,
    this.activeTab = 0,
    this.isCollectionEnabled = true,
    this.logs = const [],
    this.providerEvents = const [],
    this.networkEvents = const [],
    this.webViewEvents = const [],
    this.selectedLog,
    this.selectedProviderEvent,
    this.selectedNetworkEvent,
    this.selectedWebViewEvent,
  });

  final bool isOpen;
  final int activeTab;
  final bool isCollectionEnabled;
  final List<DevLogEntry> logs;
  final List<ProviderEventEntry> providerEvents;
  final List<NetworkEvent> networkEvents;
  final List<WebViewConsoleEntry> webViewEvents;
  final DevLogEntry? selectedLog;
  final ProviderEventEntry? selectedProviderEvent;
  final NetworkEvent? selectedNetworkEvent;
  final WebViewConsoleEntry? selectedWebViewEvent;

  DevtoolsState copyWith({
    bool? isOpen,
    int? activeTab,
    bool? isCollectionEnabled,
    List<DevLogEntry>? logs,
    List<ProviderEventEntry>? providerEvents,
    List<NetworkEvent>? networkEvents,
    List<WebViewConsoleEntry>? webViewEvents,
    Object? selectedLog = _sentinel,
    Object? selectedProviderEvent = _sentinel,
    Object? selectedNetworkEvent = _sentinel,
    Object? selectedWebViewEvent = _sentinel,
  }) {
    return DevtoolsState(
      isOpen: isOpen ?? this.isOpen,
      activeTab: activeTab ?? this.activeTab,
      isCollectionEnabled: isCollectionEnabled ?? this.isCollectionEnabled,
      logs: logs ?? this.logs,
      providerEvents: providerEvents ?? this.providerEvents,
      networkEvents: networkEvents ?? this.networkEvents,
      webViewEvents: webViewEvents ?? this.webViewEvents,
      selectedLog: identical(selectedLog, _sentinel)
          ? this.selectedLog
          : selectedLog as DevLogEntry?,
      selectedProviderEvent: identical(selectedProviderEvent, _sentinel)
          ? this.selectedProviderEvent
          : selectedProviderEvent as ProviderEventEntry?,
      selectedNetworkEvent: identical(selectedNetworkEvent, _sentinel)
          ? this.selectedNetworkEvent
          : selectedNetworkEvent as NetworkEvent?,
      selectedWebViewEvent: identical(selectedWebViewEvent, _sentinel)
          ? this.selectedWebViewEvent
          : selectedWebViewEvent as WebViewConsoleEntry?,
    );
  }
}

abstract class DevtoolsSink {
  void addLog(
    AppLogLevel level,
    String message, {
    DevLogSource source,
    Object? error,
    StackTrace? stackTrace,
    Map<String, dynamic>? extra,
  });
  void addProviderEvent(ProviderEventEntry entry);
  void addNetwork(NetworkEvent event);
  void addWebViewConsole(WebViewConsoleEntry entry);
}

class DevtoolsBinding {
  DevtoolsBinding._();

  static final DevtoolsBinding instance = DevtoolsBinding._();

  DevtoolsSink? _sink;

  void register(DevtoolsSink sink) {
    _sink = sink;
  }

  void unregister(DevtoolsSink sink) {
    if (_sink == sink) {
      _sink = null;
    }
  }

  void addLog(
    AppLogLevel level,
    String message, {
    DevLogSource source = DevLogSource.app,
    Object? error,
    StackTrace? stackTrace,
    Map<String, dynamic>? extra,
  }) {
    if (kReleaseMode) return;
    _sink?.addLog(
      level,
      message,
      source: source,
      error: error,
      stackTrace: stackTrace,
      extra: extra,
    );
  }

  void addProviderEvent(ProviderEventEntry entry) {
    if (kReleaseMode) return;
    _sink?.addProviderEvent(entry);
  }

  void addNetwork(NetworkEvent event) {
    if (kReleaseMode) return;
    _sink?.addNetwork(event);
  }

  void addWebViewConsole(WebViewConsoleEntry entry) {
    if (kReleaseMode) return;
    _sink?.addWebViewConsole(entry);
  }
}

class DevtoolsNotifier extends StateNotifier<DevtoolsState>
    implements DevtoolsSink {
  DevtoolsNotifier() : super(const DevtoolsState()) {
    if (!kReleaseMode) {
      DevtoolsBinding.instance.register(this);
    }
  }

  final List<DevtoolsState Function(DevtoolsState)> _pendingUpdates = [];
  bool _hasScheduledFlush = false;

  @override
  void dispose() {
    DevtoolsBinding.instance.unregister(this);
    super.dispose();
  }

  void _enqueue(DevtoolsState Function(DevtoolsState) operation) {
    _pendingUpdates.add(operation);
    if (_hasScheduledFlush) return;
    _hasScheduledFlush = true;
    scheduleMicrotask(_flush);
  }

  void _flush() {
    if (!mounted) {
      _pendingUpdates.clear();
      _hasScheduledFlush = false;
      return;
    }

    var next = state;
    for (final operation in _pendingUpdates) {
      next = operation(next);
    }
    _pendingUpdates.clear();
    _hasScheduledFlush = false;

    if (next != state) {
      state = next;
    }
  }

  void toggleOverlay() {
    _enqueue((current) => current.copyWith(isOpen: !current.isOpen));
  }

  void openOverlay() {
    _enqueue((current) => current.copyWith(isOpen: true));
  }

  void closeOverlay() {
    _enqueue((current) => current.copyWith(isOpen: false));
  }

  void toggleLogCollection() {
    _enqueue(
      (current) => current.copyWith(
        isCollectionEnabled: !current.isCollectionEnabled,
      ),
    );
  }

  void setActiveTab(int index) {
    _enqueue((current) => current.copyWith(activeTab: index));
  }

  void selectLog(DevLogEntry? log) {
    _enqueue((current) => current.copyWith(selectedLog: log));
  }

  void selectProviderEvent(ProviderEventEntry? entry) {
    _enqueue((current) => current.copyWith(selectedProviderEvent: entry));
  }

  void selectNetworkEvent(NetworkEvent? event) {
    _enqueue((current) => current.copyWith(selectedNetworkEvent: event));
  }

  void selectWebViewEvent(WebViewConsoleEntry? event) {
    _enqueue((current) => current.copyWith(selectedWebViewEvent: event));
  }

  @override
  void addLog(
    AppLogLevel level,
    String message, {
    DevLogSource source = DevLogSource.app,
    Object? error,
    StackTrace? stackTrace,
    Map<String, dynamic>? extra,
  }) {
    _enqueue((current) {
      if (!current.isCollectionEnabled) return current;

      final updated = <DevLogEntry>[...
        current.logs,
        DevLogEntry(
          level: level,
          message: message,
          source: source,
          error: error,
          stackTrace: stackTrace,
          extra: extra,
        ),
      ];
      final trimmed = _keepTail(updated, _maxLogCount);
      final selectedLog =
          trimmed.contains(current.selectedLog) ? current.selectedLog : null;
      return current.copyWith(logs: trimmed, selectedLog: selectedLog);
    });
  }

  @override
  void addProviderEvent(ProviderEventEntry entry) {
    _enqueue((current) {
      if (!current.isCollectionEnabled) return current;

      final updated = <ProviderEventEntry>[...current.providerEvents, entry];
      final trimmed = _keepTail(updated, _maxProviderCount);
      final selectedProviderEvent = trimmed.contains(current.selectedProviderEvent)
          ? current.selectedProviderEvent
          : null;
      return current.copyWith(
        providerEvents: trimmed,
        selectedProviderEvent: selectedProviderEvent,
      );
    });
  }

  @override
  void addNetwork(NetworkEvent event) {
    _enqueue((current) {
      if (!current.isCollectionEnabled) return current;

      final updated = <NetworkEvent>[...current.networkEvents, event];
      final trimmed = _keepTail(updated, _maxNetworkCount);
      final selectedNetworkEvent = trimmed.contains(current.selectedNetworkEvent)
          ? current.selectedNetworkEvent
          : null;
      return current.copyWith(
        networkEvents: trimmed,
        selectedNetworkEvent: selectedNetworkEvent,
      );
    });
  }

  @override
  void addWebViewConsole(WebViewConsoleEntry entry) {
    _enqueue((current) {
      if (!current.isCollectionEnabled) return current;

      final updated = <WebViewConsoleEntry>[...current.webViewEvents, entry];
      final trimmed = _keepTail(updated, _maxWebViewCount);
      final selectedWebViewEvent = trimmed.contains(current.selectedWebViewEvent)
          ? current.selectedWebViewEvent
          : null;
      return current.copyWith(
        webViewEvents: trimmed,
        selectedWebViewEvent: selectedWebViewEvent,
      );
    });
  }

  List<T> _keepTail<T>(List<T> items, int max) {
    if (items.length <= max) return items;
    return items.sublist(items.length - max);
  }
}

final devtoolsProvider =
    StateNotifierProvider<DevtoolsNotifier, DevtoolsState>((ref) {
  return DevtoolsNotifier();
});
