enum PolicyEventType {
  cacheCleared,
  favoritesChanged,
  compareListChanged,
  profileUpdated,
  refreshRequested,
}

class PolicyEvent {
  final PolicyEventType type;
  const PolicyEvent(this.type);
}
