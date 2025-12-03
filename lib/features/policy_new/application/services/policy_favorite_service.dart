import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/policy.dart';
import '../../domain/entities/policy_favorite.dart';
import '../../domain/repositories/policy_favorite_repository.dart';
import '../../domain/values/policy_event.dart';
import '../behavior/policy_behavior_tracker.dart';
import '../controllers/policy_event_bus.dart';

class FavoriteIdsNotifier extends StateNotifier<Set<String>> {
  FavoriteIdsNotifier({required this.repository}) : super({});

  final PolicyFavoriteRepository repository;

  Future<void> initialize() async {
    final favorites = await repository.getAllFavorites();
    state = favorites.map((favorite) => favorite.policyId).toSet();
  }

  void add(String policyId) {
    state = {...state, policyId};
  }

  void remove(String policyId) {
    final updated = {...state}..remove(policyId);
    state = updated;
  }

  Future<void> reload() async {
    await initialize();
  }
}

class PolicyFavoriteService {
  PolicyFavoriteService({
    required this.repository,
    required this.eventBus,
    required this.behaviorTracker,
    required this.favoriteIdsNotifier,
  });

  final PolicyFavoriteRepository repository;
  final PolicyEventBus eventBus;
  final PolicyBehaviorTracker behaviorTracker;
  final FavoriteIdsNotifier favoriteIdsNotifier;

  Future<void> toggleFavorite(Policy policy) async {
    final exists = await repository.isFavorite(policy.id);
    if (exists) {
      await repository.deleteFavorite(policy.id);
      favoriteIdsNotifier.remove(policy.id);
      _emitFavoriteChanged(policy, added: false);
      return;
    }

    final favorite = PolicyFavorite(
      policyId: policy.id,
      savedAt: DateTime.now().toUtc(),
    );

    await repository.saveFavorite(favorite);
    favoriteIdsNotifier.add(policy.id);
    _emitFavoriteChanged(policy, added: true);
  }

  Future<bool> isFavorite(String policyId) {
    return repository.isFavorite(policyId);
  }

  Future<List<String>> getFavoriteIds() {
    return repository.getFavoriteIds();
  }

  void _emitFavoriteChanged(Policy policy, {required bool added}) {
    eventBus.emit(
      PolicyEvent(PolicyEventType.favoritesChanged, policyId: policy.id),
    );

    behaviorTracker.recordFavoriteChanged(policy, added: added);
  }
}
