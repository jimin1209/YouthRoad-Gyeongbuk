import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../storage/favorites_storage.dart';

final favoritesProvider = StateNotifierProvider<FavoritesNotifier, Set<String>>(
  (ref) => FavoritesNotifier(FavoritesStorage()),
);

class FavoritesNotifier extends StateNotifier<Set<String>> {
  FavoritesNotifier(this._storage) : super(<String>{}) {
    _load();
  }

  final FavoritesStorage _storage;

  Future<void> _load() async {
    final list = await _storage.load();
    state = list.toSet();
  }

  Future<void> toggle(String id) async {
    await _storage.toggle(id);
    await _load();
  }
}
