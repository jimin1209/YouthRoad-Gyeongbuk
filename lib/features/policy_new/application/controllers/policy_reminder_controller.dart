import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/policy.dart';
import '../../domain/entities/policy_reminder.dart';
import '../../domain/values/policy_reminder_status.dart';
import '../../domain/values/reminder_time_kind.dart';
import '../../domain/values/schedule_result.dart';
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
  }) : super(const AsyncData(PolicyReminderViewState(reminders: []))) {
    initialize();
  }

  final Ref ref;
  final String policyId;

  PolicyReminderService get _service => ref.read(policyReminderServiceProvider);

  Future<void> initialize() async {
    await _service.cleanupExpiredReminders();
    await load();
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
      final currentKinds = previous.reminders.map((reminder) => reminder.timeKind).toSet();
      final nextKinds = kinds.toSet();

      final toAdd = nextKinds.difference(currentKinds).toList();
      final toRemove = currentKinds.difference(nextKinds);

      final removed = <PolicyReminder>[];
      for (final reminder in previous.reminders) {
        if (toRemove.contains(reminder.timeKind)) {
          await _service.cancelReminder(reminder.reminderId);
          removed.add(reminder);
        }
      }

      final result = await _service.createRemindersForPolicy(policy, toAdd);

      final current = [
        for (final reminder in previous.reminders)
          if (!removed.contains(reminder)) reminder,
        ...result.reminders,
      ]
        ..sort((a, b) => a.scheduledAt.compareTo(b.scheduledAt));

      state = AsyncData(
        previous.copyWith(
          reminders: current,
          isMutating: false,
          messages: _messagesForFailures(result.failures),
        ),
      );
      return result;
    } catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
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
      ]
        ..sort((a, b) => a.scheduledAt.compareTo(b.scheduledAt));
      state = AsyncData(
        previous.copyWith(
          reminders: current,
          isMutating: false,
          messages: const [],
        ),
      );
    } catch (e, st) {
      state = AsyncError(e, st);
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
      state = AsyncError(e, st);
    }
  }

  PolicyReminderStatus? currentStatus() {
    return state.maybeWhen(
      data: (viewState) {
        if (viewState.reminders.isEmpty) return null;
        final sorted = [...viewState.reminders]
          ..sort((a, b) => a.scheduledAt.compareTo(b.scheduledAt));
        return sorted.first.status;
      },
      orElse: () => null,
    );
  }

  List<String> _messagesForFailures(List<ReminderMutationFailure> failures) {
    return failures.map((failure) {
      switch (failure.failure.type) {
        case ScheduleFailureType.permissionDenied:
          return '알림 권한이 꺼져 있어 예약에 실패했어요. 설정에서 권한을 허용해 주세요.';
        case ScheduleFailureType.invalidDate:
          return '이미 지난 시각에는 알림을 설정할 수 없습니다.';
        case ScheduleFailureType.gatewayError:
        case ScheduleFailureType.idCollision:
        case ScheduleFailureType.unknown:
          if (failure.failure.message.isNotEmpty) {
            return failure.failure.message;
          }
          return '알 수 없는 이유로 알림을 예약하지 못했습니다. 잠시 후 다시 시도해 주세요.';
      }
    }).toList();
  }
}
