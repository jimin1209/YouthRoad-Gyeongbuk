import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/policy.dart';
import '../../domain/repositories/policy_repository.dart';
import '../../domain/values/policy_logger.dart';
import '../../domain/values/policy_event.dart';
import '../../domain/values/policy_result.dart';
import '../../domain/values/policy_settings.dart';
import '../controllers/policy_event_bus.dart';

class PolicyPagingController extends StateNotifier<AsyncValue<List<Policy>>> {
  final PolicyRepository repository;
  final PolicyLogger logger;
  final PolicySettings settings;
  final PolicyEventBus eventBus;

  int _page = 1;
  bool _isLast = false;
  bool _isLoading = false;
  final List<Policy> _items = [];
  late final void Function(PolicyEvent?) _eventListener;
  void Function()? _removeEventListener;

  PolicyPagingController({
    required this.repository,
    required this.logger,
    required PolicySettings policySettings,
    required this.eventBus,
  })  : settings = policySettings,
        super(const AsyncValue.loading()) {
    _eventListener = (event) {
      if (event?.type == PolicyEventType.refreshRequested) {
        refresh();
      }
    };

    _removeEventListener = eventBus.addListener(
      _eventListener,
      fireImmediately: false,
    );
    loadFirstPage();
  }

  Future<void> loadFirstPage() async {
    _page = 1;
    _isLast = false;
    _items.clear();

    logger.info('PolicyPagingController.loadFirstPage()');
    _isLoading = true;
    state = const AsyncValue.loading();

    try {
      final PolicyResult<List<Policy>> result = await repository.fetchPolicies(
        page: _page,
        pageSize: settings.pageSize,
      );

      if (result.isSuccess) {
        _items.addAll(result.data!);
        state = AsyncValue.data(List.from(_items));
      } else {
        state = AsyncValue.error(result.failure!, StackTrace.current);
      }
    } finally {
      _isLoading = false;
    }
  }

  Future<void> loadNextPage() async {
    if (_isLast) {
      debugPrint('[PAGING-LAST-PAGE:NO-OP]');
      return;
    }
    if (_isLoading) return;
    _isLoading = true;

    logger.info('PolicyPagingController.loadNextPage(page: ${_page + 1})');

    final result = await repository.fetchPolicies(
      page: _page + 1,
      pageSize: settings.pageSize,
    );

    if (!result.isSuccess) {
      state = AsyncValue.error(result.failure!, StackTrace.current);
      _isLoading = false;
      return;
    }

    final newItems = result.data!;
    if (newItems.isEmpty) {
      _isLast = true;
    } else {
      _page++;
      _items.addAll(newItems);
      state = AsyncValue.data(List.from(_items));
    }

    _isLoading = false;
  }

  Future<void> refresh() async {
    logger.info('PolicyPagingController.refresh() 호출');
    await loadFirstPage();
  }

  @override
  void dispose() {
    _removeEventListener?.call();
    super.dispose();
  }
}
