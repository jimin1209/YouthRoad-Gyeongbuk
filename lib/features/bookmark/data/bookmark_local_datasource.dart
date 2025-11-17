import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../policy/data/models/policy.dart';

class BookmarkLocalDataSource {
  BookmarkLocalDataSource._(this._prefs);

  static const _storageKey = 'bookmark_policies';

  final SharedPreferences _prefs;

  static Future<BookmarkLocalDataSource> create() async {
    final prefs = await SharedPreferences.getInstance();
    return BookmarkLocalDataSource._(prefs);
  }

  List<Policy> getBookmarks() {
    final raw = _prefs.getStringList(_storageKey) ?? const [];
    return raw
        .map((item) => Policy.fromJson(jsonDecode(item) as Map<String, dynamic>))
        .toList();
  }

  Future<List<Policy>> toggleBookmark(Policy policy) async {
    final current = getBookmarks();
    final index = current.indexWhere((element) => element.id == policy.id);
    if (index >= 0) {
      current.removeAt(index);
    } else {
      current.add(policy);
    }
    final encoded = current.map((p) => jsonEncode(p.toJson())).toList();
    await _prefs.setStringList(_storageKey, encoded);
    return current;
  }

  bool isBookmarked(String policyId) {
    final raw = _prefs.getStringList(_storageKey) ?? const [];
    return raw.any((item) {
      final decoded = jsonDecode(item) as Map<String, dynamic>;
      return decoded['id'] == policyId;
    });
  }
}
