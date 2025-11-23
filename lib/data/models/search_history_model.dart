import 'dart:convert';

class SearchHistory {
  const SearchHistory({required this.query, required this.timestamp});

  final String query;
  final DateTime timestamp;

  factory SearchHistory.fromJson(Map<String, dynamic> json) {
    return SearchHistory(
      query: json['query'] as String? ?? '',
      timestamp: DateTime.tryParse(json['timestamp'] as String? ?? '') ??
          DateTime.fromMillisecondsSinceEpoch(0),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'query': query,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  static List<SearchHistory> decodeList(String? value) {
    if (value == null || value.isEmpty) return <SearchHistory>[];
    final decoded = jsonDecode(value);
    if (decoded is List) {
      return decoded
          .map((e) => SearchHistory.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    return <SearchHistory>[];
  }

  static String encodeList(List<SearchHistory> list) {
    return jsonEncode(list.map((e) => e.toJson()).toList());
  }
}
