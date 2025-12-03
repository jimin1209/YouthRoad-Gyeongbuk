enum PolicyEventType {
  cacheCleared,
  favoritesChanged,
  compareListChanged,
  profileUpdated,
  refreshRequested,
  reminderChanged,
  reminderBulkUpdated,
}

class PolicyEvent {
  final PolicyEventType type;
  final String? policyId;

  const PolicyEvent(this.type, {this.policyId});
}
