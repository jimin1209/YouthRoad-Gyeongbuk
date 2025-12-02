// FILE: lib/data/search/models/search_history_entry_model.dart

import 'dart:convert';

import '../../../domain/search/entities/search_history_entry.dart';

class SearchHistoryEntryModel {
  const SearchHistoryEntryModel({
    required this.query,
    required this.timestamp,
  });

  final String query;
  final DateTime timestamp;

  Map<String, dynamic> toJson() {
    return {
      'query': query,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory SearchHistoryEntryModel.fromJson(Map<String, dynamic> json) {
    return SearchHistoryEntryModel(
      query: json['query'] as String? ?? '',
      timestamp: DateTime.tryParse(json['timestamp'] as String? ?? '') ??
          DateTime.fromMillisecondsSinceEpoch(0),
    );
  }

  SearchHistoryEntry toDomain() {
    return SearchHistoryEntry(query: query, timestamp: timestamp);
  }

  factory SearchHistoryEntryModel.fromDomain(SearchHistoryEntry entry) {
    return SearchHistoryEntryModel(
      query: entry.query,
      timestamp: entry.timestamp,
    );
  }

  static List<SearchHistoryEntryModel> decodeList(String? value) {
    if (value == null || value.isEmpty) return const [];
    final decoded = jsonDecode(value);
    if (decoded is List) {
      return decoded
          .map((e) => SearchHistoryEntryModel.fromJson(
                (e as Map).cast<String, dynamic>(),
              ))
          .toList();
    }
    return const [];
  }

  static String encodeList(List<SearchHistoryEntryModel> list) {
    return jsonEncode(list.map((e) => e.toJson()).toList());
  }
}
