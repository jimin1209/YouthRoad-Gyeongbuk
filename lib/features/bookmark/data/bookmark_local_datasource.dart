import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../policy/data/models/policy.dart';
import 'bookmark_models.dart';

class BookmarkLocalDataSource {
  BookmarkLocalDataSource._(this._prefs);

  static const _storageKey = 'bookmark_policies';

  final SharedPreferences _prefs;

  static Future<BookmarkLocalDataSource> create() async {
    final prefs = await SharedPreferences.getInstance();
    return BookmarkLocalDataSource._(prefs);
  }

  List<BookmarkEntry> getBookmarkEntries() {
    final raw = _prefs.getStringList(_storageKey) ?? const [];
    return raw
        .map((item) => BookmarkEntry.fromJson(
              Map<String, dynamic>.from(jsonDecode(item) as Map<String, dynamic>),
            ))
        .toList();
  }

  Future<List<BookmarkEntry>> toggleBookmark(
    Policy policy, {
    BookmarkFolder folder = BookmarkFolder.favorite,
  }) async {
    final current = getBookmarkEntries();
    final index = current.indexWhere((element) => element.policy.id == policy.id);
    if (index >= 0) {
      current.removeAt(index);
    } else {
      current.add(
        BookmarkEntry(
          policy: policy,
          folder: folder,
          savedAt: DateTime.now(),
        ),
      );
    }
    await _save(current);
    return current;
  }

  Future<List<BookmarkEntry>> updateFolder(
    String policyId,
    BookmarkFolder folder,
  ) async {
    final current = getBookmarkEntries();
    final index = current.indexWhere((element) => element.policy.id == policyId);
    if (index >= 0) {
      current[index] = current[index].copyWith(folder: folder);
      await _save(current);
    }
    return current;
  }

  bool isBookmarked(String policyId) {
    final current = getBookmarkEntries();
    return current.any((entry) => entry.policy.id == policyId);
  }

  BookmarkFolder? folderOf(String policyId) {
    final current = getBookmarkEntries();
    for (final entry in current) {
      if (entry.policy.id == policyId) {
        return entry.folder;
      }
    }
    return null;
  }

  Future<void> _save(List<BookmarkEntry> entries) async {
    final encoded = entries.map((entry) => jsonEncode(entry.toJson())).toList();
    await _prefs.setStringList(_storageKey, encoded);
  }
}
