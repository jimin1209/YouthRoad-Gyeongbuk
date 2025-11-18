import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/search_history_storage.dart';

final searchHistoryControllerProvider =
    AsyncNotifierProvider<SearchHistoryController, List<String>>(
  SearchHistoryController.new,
);

class SearchHistoryController extends AsyncNotifier<List<String>> {
  late SearchHistoryStorage _storage;

  @override
  Future<List<String>> build() async {
    _storage = await SearchHistoryStorage.create();
    return _storage.load();
  }

  Future<void> addTerm(String term) async {
    if (term.isEmpty) return;
    final current = List<String>.from(state.value ?? await future);
    current.removeWhere((element) => element.toLowerCase() == term.toLowerCase());
    current.insert(0, term);
    if (current.length > SearchHistoryStorage.limit) {
      current.removeRange(SearchHistoryStorage.limit, current.length);
    }
    await _storage.save(current);
    state = AsyncValue.data(current);
  }

  Future<void> removeTerm(String term) async {
    final current = List<String>.from(state.value ?? await future);
    current.remove(term);
    await _storage.save(current);
    state = AsyncValue.data(current);
  }

  Future<void> clear() async {
    await _storage.save(const []);
    state = const AsyncValue.data([]);
  }
}
