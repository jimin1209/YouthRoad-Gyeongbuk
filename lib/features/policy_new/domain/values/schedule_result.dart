class ScheduleResult {
  ScheduleResult.success({
    this.localNotificationId,
    this.scheduledAt,
    this.isDuplicate = false,
  })  : success = true,
        failure = null;

  ScheduleResult.failure(
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

enum ScheduleFailureCode {
  permissionDenied('E_PERMISSION_DENIED'),
  pastTime('E_PAST_TIME'),
  invalidPolicy('E_INVALID_POLICY'),
  internalException('E_INTERNAL_EXCEPTION');

  const ScheduleFailureCode(this.label);

  final String label;
}

class ScheduleFailure {
  const ScheduleFailure({
    required this.type,
    required this.message,
    this.code,
  });

  final ScheduleFailureType type;
  final String message;
  final ScheduleFailureCode? code;
}
