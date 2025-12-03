enum PolicyEventType {
  cacheCleared,
  favoritesChanged,
  compareListChanged,
  profileUpdated,
  refreshRequested,
  reminderCreated,
  reminderCanceled,
  reminderFired,
}

class PolicyEvent {
  final PolicyEventType type;
  final String? policyId;
  final String? reminderId;

  const PolicyEvent(
    this.type, {
    this.policyId,
    this.reminderId,
  });
}
