import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConsultRecord {
  ConsultRecord({
    required this.policyId,
    required this.policyTitle,
    required this.timestamp,
    this.memo,
  });

  final String policyId;
  final String policyTitle;
  final DateTime timestamp;
  final String? memo;

  Map<String, dynamic> toJson() => {
        'policyId': policyId,
        'policyTitle': policyTitle,
        'timestamp': timestamp.toIso8601String(),
        'memo': memo,
      };

  factory ConsultRecord.fromJson(Map<String, dynamic> json) => ConsultRecord(
        policyId: json['policyId'] as String? ?? '',
        policyTitle: json['policyTitle'] as String? ?? '',
        timestamp: DateTime.tryParse(json['timestamp'] as String? ?? '') ?? DateTime.now(),
        memo: json['memo'] as String?,
      );
}

class ConsultHistoryNotifier extends StateNotifier<List<ConsultRecord>> {
  ConsultHistoryNotifier() : super(const []) {
    _load();
  }

  static const _key = 'consult_history';

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_key) ?? <String>[];
    state = list.map((e) => ConsultRecord.fromJson(jsonDecode(e) as Map<String, dynamic>)).toList();
  }

  Future<void> add(ConsultRecord record) async {
    final prefs = await SharedPreferences.getInstance();
    final current = prefs.getStringList(_key) ?? <String>[];
    final updated = [jsonEncode(record.toJson()), ...current].take(50).toList();
    await prefs.setStringList(_key, updated);
    await _load();
  }
}

final consultHistoryProvider = StateNotifierProvider<ConsultHistoryNotifier, List<ConsultRecord>>(
  (ref) => ConsultHistoryNotifier(),
);
