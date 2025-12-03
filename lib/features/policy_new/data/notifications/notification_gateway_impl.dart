import 'package:flutter/foundation.dart';

import '../../domain/entities/policy_reminder.dart';
import 'notification_gateway.dart';

class LocalNotificationGateway implements NotificationGateway {
  @override
  Future<void> cancelAllForPolicy(String policyId) async {
    debugPrint('[Reminder][Gateway] cancelAll policy=$policyId');
  }

  @override
  Future<void> cancelReminder(String reminderId) async {
    debugPrint('[Reminder][Gateway] cancel reminder=$reminderId');
  }

  @override
  Future<void> scheduleReminder(PolicyReminder reminder) async {
    debugPrint(
      '[Reminder][Gateway] schedule id=${reminder.id} policy=${reminder.policyId} at=${reminder.remindAt.toIso8601String()}',
    );
  }
}
