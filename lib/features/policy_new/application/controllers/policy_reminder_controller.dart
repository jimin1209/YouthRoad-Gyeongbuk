// lib/features/policy_new/application/controllers/policy_reminder_controller.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/policy.dart';
import '../../domain/entities/policy_reminder.dart';
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
  });

  final List<PolicyReminder> reminders;
  final bool isRefreshing;
  final bool isMutating;
  final List<String> messages;

  PolicyReminderViewState copyWith({
    List<PolicyReminder>? reminders,
    bool? isRefreshing,
    bool? isMutating,
    List<String>? messages,
  }) {
    return PolicyReminderViewState(
      reminders: reminders ?? this.reminders,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      isMutating: isMutating ?? this.isMutating,
      messages: messages ?? this.messages,
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
  }) : super(const AsyncData(PolicyReminderViewState(reminders: [])));

  final Ref ref;
  final String policyId;

  PolicyReminderService get _service => ref.read(policyReminderServiceProvider);

  bool _initialized = false;

  Future<void> onInit() async {
    if (_initialized) return;
    _initialized = true;
    await initialize();
  }

  Future<void> initialize() async {
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
        ),
      );
      print('PolicyReminderController.initialize failed: $e\n$st');
    }
  }

  Future<void> load() async {
    final previous = state.value ?? PolicyReminderViewState.initial();
    state = AsyncData(previous.copyWith(isRefreshing: true));

    final reminders =
        await ref.read(policyReminderRepositoryProvider).getRemindersForPolicy(
              policyId,
            );

    reminders.sort((a, b) => a.scheduledAt.compareTo(b.scheduledAt));

    state = AsyncData(
      previous.copyWith(
        reminders: reminders,
        isRefreshing: false,
        messages: const [],
      ),
    );
  }

  Future<ReminderMutationResult> setReminders(
    Policy policy,
    List<ReminderTimeKind> kinds,
  ) async {
    final previous = state.value ?? PolicyReminderViewState.initial();
    state = AsyncData(previous.copyWith(isMutating: true, messages: const []));
    try {
      final currentKinds = previous.reminders
          .where(
              (reminder) => reminder.status == PolicyReminderStatus.scheduled)
          .map((reminder) => reminder.timeKind)
          .toSet();
      final nextKinds = kinds.toSet();

      final toRemove = currentKinds.difference(nextKinds);

      for (final reminder in previous.reminders) {
        if (toRemove.contains(reminder.timeKind)) {
          await _service.cancelReminder(reminder.reminderId);
        }
      }

      final result = await _service.createRemindersForPolicy(
        policy,
        nextKinds.toList(),
      );

      final current = [
        ...result.reminders,
      ]..sort((a, b) => a.scheduledAt.compareTo(b.scheduledAt));

      state = AsyncData(
        previous.copyWith(
          reminders: current,
          isMutating: false,
          messages: _messagesForResult(result),
        ),
      );
      return result;
    } catch (e, st) {
      await load();
      final reloaded = state.value ?? previous;
      state = AsyncData(
        reloaded.copyWith(
          isMutating: false,
          messages: ['알림을 설정하지 못했어요. 잠시 후 다시 시도해 주세요.'],
        ),
      );
      print('PolicyReminderController.setReminders failed: $e\n$st');
      return const ReminderMutationResult(reminders: [], failures: []);
    }
  }

  Future<void> removeReminder(String reminderId) async {
    final previous = state.value ?? PolicyReminderViewState.initial();
    state = AsyncData(previous.copyWith(isMutating: true));
    try {
      await _service.cancelReminder(reminderId);
      final current = [
        for (final reminder in previous.reminders)
          if (reminder.reminderId != reminderId) reminder,
      ]..sort((a, b) => a.scheduledAt.compareTo(b.scheduledAt));
      state = AsyncData(
        previous.copyWith(
          reminders: current,
          isMutating: false,
          messages: const [],
        ),
      );
    } catch (e, st) {
      state = AsyncData(
        previous.copyWith(
          isMutating: false,
          messages: ['알림을 취소하지 못했어요. 잠시 후 다시 시도해 주세요.'],
        ),
      );
      print('PolicyReminderController.removeReminder failed: $e\n$st');
    }
  }

  Future<void> cancelAll() async {
    final previous = state.value ?? PolicyReminderViewState.initial();
    state = AsyncData(previous.copyWith(isMutating: true));
    try {
      await _service.cancelAllByPolicy(policyId);
      state = AsyncData(
        previous.copyWith(
          reminders: const [],
          isMutating: false,
          messages: const [],
        ),
      );
    } catch (e, st) {
      state = AsyncData(
        previous.copyWith(
          isMutating: false,
          messages: ['모든 알림을 취소하지 못했어요. 잠시 후 다시 시도해 주세요.'],
        ),
      );
      print('PolicyReminderController.cancelAll failed: $e\n$st');
    }
  }

  void clearMessages() {
    state = state.whenData(
      (viewState) => viewState.copyWith(messages: const []),
    );
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
    switch (failure.type) {
      case ScheduleFailureType.permissionDenied:
        return '알림 권한이 꺼져 있어 예약에 실패했어요. 설정에서 권한을 허용해주세요.';
      case ScheduleFailureType.invalidDate:
        if (failure.message.isNotEmpty) {
          return failure.message;
        }
        return '이미 지난 시각에는 알림을 설정할 수 없습니다.';
      case ScheduleFailureType.gatewayError:
      case ScheduleFailureType.idCollision:
      case ScheduleFailureType.unknown:
        if (failure.message.isNotEmpty) {
          return failure.message;
        }
        return '알 수 없는 이유로 알림을 예약하지 못했어요. 잠시 후 다시 시도해주세요.';
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

    if (result.reminders.isEmpty) {
      return const ['알림을 예약하지 못했어요. 잠시 후 다시 시도해주세요.'];
    }

    return const [];
  }
}
