import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/logging/app_log_level.dart';

const _maxLogCount = 400;
const _maxProviderCount = 200;
const _maxNetworkCount = 200;
const _maxWebViewCount = 200;

class DevLogEntry {
  DevLogEntry({
    required this.level,
    required this.message,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  final AppLogLevel level;
  final String message;
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
    this.logs = const [],
    this.providerEvents = const [],
    this.networkEvents = const [],
    this.webViewEvents = const [],
  });

  final bool isOpen;
  final int activeTab;
  final List<DevLogEntry> logs;
  final List<ProviderEventEntry> providerEvents;
  final List<NetworkEvent> networkEvents;
  final List<WebViewConsoleEntry> webViewEvents;

  DevtoolsState copyWith({
    bool? isOpen,
    int? activeTab,
    List<DevLogEntry>? logs,
    List<ProviderEventEntry>? providerEvents,
    List<NetworkEvent>? networkEvents,
    List<WebViewConsoleEntry>? webViewEvents,
  }) {
    return DevtoolsState(
      isOpen: isOpen ?? this.isOpen,
      activeTab: activeTab ?? this.activeTab,
      logs: logs ?? this.logs,
      providerEvents: providerEvents ?? this.providerEvents,
      networkEvents: networkEvents ?? this.networkEvents,
      webViewEvents: webViewEvents ?? this.webViewEvents,
    );
  }
}

abstract class DevtoolsSink {
  void addLog(AppLogLevel level, String message);
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

  void addLog(AppLogLevel level, String message) {
    if (kReleaseMode) return;
    _sink?.addLog(level, message);
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

  @override
  void dispose() {
    DevtoolsBinding.instance.unregister(this);
    super.dispose();
  }

  void toggleOverlay() {
    state = state.copyWith(isOpen: !state.isOpen);
  }

  void closeOverlay() {
    state = state.copyWith(isOpen: false);
  }

  void setActiveTab(int index) {
    state = state.copyWith(activeTab: index);
  }

  @override
  void addLog(AppLogLevel level, String message) {
    final updated = <DevLogEntry>[...state.logs, DevLogEntry(level: level, message: message)];
    state = state.copyWith(logs: _keepTail(updated, _maxLogCount));
  }

  @override
  void addProviderEvent(ProviderEventEntry entry) {
    final updated = <ProviderEventEntry>[...state.providerEvents, entry];
    state = state.copyWith(providerEvents: _keepTail(updated, _maxProviderCount));
  }

  @override
  void addNetwork(NetworkEvent event) {
    final updated = <NetworkEvent>[...state.networkEvents, event];
    state = state.copyWith(networkEvents: _keepTail(updated, _maxNetworkCount));
  }

  @override
  void addWebViewConsole(WebViewConsoleEntry entry) {
    final updated = <WebViewConsoleEntry>[...state.webViewEvents, entry];
    state = state.copyWith(webViewEvents: _keepTail(updated, _maxWebViewCount));
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
