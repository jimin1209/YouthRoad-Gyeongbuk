enum PolicyEventType {
  cacheCleared,
  favoritesChanged,
  profileUpdated,
  refreshRequested,
}

class PolicyEvent {
  final PolicyEventType type;
  const PolicyEvent(this.type);
}
