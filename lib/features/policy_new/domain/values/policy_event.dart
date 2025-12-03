import 'policy_reminder_status.dart';

enum PolicyEventType {
  cacheCleared,
  favoritesChanged,
  compareListChanged,
  profileUpdated,
  refreshRequested,
  reminderChanged,
}

class PolicyEvent {
  final PolicyEventType type;
  final String? policyId;
  final PolicyReminderStatus? reminderStatus;

  const PolicyEvent(
    this.type, {
    this.policyId,
    this.reminderStatus,
  });
}
