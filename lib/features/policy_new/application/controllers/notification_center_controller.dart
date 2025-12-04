import 'dart:async';
import 'dart:collection';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/policy_reminder.dart';
import '../../domain/values/policy_reminder_status.dart';
import '../providers.dart';
import '../services/policy_reminder_service.dart';

enum NotificationCenterStatus {
  idle,
  loading,
  optimisticMutating,
  success,
  failure,
}

enum NotificationCenterActionType { reload, schedule, cancel, delete }

class NotificationCenterState {
  const NotificationCenterState({
    required this.upcoming,
    required this.past,
    required this.status,
    this.lastAction,
    this.errorMessage,
    this.pendingActions = 0,
  });

  final List<PolicyReminder> upcoming;
  final List<PolicyReminder> past;
  final NotificationCenterStatus status;
  final NotificationCenterActionType? lastAction;
  final String? errorMessage;
  final int pendingActions;

  bool get isLoading => status == NotificationCenterStatus.loading;
  bool get isOptimistic => status == NotificationCenterStatus.optimisticMutating;
  bool get isFailure => status == NotificationCenterStatus.failure;

  NotificationCenterState copyWith({
    List<PolicyReminder>? upcoming,
    List<PolicyReminder>? past,
    NotificationCenterStatus? status,
    NotificationCenterActionType? lastAction,
    String? errorMessage,
    bool clearError = false,
    int? pendingActions,
  }) {
    return NotificationCenterState(
      upcoming: upcoming ?? this.upcoming,
      past: past ?? this.past,
      status: status ?? this.status,
      lastAction: lastAction ?? this.lastAction,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      pendingActions: pendingActions ?? this.pendingActions,
    );
  }

  static const NotificationCenterState initial = NotificationCenterState(
    upcoming: const [],
    past: const [],
    status: NotificationCenterStatus.loading,
  );
}

class NotificationCenterController
    extends StateNotifier<AsyncValue<NotificationCenterState>> {
  NotificationCenterController({required this.ref})
      : super(const AsyncData(NotificationCenterState.initial)) {
    load();
  }

  final Ref ref;

  final Queue<Future<void> Function()> _actionQueue = Queue();
  bool _isProcessing = false;
  final List<_OptimisticAction> _optimisticActions = [];
  int _actionCounter = 0;

  PolicyReminderService get _service => ref.read(policyReminderServiceProvider);

  Future<void> load() async {
    final previous = state.value ?? NotificationCenterState.initial;
    state = AsyncData(
      previous.copyWith(
        status: NotificationCenterStatus.loading,
        lastAction: NotificationCenterActionType.reload,
        clearError: true,
        pendingActions: _actionQueue.length,
      ),
    );

    await _enqueue(() async {
      try {
        await _service.syncScheduledReminders();
        final reminders =
            await ref.read(policyReminderRepositoryProvider).getAllReminders();
        final now = DateTime.now().toUtc();
        final upcoming = <PolicyReminder>[];
        final past = <PolicyReminder>[];

        for (final reminder in reminders) {
          if (reminder.status == PolicyReminderStatus.scheduled &&
              reminder.scheduledAt.isAfter(now)) {
            upcoming.add(reminder);
          } else {
            past.add(reminder);
          }
        }

        upcoming.sort((a, b) => a.scheduledAt.compareTo(b.scheduledAt));
        past.sort((a, b) => b.scheduledAt.compareTo(a.scheduledAt));

        state = AsyncData(
          NotificationCenterState(
            upcoming: upcoming,
            past: past,
            status: NotificationCenterStatus.success,
            lastAction: NotificationCenterActionType.reload,
            pendingActions: _actionQueue.length,
          ),
        );
      } catch (e, _) {
        state = AsyncData(
          previous.copyWith(
            status: NotificationCenterStatus.failure,
            lastAction: NotificationCenterActionType.reload,
            errorMessage: e.toString(),
            pendingActions: _actionQueue.length,
          ),
        );
      }
    });
  }

  Future<void> cancelReminder(String reminderId) async {
    final previous = state.value ?? NotificationCenterState.initial;
    final actionId = ++_actionCounter;
    final optimisticState = _removeReminder(previous, reminderId);
    _optimisticActions.add(
      _OptimisticAction(
        id: actionId,
        rollbackState: previous,
        reducer: (state) => _removeReminder(state, reminderId),
      ),
    );

    state = AsyncData(
      optimisticState.copyWith(
        status: NotificationCenterStatus.optimisticMutating,
        lastAction: NotificationCenterActionType.cancel,
        clearError: true,
        pendingActions: _actionQueue.length + 1,
      ),
    );

    await _enqueue(() async {
      try {
        await _service.cancelReminder(reminderId);
        await ref
            .read(policyReminderRepositoryProvider)
            .deleteReminderById(reminderId);
        _removeOptimisticAction(actionId);
        final current = _applyOptimisticReducers(
          state.value ?? optimisticState.copyWith(pendingActions: 0),
        );
        state = AsyncData(
          current.copyWith(
            status: NotificationCenterStatus.success,
            lastAction: NotificationCenterActionType.cancel,
            clearError: true,
            pendingActions: _actionQueue.length,
          ),
        );
      } catch (e, _) {
        _handleOptimisticFailure(
          actionId,
          NotificationCenterActionType.cancel,
          e,
        );
      }
    });
  }

  Future<void> scheduleReminders(
    Future<List<PolicyReminder>> Function() schedule,
  ) async {
    final previous = state.value ?? NotificationCenterState.initial;
    state = AsyncData(
      previous.copyWith(
        status: NotificationCenterStatus.optimisticMutating,
        lastAction: NotificationCenterActionType.schedule,
        clearError: true,
        pendingActions: _actionQueue.length + 1,
      ),
    );

    await _enqueue(() async {
      try {
        final reminders = await schedule();
        if (reminders.isEmpty) {
          state = AsyncData(
            previous.copyWith(
              status: NotificationCenterStatus.success,
              lastAction: NotificationCenterActionType.schedule,
              pendingActions: _actionQueue.length,
            ),
          );
          return;
        }

        final current = state.value ?? previous;
        state = AsyncData(
          _mergeReminders(current, reminders).copyWith(
            status: NotificationCenterStatus.success,
            lastAction: NotificationCenterActionType.schedule,
            clearError: true,
            pendingActions: _actionQueue.length,
          ),
        );
      } catch (e, _) {
        state = AsyncData(
          previous.copyWith(
            status: NotificationCenterStatus.failure,
            lastAction: NotificationCenterActionType.schedule,
            errorMessage: e.toString(),
            pendingActions: _actionQueue.length,
          ),
        );
      }
    });
  }

  Future<void> deleteReminder(String reminderId) async {
    final previous = state.value ?? NotificationCenterState.initial;
    final actionId = ++_actionCounter;
    final optimisticState = _removeReminder(previous, reminderId);
    _optimisticActions.add(
      _OptimisticAction(
        id: actionId,
        rollbackState: previous,
        reducer: (state) => _removeReminder(state, reminderId),
      ),
    );

    state = AsyncData(
      optimisticState.copyWith(
        status: NotificationCenterStatus.optimisticMutating,
        lastAction: NotificationCenterActionType.delete,
        clearError: true,
        pendingActions: _actionQueue.length + 1,
      ),
    );

    await _enqueue(() async {
      try {
        await _service.cancelReminder(reminderId);
        await ref
            .read(policyReminderRepositoryProvider)
            .deleteReminderById(reminderId);
        _removeOptimisticAction(actionId);
        final current = _applyOptimisticReducers(
          state.value ?? optimisticState.copyWith(pendingActions: 0),
        );
        state = AsyncData(
          current.copyWith(
            status: NotificationCenterStatus.success,
            lastAction: NotificationCenterActionType.delete,
            clearError: true,
            pendingActions: _actionQueue.length,
          ),
        );
      } catch (e, _) {
        _handleOptimisticFailure(
          actionId,
          NotificationCenterActionType.delete,
          e,
        );
      }
    });
  }

  Future<void> _enqueue(Future<void> Function() action) {
    final completer = Completer<void>();
    _actionQueue.add(() async {
      try {
        await action();
        if (!completer.isCompleted) {
          completer.complete();
        }
      } catch (e, st) {
        if (!completer.isCompleted) {
          completer.completeError(e, st);
        }
        rethrow;
      }
    });
    if (!_isProcessing) {
      _processQueue();
    }
    final current = state.value;
    if (current != null) {
      state = AsyncData(
        current.copyWith(
          pendingActions: _actionQueue.length,
        ),
      );
    }

    return completer.future;
  }

  Future<void> _processQueue() async {
    if (_isProcessing) return;
    _isProcessing = true;
    try {
      while (_actionQueue.isNotEmpty) {
        final action = _actionQueue.removeFirst();
        try {
          await action();
        } catch (e, _) {
          final current = state.value ?? NotificationCenterState.initial;
          state = AsyncData(
            current.copyWith(
              status: NotificationCenterStatus.failure,
              errorMessage: e.toString(),
              pendingActions: _actionQueue.length,
            ),
          );
        }
      }
    } finally {
      _isProcessing = false;
      final current = state.value;
      if (current != null) {
        state = AsyncData(current.copyWith(pendingActions: 0));
      }
    }
  }

  NotificationCenterState _removeReminder(
    NotificationCenterState state,
    String reminderId,
  ) {
    final upcoming = [
      for (final reminder in state.upcoming)
        if (reminder.reminderId != reminderId) reminder,
    ];
    final past = [
      for (final reminder in state.past)
        if (reminder.reminderId != reminderId) reminder,
    ];

    return state.copyWith(upcoming: upcoming, past: past);
  }

  NotificationCenterState _mergeReminders(
    NotificationCenterState state,
    Iterable<PolicyReminder> reminders,
  ) {
    final now = DateTime.now().toUtc();
    final upcoming = [...state.upcoming];
    final past = [...state.past];

    for (final reminder in reminders) {
      upcoming.removeWhere((r) => r.reminderId == reminder.reminderId);
      past.removeWhere((r) => r.reminderId == reminder.reminderId);

      final target =
          reminder.status == PolicyReminderStatus.scheduled &&
                  reminder.scheduledAt.isAfter(now)
              ? upcoming
              : past;
      target.add(reminder);
    }

    upcoming.sort((a, b) => a.scheduledAt.compareTo(b.scheduledAt));
    past.sort((a, b) => b.scheduledAt.compareTo(a.scheduledAt));

    return state.copyWith(upcoming: upcoming, past: past);
  }

  void _removeOptimisticAction(int id) {
    _optimisticActions.removeWhere((action) => action.id == id);
  }

  void _handleOptimisticFailure(
    int actionId,
    NotificationCenterActionType actionType,
    Object error,
  ) {
    final targetIndex =
        _optimisticActions.indexWhere((action) => action.id == actionId);
    final targetAction = targetIndex == -1
        ? _OptimisticAction(
            id: actionId,
            rollbackState: state.value ?? NotificationCenterState.initial,
            reducer: (s) => s,
          )
        : _optimisticActions.removeAt(targetIndex);
    final baseState = targetAction.rollbackState.copyWith(
      status: NotificationCenterStatus.failure,
      lastAction: actionType,
      errorMessage: error.toString(),
      pendingActions: _actionQueue.length,
    );

    final rebuilt = _applyOptimisticReducers(baseState);
    state = AsyncData(rebuilt);
  }

  NotificationCenterState _applyOptimisticReducers(
    NotificationCenterState state,
  ) {
    var current = state;
    for (final action in _optimisticActions) {
      current = action.reducer(current);
    }
    return current;
  }
}

class _OptimisticAction {
  _OptimisticAction({
    required this.id,
    required this.rollbackState,
    required this.reducer,
  });

  final int id;
  final NotificationCenterState rollbackState;
  final NotificationCenterState Function(NotificationCenterState) reducer;
}
