enum PolicyEventType {
  cacheCleared,
  favoritesChanged,
  compareListChanged,
  profileUpdated,
  behaviorChanged,
  refreshRequested,
}

class PolicyEvent {
  final PolicyEventType type;
  const PolicyEvent(this.type);
}
