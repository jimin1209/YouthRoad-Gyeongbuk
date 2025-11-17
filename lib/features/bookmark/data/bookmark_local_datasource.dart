import '../../policy/data/models/policy.dart';

/// TODO: Replace with Hive/SharedPreferences implementation.
class BookmarkLocalDataSource {
  final _store = <String, Policy>{};

  List<Policy> getBookmarks() => _store.values.toList();

  void toggleBookmark(Policy policy) {
    if (_store.containsKey(policy.id)) {
      _store.remove(policy.id);
    } else {
      _store[policy.id] = policy;
    }
  }
}
