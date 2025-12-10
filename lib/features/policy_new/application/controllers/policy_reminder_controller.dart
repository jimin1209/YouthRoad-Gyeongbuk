// lib/features/policy_new/application/controllers/policy_reminder_controller.dart

import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/policy.dart';
import '../../domain/entities/policy_reminder.dart';
import '../../domain/values/policy_event.dart';
import '../../domain/values/policy_reminder_status.dart';
import '../../domain/values/reminder_time_kind.dart';
import '../../domain/values/schedule_result.dart';
import '../../domain/values/reminder_sync_report.dart';
import '../providers.dart';
import '../services/policy_reminder_service.dart';

class PolicyReminderViewState {
  const PolicyReminderViewState({
    required this.reminders,
    this.isRefreshing = false,
    this.isMutating = false,
    this.messages = const [],
    this.errorMessage,
  });

  static const _noValue = Object();

  final List<PolicyReminder> reminders;
  final bool isRefreshing;
  final bool isMutating;
  final List<String> messages;
  final String? errorMessage;

  PolicyReminderViewState copyWith({
    List<PolicyReminder>? reminders,
    bool? isRefreshing,
    bool? isMutating,
    List<String>? messages,
    Object? errorMessage = _noValue,
  }) {
    return PolicyReminderViewState(
      reminders: reminders ?? this.reminders,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      isMutating: isMutating ?? this.isMutating,
      messages: messages ?? this.messages,
      errorMessage: identical(errorMessage, _noValue)
          ? this.errorMessage
          : errorMessage as String?,
    );
  }

  static PolicyReminderViewState initial() =>
      const PolicyReminderViewState(reminders: [], isRefreshing: true);
}

class PolicyReminderController
    extends StateNotifier<AsyncValue<PolicyReminderViewState>> {
  PolicyReminderController({
    required this.ref,
    required this.policyId,
  }) : super(const AsyncLoading()) {
    _ensureInitialized();
    _listenPolicyEvents();
  }

  final Ref ref;
  final String policyId;

  PolicyReminderService get _service => ref.read(policyReminderServiceProvider);

  bool _initialized = false;
  bool _ignoreEvents = false;
  int _activeSilentOps = 0;
  bool _pendingEventReload = false;

  void _ensureInitialized() {
    Future.microtask(onInit);
  }

  Future<void> onInit() async {
    if (_initialized) return;
    _initialized = true;
    await initialize();
  }

  Future<void> initialize() async {
    await _silenceEventsWhile(() async {
      final previous = state.value ?? PolicyReminderViewState.initial();
      try {
        final syncReport = await _service.syncScheduledReminders();
        await load();

        final syncMessages = _messagesForSyncReport(syncReport);
        if (syncMessages.isNotEmpty) {
          state = state.whenData(
            (viewState) => viewState.copyWith(messages: syncMessages),
          );
        }
      } catch (e, st) {
        state = AsyncData(
          previous.copyWith(
            isRefreshing: false,
            isMutating: false,
            messages: ['알림 정보를 불러오지 못했습니다: $e'],
            errorMessage: null,
          ),
        );
        print('PolicyReminderController.initialize failed: $e\n$st');
      }
    });
  }

  Future<void> load({bool preserveMessages = true}) async {
    await _silenceEventsWhile(() async {
      final previous = state.value;
      final base = previous ?? PolicyReminderViewState.initial();

      if (!state.hasValue) {
        state = const AsyncLoading();
      } else {
        state = AsyncData(base.copyWith(isRefreshing: true));
      }

      try {
        final reminders = await _fetchReminders();

        state = AsyncData(
          base.copyWith(
            reminders: reminders,
            isRefreshing: false,
            isMutating: false,
            messages: preserveMessages ? base.messages : const [],
            errorMessage: null,
          ),
        );
      } catch (e, st) {
        state = AsyncData(
          base.copyWith(
            isRefreshing: false,
            isMutating: false,
            messages: ['알림 정보를 불러오지 못했습니다: $e'],
            errorMessage: null,
          ),
        );
        print('PolicyReminderController.load failed: $e\n$st');
      }
    });
  }

  Future<ReminderMutationResult> setReminders(
    Policy policy,
    List<ReminderTimeKind> kinds,
  ) async {
    return _silenceEventsWhile(() async {
      final previous = state.value ?? PolicyReminderViewState.initial();
      final previousReminders = await _fetchReminders();
      state = AsyncData(
        previous.copyWith(
          isMutating: true,
          messages: const [],
          errorMessage: null,
        ),
      );
      try {
        final nextKinds = kinds.toSet();
        if (nextKinds.isEmpty) {
          await _service.cancelAllByPolicy(policyId, deleteFromRepository: true);
          final refreshed = await _fetchReminders();

          state = AsyncData(
            PolicyReminderViewState(
              reminders: refreshed,
              isRefreshing: false,
              isMutating: false,
              messages: const [],
              errorMessage: null,
            ),
          );

          print(
            '[Reminder][INFO] 알림 토글 성공 (policyId: $policyId, isActive: ${refreshed.isNotEmpty})',
          );

          return const ReminderMutationResult(reminders: [], failures: []);
        }

        final result = await _service.createRemindersForPolicy(
          policy,
          nextKinds.toList(),
        );

        final refreshed = await _fetchReminders();

        if (result.failures.isNotEmpty) {
          await _restorePreviousReminders(previousReminders, refreshed);

          _pendingEventReload = false;
          final failureMessages = _messagesForResult(result);
          final failureMessage = failureMessages.isNotEmpty
              ? failureMessages.first
              : '알림을 설정하지 못했어요. 잠시 후 다시 시도해 주세요.';
          state = AsyncData(
            PolicyReminderViewState(
              reminders: previousReminders,
              isRefreshing: false,
              isMutating: false,
              messages: const [],
              errorMessage: failureMessage,
            ),
          );

          final firstFailure =
              failureMessages.isNotEmpty ? failureMessages.first : null;
          print(
            '[Reminder][WARN] 알림 토글 실패 (policyId: $policyId, error: $firstFailure)',
          );

          return ReminderMutationResult(
            reminders: previousReminders,
            failures: result.failures,
          );
        }

        var latestReminders = refreshed;

        if (result.failures.isEmpty && result.reminders.isNotEmpty) {
          for (final reminder in refreshed) {
            if (!nextKinds.contains(reminder.timeKind)) {
              await _service.cancelReminder(
                reminder.reminderId,
                deleteFromRepository: true,
              );
            }
          }
          latestReminders = await _fetchReminders();
        }

        state = AsyncData(
          PolicyReminderViewState(
            reminders: latestReminders,
            isRefreshing: false,
            isMutating: false,
            messages: _messagesForResult(result),
            errorMessage: null,
          ),
        );

        print(
          '[Reminder][INFO] 알림 토글 성공 (policyId: $policyId, isActive: ${latestReminders.isNotEmpty})',
        );

        return result;
      } catch (e, st) {
        List<PolicyReminder> current;
        try {
          current = await _fetchReminders();
        } catch (fetchError, fetchSt) {
          print(
              'PolicyReminderController.setReminders fetch restore failed: $fetchError\n$fetchSt');
          current = previousReminders;
        }

        await _restorePreviousReminders(previousReminders, current);

        _pendingEventReload = false;

        final failures = kinds
            .map(
              (kind) => ReminderMutationFailure(
                timeKind: kind,
                failure: const ScheduleFailure(
                  type: ScheduleFailureType.unknown,
                message: '알림을 설정하지 못했어요. 잠시 후 다시 시도해 주세요.',
                code: ScheduleFailureCode.internalException,
              ),
            ),
          )
          .toList();
        state = AsyncData(
          PolicyReminderViewState(
            reminders: previousReminders,
            isRefreshing: false,
            isMutating: false,
            messages: const [],
            errorMessage:
                '알림을 설정하지 못했어요. 잠시 후 다시 시도해 주세요.',
          ),
        );
        print(
            '[Reminder][WARN] 알림 토글 실패 (policyId: $policyId, error: $e)');
        print('PolicyReminderController.setReminders failed: $e\n$st');
        return ReminderMutationResult(
          reminders: previousReminders,
          failures: failures,
        );
      }
    });
  }

  Future<void> removeReminder(String reminderId) async {
    await _silenceEventsWhile(() async {
      final previous = state.value ?? PolicyReminderViewState.initial();
      state = AsyncData(
        previous.copyWith(
          isMutating: true,
          errorMessage: null,
        ),
      );
      try {
        await _service.cancelReminder(reminderId, deleteFromRepository: true);
        final current = await _fetchReminders();
        state = AsyncData(
          previous.copyWith(
            reminders: current,
            isMutating: false,
            messages: const [],
            errorMessage: null,
          ),
        );
      } catch (e, st) {
        state = AsyncData(
          previous.copyWith(
            isMutating: false,
            messages: ['알림을 취소하지 못했어요. 잠시 후 다시 시도해 주세요.'],
            errorMessage: null,
          ),
        );
        print('PolicyReminderController.removeReminder failed: $e\n$st');
      }
    });
  }

  Future<void> cancelAll() async {
    await _silenceEventsWhile(() async {
      final previous = state.value ?? PolicyReminderViewState.initial();
      state = AsyncData(
        previous.copyWith(
          isMutating: true,
          errorMessage: null,
        ),
      );
      try {
        await _service.cancelAllByPolicy(
          policyId,
          deleteFromRepository: true,
        );
        state = AsyncData(
          previous.copyWith(
            reminders: const [],
            isMutating: false,
            messages: const [],
            errorMessage: null,
          ),
        );
      } catch (e, st) {
        state = AsyncData(
          previous.copyWith(
            isMutating: false,
            messages: ['모든 알림을 취소하지 못했어요. 잠시 후 다시 시도해 주세요.'],
            errorMessage: null,
          ),
        );
        print('PolicyReminderController.cancelAll failed: $e\n$st');
      }
    });
  }

  void clearMessages() {
    state = state.whenData(
      (viewState) => viewState.copyWith(messages: const []),
    );
  }

  void clearError() {
    state = state.whenData(
      (viewState) => viewState.copyWith(errorMessage: null),
    );
  }

  void _listenPolicyEvents() {
    ref.listen<PolicyEvent?>(policyEventBusProvider, (previous, next) {
      if (_ignoreEvents) {
        _pendingEventReload = true;
        return;
      }
      if (next == null) return;
      if (next.type == PolicyEventType.reminderBulkUpdated ||
          (next.type == PolicyEventType.reminderChanged &&
              (next.policyId == null || next.policyId == policyId))) {
        load();
      }
    });
  }

  PolicyReminderStatus? currentStatus() {
    return state.maybeWhen(
      data: (viewState) {
        if (viewState.reminders.isEmpty) return null;
        final upcoming = viewState.reminders
            .where(
                (reminder) => reminder.status == PolicyReminderStatus.scheduled)
            .toList()
          ..sort((a, b) => a.scheduledAt.compareTo(b.scheduledAt));
        if (upcoming.isNotEmpty) {
          return upcoming.first.status;
        }

        final sortedByDate = [...viewState.reminders]
          ..sort((a, b) => b.scheduledAt.compareTo(a.scheduledAt));
        return sortedByDate.first.status;
      },
      orElse: () => null,
    );
  }

  String _messageForFailure(ScheduleFailure failure) {
    final codeLabel = failure.code?.label;
    String withCode(String message) {
      if (codeLabel == null) return message;
      return '[$codeLabel] $message';
    }

    switch (failure.type) {
      case ScheduleFailureType.permissionDenied:
        return withCode('알림 권한이 꺼져 있어 예약에 실패했어요. 설정에서 권한을 허용해주세요.');
      case ScheduleFailureType.invalidDate:
        if (failure.message.isNotEmpty) {
          return withCode(failure.message);
        }
        return withCode('이미 지난 시각에는 알림을 설정할 수 없습니다.');
      case ScheduleFailureType.gatewayError:
      case ScheduleFailureType.idCollision:
      case ScheduleFailureType.unknown:
        if (failure.message.isNotEmpty) {
          return withCode(failure.message);
        }
        return withCode('알 수 없는 이유로 알림을 예약하지 못했어요. 잠시 후 다시 시도해주세요.');
    }
  }

  List<String> _messagesForFailures(List<ReminderMutationFailure> failures) {
    return failures
        .map((failure) => _messageForFailure(failure.failure))
        .toList();
  }

  List<String> _messagesForSyncReport(ReminderSyncReport report) {
    final messages = <String>[];
    messages.addAll(report.failures.map(_messageForFailure));

    if (report.expiredCount > 0 || report.firedCount > 0) {
      messages.add('만료된 알림을 정리했어요. 필요한 알림을 다시 설정해주세요.');
    }
    if (report.rescheduledCount > 0) {
      messages.add('예약이 누락된 알림을 다시 등록했어요.');
    }

    return messages;
  }

  List<String> _messagesForResult(ReminderMutationResult result) {
    final failureMessages = _messagesForFailures(result.failures);
    if (failureMessages.isNotEmpty) return failureMessages;

    return const [];
  }

  Future<void> _restorePreviousReminders(
    List<PolicyReminder> previousReminders,
    List<PolicyReminder> currentReminders,
  ) async {
    final hadAnyReminders =
        previousReminders.isNotEmpty || currentReminders.isNotEmpty;
    final repository = ref.read(policyReminderRepositoryProvider);

    try {
      await _service.cancelAllByPolicy(policyId, deleteFromRepository: true);
    } catch (e, st) {
      print('PolicyReminderController.restorePreviousReminders cancelAll failed: $e\n$st');
    }

    for (final reminder in previousReminders) {
      await repository.upsertReminder(reminder);
    }

    try {
      await _service.syncScheduledReminders();
    } catch (e, st) {
      print('PolicyReminderController.restorePreviousReminders failed: $e\n$st');
    }

    if (hadAnyReminders) {
      ref.read(policyEventBusProvider.notifier).emit(
        PolicyEvent(
          PolicyEventType.reminderBulkUpdated,
          policyId: policyId,
        ),
      );
    }
  }

  Future<T> _silenceEventsWhile<T>(Future<T> Function() action) async {
    _activeSilentOps += 1;
    _ignoreEvents = true;
    try {
      return await action();
    } finally {
      _activeSilentOps -= 1;
      if (_activeSilentOps <= 0) {
        _ignoreEvents = false;
        if (_pendingEventReload) {
          _pendingEventReload = false;
          Future.microtask(load);
        }
      }
    }
  }

  Future<List<PolicyReminder>> _fetchReminders() async {
    final reminders =
        await ref.read(policyReminderRepositoryProvider).getRemindersForPolicy(
              policyId,
            );
    reminders.sort((a, b) => a.scheduledAt.compareTo(b.scheduledAt));
    return reminders;
  }
}
