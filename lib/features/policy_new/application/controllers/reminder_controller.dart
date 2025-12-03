import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/policy_reminder.dart';
import '../../domain/repositories/reminder_repository.dart';
import '../../domain/values/policy_event.dart';
import 'policy_event_bus.dart';

class ReminderState {
  const ReminderState({
    this.reminders = const [],
    this.isLoading = false,
  });

  final List<PolicyReminder> reminders;
  final bool isLoading;

  ReminderState copyWith({
    List<PolicyReminder>? reminders,
    bool? isLoading,
  }) {
    return ReminderState(
      reminders: reminders ?? this.reminders,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class ReminderController extends StateNotifier<ReminderState> {
  ReminderController({
    required this.repository,
    required this.eventBus,
  }) : super(const ReminderState());

  final ReminderRepository repository;
  final PolicyEventBus eventBus;

  Future<void> loadReminders() async {
    state = state.copyWith(isLoading: true);
    final reminders = await repository.getAllReminders();
    state = state.copyWith(reminders: reminders, isLoading: false);
  }

  Future<void> addReminder(PolicyReminder reminder) async {
    await repository.saveReminder(reminder);
    await loadReminders();
    eventBus.emit(const PolicyEvent(PolicyEventType.reminderAdded));
  }

  Future<void> removeReminder(String reminderId) async {
    await repository.deleteReminder(reminderId);
    await loadReminders();
    eventBus.emit(const PolicyEvent(PolicyEventType.reminderRemoved));
  }

  List<PolicyReminder> remindersForPolicy(String policyId) {
    return state.reminders
        .where((reminder) => reminder.policyId == policyId)
        .toList(growable: false);
  }
}
