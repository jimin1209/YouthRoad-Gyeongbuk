import 'package:flutter_test/flutter_test.dart';
import 'package:youth_road_app/features/policy_new/application/controllers/policy_event_bus.dart';
import 'package:youth_road_app/features/policy_new/application/gateways/notification_gateway.dart';
import 'package:youth_road_app/features/policy_new/application/services/policy_reminder_scheduler.dart';
import 'package:youth_road_app/features/policy_new/application/services/policy_reminder_service.dart';
import 'package:youth_road_app/features/policy_new/domain/entities/policy.dart';
import 'package:youth_road_app/features/policy_new/domain/entities/policy_reminder.dart';
import 'package:youth_road_app/features/policy_new/domain/repositories/policy_reminder_repository.dart';
import 'package:youth_road_app/features/policy_new/domain/utils/reminder_id_util.dart';
import 'package:youth_road_app/features/policy_new/domain/values/policy_category.dart';
import 'package:youth_road_app/features/policy_new/domain/values/policy_event.dart';
import 'package:youth_road_app/features/policy_new/domain/values/policy_logger.dart';
import 'package:youth_road_app/features/policy_new/domain/values/policy_region.dart';
import 'package:youth_road_app/features/policy_new/domain/values/policy_reminder_status.dart';
import 'package:youth_road_app/features/policy_new/domain/values/reminder_time_kind.dart';
import 'package:youth_road_app/features/policy_new/domain/values/schedule_result.dart';

class InMemoryPolicyReminderRepository implements PolicyReminderRepository {
  final Map<String, PolicyReminder> _storage = {};

  @override
  Future<void> deleteReminderById(String reminderId) async {
    _storage.remove(reminderId);
  }

  @override
  Future<void> deleteRemindersByPolicy(String policyId) async {
    _storage.removeWhere((_, reminder) => reminder.policyId == policyId);
  }

  @override
  Future<List<PolicyReminder>> getAllReminders() async {
    return _storage.values.toList();
  }

  @override
  Future<PolicyReminder?> getReminder(String reminderId) async {
    return _storage[reminderId];
  }

  @override
  Future<List<PolicyReminder>> getRemindersForPolicy(String policyId) async {
    return _storage.values
        .where((reminder) => reminder.policyId == policyId)
        .toList();
  }

  @override
  Future<void> upsertReminder(PolicyReminder reminder) async {
    _storage[reminder.reminderId] = reminder;
  }
}

class FakeNotificationGateway implements NotificationGateway {
  final List<String> scheduledIds = [];
  final List<String> canceledIds = [];
  final Set<String> failReminderIds;
  final Map<String, int> failUntilAttempt;
  final Map<String, int> attempts = {};
  bool environmentReady;
  int refreshCalls = 0;

  FakeNotificationGateway({
    this.failReminderIds = const {},
    this.failUntilAttempt = const {},
    Set<String> initiallyScheduled = const {},
    this.environmentReady = true,
  }) {
    scheduledIds.addAll(initiallyScheduled);
  }

  @override
  Future<ScheduleResult> cancelAllForPolicy(String policyId) async {
    return ScheduleResult.success();
  }

  @override
  Future<ScheduleResult> cancelReminder(String reminderId) async {
    scheduledIds.remove(reminderId);
    canceledIds.add(reminderId);
    return ScheduleResult.success();
  }

  @override
  Future<ScheduleResult> scheduleReminder(PolicyReminder reminder) async {
    attempts.update(reminder.reminderId, (value) => value + 1, ifAbsent: () => 1);
    final failAttempts = failUntilAttempt[reminder.reminderId];
    if (failReminderIds.contains(reminder.reminderId) ||
        (failAttempts != null && (attempts[reminder.reminderId] ?? 0) <= failAttempts)) {
      return ScheduleResult.failure(
        ScheduleFailure(
          type: ScheduleFailureType.gatewayError,
          message: 'forced failure',
        ),
      );
    }
    scheduledIds.add(reminder.reminderId);
    return ScheduleResult.success(scheduledAt: reminder.scheduledAt);
  }

  @override
  Future<Set<String>> listScheduledReminderIds() async {
    return scheduledIds.toSet();
  }

  @override
  Future<bool> refreshEnvironment() async {
    refreshCalls++;
    return environmentReady;
  }
}

class RecordingPolicyEventBus extends PolicyEventBus {
  final List<PolicyEvent> events = [];

  @override
  void emit(PolicyEvent event) {
    events.add(event);
    super.emit(event);
  }
}

class SilentPolicyLogger implements PolicyLogger {
  @override
  void error(String msg, [Object? err, StackTrace? stackTrace]) {}

  @override
  void info(String msg) {}

  @override
  void warn(String msg) {}
}

Policy buildPolicy(DateTime base) {
  return Policy(
    id: 'policy-1',
    title: '테스트 정책',
    summary: 'summary',
    description: 'description',
    region: PolicyRegion.seoul,
    category: PolicyCategory.education,
    tags: const [],
    keywords: const [],
    applicationStartDate: base,
    applicationEndDate: base.add(const Duration(days: 2)),
    announceDate: base.add(const Duration(days: 3)),
    isOnline: true,
    isOffline: false,
    minAge: 0,
    maxAge: 100,
    isForYouth: true,
    incomeCondition: null,
    educationCondition: null,
    employmentCondition: null,
    applyUrl: 'https://example.com',
    attachmentUrl: null,
    institution: 'inst',
    department: 'dept',
    contact: null,
    createdAt: base,
    updatedAt: base,
  );
}

PolicyReminder buildReminder({
  required String reminderId,
  required DateTime scheduledAt,
  required DateTime now,
  PolicyReminderStatus status = PolicyReminderStatus.scheduled,
  ReminderTimeKind timeKind = ReminderTimeKind.day1,
}) {
  return PolicyReminder(
    reminderId: reminderId,
    policyId: 'policy-1',
    scheduledAt: scheduledAt,
    createdAt: now,
    updatedAt: now,
    timeKind: timeKind,
    status: status,
    isActive: status == PolicyReminderStatus.scheduled,
    policyTitleSnapshot: '테스트 정책',
  );
}

void main() {
  final scheduler = PolicyReminderScheduler();
  final logger = SilentPolicyLogger();

  test('syncScheduledReminders marks fired reminders and reschedules future ones',
      () async {
    final now = DateTime.utc(2024, 1, 1, 12, 0, 0);
    final repository = InMemoryPolicyReminderRepository();
    final gateway = FakeNotificationGateway();
    final bus = RecordingPolicyEventBus();
    final service = PolicyReminderService(
      repository: repository,
      notificationGateway: gateway,
      eventBus: bus,
      scheduler: scheduler,
      logger: logger,
      now: () => now,
    );

    final firedId = ReminderIdUtil.buildReminderId('policy-1', ReminderTimeKind.day1);
    final futureId = ReminderIdUtil.buildReminderId('policy-1', ReminderTimeKind.day3);
    repository
      ..upsertReminder(
        buildReminder(
          reminderId: firedId,
          scheduledAt: now.subtract(const Duration(minutes: 5)),
          now: now,
        ),
      )
      ..upsertReminder(
        buildReminder(
          reminderId: futureId,
          scheduledAt: now.add(const Duration(hours: 1)),
          now: now,
        ),
      );

    final report = await service.syncScheduledReminders();

    final fired = await repository.getReminder(firedId);
    expect(fired?.status, PolicyReminderStatus.fired);
    expect(fired?.isActive, isFalse);

    final futureReminder = await repository.getReminder(futureId);
    expect(futureReminder?.status, PolicyReminderStatus.scheduled);

    expect(gateway.canceledIds, contains(firedId));
    expect(gateway.scheduledIds, contains(futureId));
    expect(bus.events.where((e) => e.type == PolicyEventType.reminderBulkUpdated),
        isNotEmpty);
    expect(report.firedCount, 1);
    expect(report.rescheduledCount, 1);
    expect(report.expiredCount, 0);
    expect(report.orphanedPlatformReminders, 0);
    expect(report.restoredMissingReminders, 1);
  });

  test('createRemindersForPolicy rolls back when scheduling fails', () async {
    final now = DateTime.utc(2024, 1, 2, 9, 0, 0);
    final repository = InMemoryPolicyReminderRepository();
    final firedId = ReminderIdUtil.buildReminderId('policy-1', ReminderTimeKind.day1);
    final gateway = FakeNotificationGateway(failReminderIds: {firedId});
    final bus = RecordingPolicyEventBus();
    final service = PolicyReminderService(
      repository: repository,
      notificationGateway: gateway,
      eventBus: bus,
      scheduler: scheduler,
      logger: logger,
      now: () => now,
    );

    final policy = buildPolicy(now.add(const Duration(days: 1)));
    final result = await service.createRemindersForPolicy(policy, [ReminderTimeKind.day1]);

    expect(result.reminders, isEmpty);
    expect(result.failures, isNotEmpty);
    expect(await repository.getAllReminders(), isEmpty);
    expect(bus.events, isEmpty);
  });

  test('cancelReminder marks reminder canceled and emits event', () async {
    final now = DateTime.utc(2024, 1, 3, 8, 0, 0);
    final repository = InMemoryPolicyReminderRepository();
    final gateway = FakeNotificationGateway();
    final bus = RecordingPolicyEventBus();
    final service = PolicyReminderService(
      repository: repository,
      notificationGateway: gateway,
      eventBus: bus,
      scheduler: scheduler,
      logger: logger,
      now: () => now,
    );

    final reminderId = ReminderIdUtil.buildReminderId('policy-1', ReminderTimeKind.day1);
    final reminder = buildReminder(
      reminderId: reminderId,
      scheduledAt: now.add(const Duration(hours: 4)),
      now: now,
    );
    await repository.upsertReminder(reminder);

    await service.cancelReminder(reminderId);

    final updated = await repository.getReminder(reminderId);
    expect(updated?.status, PolicyReminderStatus.canceled);
    expect(updated?.isActive, isFalse);
    expect(gateway.canceledIds, contains(reminderId));
    expect(bus.events.where((e) => e.policyId == 'policy-1'), isNotEmpty);
  });

  test('createRemindersForPolicy retries transient scheduling errors', () async {
    final now = DateTime.utc(2024, 1, 4, 10, 0, 0);
    final repository = InMemoryPolicyReminderRepository();
    final reminderId =
        ReminderIdUtil.buildReminderId('policy-1', ReminderTimeKind.day1);
    final gateway = FakeNotificationGateway(failUntilAttempt: {reminderId: 1});
    final bus = RecordingPolicyEventBus();
    final service = PolicyReminderService(
      repository: repository,
      notificationGateway: gateway,
      eventBus: bus,
      scheduler: scheduler,
      logger: logger,
      now: () => now,
      wait: (_) async {},
    );

    final policy = buildPolicy(now.add(const Duration(days: 2)));
    final result =
        await service.createRemindersForPolicy(policy, [ReminderTimeKind.day1]);

    expect(result.reminders, hasLength(1));
    expect(result.failures, isEmpty);
    expect(gateway.attempts[reminderId], 2);
  });

  test('syncScheduledReminders cancels platform orphans and restores missing',
      () async {
    final now = DateTime.utc(2024, 1, 5, 9, 0, 0);
    final repository = InMemoryPolicyReminderRepository();
    final reminderId =
        ReminderIdUtil.buildReminderId('policy-1', ReminderTimeKind.day1);
    final gateway =
        FakeNotificationGateway(initiallyScheduled: {'orphan-1'}, failUntilAttempt: {});
    final bus = RecordingPolicyEventBus();
    final service = PolicyReminderService(
      repository: repository,
      notificationGateway: gateway,
      eventBus: bus,
      scheduler: scheduler,
      logger: logger,
      now: () => now,
      wait: (_) async {},
    );

    await repository.upsertReminder(
      buildReminder(
        reminderId: reminderId,
        scheduledAt: now.add(const Duration(hours: 2)),
        now: now,
      ),
    );

    final report = await service.syncScheduledReminders();

    expect(gateway.canceledIds, contains('orphan-1'));
    expect(gateway.scheduledIds, contains(reminderId));
    expect(report.orphanedPlatformReminders, 1);
    expect(report.restoredMissingReminders, 1);
    expect(report.rescheduledCount, 1);
    expect(bus.events.where((e) => e.type == PolicyEventType.reminderBulkUpdated),
        isNotEmpty);
  });

  test('createRemindersForPolicy returns failures when environment not ready',
      () async {
    final now = DateTime.utc(2024, 1, 6, 9, 0, 0);
    final repository = InMemoryPolicyReminderRepository();
    final gateway = FakeNotificationGateway(environmentReady: false);
    final bus = RecordingPolicyEventBus();
    final service = PolicyReminderService(
      repository: repository,
      notificationGateway: gateway,
      eventBus: bus,
      scheduler: scheduler,
      logger: logger,
      now: () => now,
    );

    final policy = buildPolicy(now.add(const Duration(days: 3)));
    final result =
        await service.createRemindersForPolicy(policy, [ReminderTimeKind.day1]);

    expect(result.reminders, isEmpty);
    expect(result.failures, hasLength(1));
    expect(result.failures.first.failure.type,
        ScheduleFailureType.permissionDenied);
    expect(gateway.refreshCalls, 1);
    expect(bus.events, isEmpty);
  });

  test('syncScheduledReminders surfaces environment readiness failures', () async {
    final now = DateTime.utc(2024, 1, 7, 8, 0, 0);
    final repository = InMemoryPolicyReminderRepository();
    final gateway = FakeNotificationGateway(environmentReady: false);
    final bus = RecordingPolicyEventBus();
    final service = PolicyReminderService(
      repository: repository,
      notificationGateway: gateway,
      eventBus: bus,
      scheduler: scheduler,
      logger: logger,
      now: () => now,
    );

    final report = await service.syncScheduledReminders();

    expect(report.hasFailure, isTrue);
    expect(report.failures.first.type, ScheduleFailureType.permissionDenied);
    expect(report.rescheduledCount, 0);
    expect(report.expiredCount, 0);
    expect(report.firedCount, 0);
    expect(bus.events, isEmpty);
  });
}
