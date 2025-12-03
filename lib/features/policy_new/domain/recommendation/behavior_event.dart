enum BehaviorEventType {
  click,
  favorite,
  compare,
}

class BehaviorEvent {
  final String policyId;
  final BehaviorEventType type;
  final DateTime timestamp;

  const BehaviorEvent({
    required this.policyId,
    required this.type,
    required this.timestamp,
  });
}
