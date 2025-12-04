class ScheduleResult {
  const ScheduleResult.success({
    this.localNotificationId,
    this.scheduledAt,
    this.isDuplicate = false,
  })  : success = true,
        failure = null;

  const ScheduleResult.failure(
    this.failure, {
    this.isDuplicate = false,
  })  : success = false,
        localNotificationId = null,
        scheduledAt = null;

  final bool success;
  final ScheduleFailure? failure;
  final String? localNotificationId;
  final DateTime? scheduledAt;
  final bool isDuplicate;
}

enum ScheduleFailureType {
  invalidDate,
  permissionDenied,
  gatewayError,
  idCollision,
  unknown,
}

class ScheduleFailure {
  const ScheduleFailure({
    required this.type,
    required this.message,
  });

  final ScheduleFailureType type;
  final String message;
}
