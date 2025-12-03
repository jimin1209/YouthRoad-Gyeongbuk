import '../entities/policy_favorite.dart';

abstract class PolicyFavoriteRepository {
  Future<List<PolicyFavorite>> getAllFavorites();
  Future<List<String>> getFavoriteIds();
  Future<bool> isFavorite(String policyId);
  Future<void> saveFavorite(PolicyFavorite favorite);
  Future<void> deleteFavorite(String policyId);
}
