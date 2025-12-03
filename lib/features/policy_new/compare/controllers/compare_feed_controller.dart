import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/controllers/policy_event_bus.dart';
import '../../application/providers.dart';
import '../../application/models/user_collections.dart';
import '../../domain/entities/policy.dart';
import '../../domain/repositories/policy_repository.dart';
import '../../domain/values/policy_event.dart';
import '../../domain/values/policy_failure.dart';
import '../models/compare_state.dart';
import 'compare_diff_service.dart';

class CompareFeedController extends StateNotifier<AsyncValue<CompareState>> {
  CompareFeedController({
    required this.ref,
    required this.repository,
    required this.diffService,
  }) : super(const AsyncValue.loading()) {
    _listenToChanges();
    load();
  }

  final Ref ref;
  final PolicyRepository repository;
  final CompareDiffService diffService;

  void _listenToChanges() {
    ref.listen<CompareRepository>(compareRepositoryProvider, (previous, next) {
      if (previous?.ids != next.ids) {
        load();
      }
    });

    ref.listen<PolicyEvent?>(policyEventBusProvider, (previous, next) {
      if (next?.type == PolicyEventType.compareListChanged) {
        load();
      }
    });
  }

  Future<void> load() async {
    final ids = ref.read(compareRepositoryProvider).ids;

    if (ids.isEmpty) {
      state = const AsyncValue.data(CompareState.empty());
      return;
    }

    state = const AsyncValue.loading();

    try {
      final policies = await Future.wait(ids.map(_fetchDetail));
      final diffs = diffService.calculateDiffs(policies);
      state = AsyncValue.data(
        CompareState(policies: policies, diffs: diffs),
      );
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<Policy> _fetchDetail(String id) async {
    final result = await repository.fetchPolicyDetail(id);
    if (!result.isSuccess || result.data == null) {
      throw result.failure ?? const UnknownFailure();
    }
    return result.data!;
  }
}
