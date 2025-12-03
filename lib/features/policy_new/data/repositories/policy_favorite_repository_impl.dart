import '../../domain/entities/policy_favorite.dart';
import '../../domain/repositories/policy_favorite_repository.dart';
import '../sources/policy_favorite_local_data_source.dart';

class PolicyFavoriteRepositoryImpl implements PolicyFavoriteRepository {
  PolicyFavoriteRepositoryImpl(this._localDataSource);

  final PolicyFavoriteLocalDataSource _localDataSource;

  @override
  Future<void> deleteFavorite(String policyId) {
    return _localDataSource.removeFavorite(policyId);
  }

  @override
  Future<List<PolicyFavorite>> getAllFavorites() {
    return _localDataSource.getAll();
  }

  @override
  Future<List<String>> getFavoriteIds() {
    return _localDataSource.getIds();
  }

  @override
  Future<bool> isFavorite(String policyId) {
    return _localDataSource.isFavorite(policyId);
  }

  @override
  Future<void> saveFavorite(PolicyFavorite favorite) {
    return _localDataSource.addFavorite(favorite);
  }
}
