enum PolicyEventType {
  cacheCleared,
  favoritesChanged,
  compareListChanged,
  profileUpdated,
  refreshRequested,
  reminderAdded,
  reminderRemoved,
}

class PolicyEvent {
  final PolicyEventType type;
  const PolicyEvent(this.type);
}
