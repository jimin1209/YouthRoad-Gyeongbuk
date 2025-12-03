import 'package:uuid/uuid.dart';

import '../../domain/entities/policy_reminder.dart';
import '../../domain/repositories/reminder_repository.dart';
import '../../domain/values/reminder_status.dart';
import '../../domain/values/reminder_type.dart';
import '../notifications/notification_gateway.dart';
import '../sources/reminder_local_source.dart';

class ReminderRepositoryImpl implements ReminderRepository {
  ReminderRepositoryImpl({
    required ReminderLocalSource localSource,
    required NotificationGateway notificationGateway,
  })  : _localSource = localSource,
        _notificationGateway = notificationGateway;

  final ReminderLocalSource _localSource;
  final NotificationGateway _notificationGateway;
  final Uuid _uuid = const Uuid();

  @override
  Future<PolicyReminder> createReminder({
    required String policyId,
    required String policyTitle,
    required DateTime remindAt,
    required ReminderType type,
  }) async {
    final reminder = PolicyReminder(
      id: _uuid.v4(),
      policyId: policyId,
      policyTitle: policyTitle,
      remindAt: remindAt,
      type: type,
      status: ReminderStatus.scheduled,
      createdAt: DateTime.now(),
    );

    await _localSource.save(reminder);
    await _notificationGateway.scheduleReminder(reminder);
    return reminder;
  }

  @override
  Future<void> cancelAllForPolicy(String policyId) async {
    await _notificationGateway.cancelAllForPolicy(policyId);
    await _localSource.deleteByPolicy(policyId);
  }

  @override
  Future<void> cancelReminder(String reminderId) async {
    await _notificationGateway.cancelReminder(reminderId);
    await _localSource.updateStatus(reminderId, ReminderStatus.canceled);
  }

  @override
  Future<List<PolicyReminder>> listByPolicy(String policyId) async {
    final all = await _localSource.fetchAll();
    return all.where((r) => r.policyId == policyId).toList()
      ..sort((a, b) => a.remindAt.compareTo(b.remindAt));
  }

  @override
  Future<List<PolicyReminder>> listUpcoming() async {
    final all = await _localSource.fetchAll();
    final now = DateTime.now();
    return all
        .where(
          (r) =>
              r.status == ReminderStatus.scheduled && r.remindAt.isAfter(now),
        )
        .toList()
      ..sort((a, b) => a.remindAt.compareTo(b.remindAt));
  }

  @override
  Future<void> markAsFired(String reminderId) async {
    await _localSource.updateStatus(reminderId, ReminderStatus.fired);
  }

  @override
  Future<void> updateStatus(String reminderId, ReminderStatus status) async {
    await _localSource.updateStatus(reminderId, status);
  }
}
