import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/entities/policy_favorite.dart';

abstract class PolicyFavoriteLocalDataSource {
  Future<List<PolicyFavorite>> getAll();
  Future<List<String>> getIds();
  Future<bool> isFavorite(String policyId);
  Future<void> addFavorite(PolicyFavorite favorite);
  Future<void> removeFavorite(String policyId);
}

class SharedPrefsPolicyFavoriteLocalDataSource
    implements PolicyFavoriteLocalDataSource {
  SharedPrefsPolicyFavoriteLocalDataSource(this._prefs);

  static const _favoritesKey = 'policy_new_favorites';
  final SharedPreferences _prefs;

  @override
  Future<void> addFavorite(PolicyFavorite favorite) async {
    final favorites = await getAll();
    final updated = [
      for (final item in favorites)
        if (item.policyId != favorite.policyId) item,
      favorite,
    ];

    await _saveFavorites(updated);
  }

  @override
  Future<List<PolicyFavorite>> getAll() async {
    final raw = _prefs.getStringList(_favoritesKey);
    if (raw == null) return [];

    return raw
        .map((item) => jsonDecode(item) as Map<String, dynamic>)
        .map(
          (map) => PolicyFavorite(
            policyId: map['policyId'] as String,
            savedAt: DateTime.parse(map['savedAt'] as String),
          ),
        )
        .toList();
  }

  @override
  Future<List<String>> getIds() async {
    final favorites = await getAll();
    return favorites.map((favorite) => favorite.policyId).toList();
  }

  @override
  Future<bool> isFavorite(String policyId) async {
    final favorites = await getIds();
    return favorites.contains(policyId);
  }

  @override
  Future<void> removeFavorite(String policyId) async {
    final favorites = await getAll();
    final updated = [
      for (final item in favorites)
        if (item.policyId != policyId) item,
    ];

    await _saveFavorites(updated);
  }

  Future<void> _saveFavorites(List<PolicyFavorite> favorites) async {
    final encoded = favorites
        .map(
          (favorite) => jsonEncode(
            {
              'policyId': favorite.policyId,
              'savedAt': favorite.savedAt.toUtc().toIso8601String(),
            },
          ),
        )
        .toList();

    await _prefs.setStringList(_favoritesKey, encoded);
  }
}
