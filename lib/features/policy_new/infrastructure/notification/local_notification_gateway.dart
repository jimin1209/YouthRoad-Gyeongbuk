import 'package:flutter/foundation.dart';

import '../../domain/entities/policy_reminder.dart';
import 'notification_gateway.dart';

class LocalNotificationGateway implements NotificationGateway {
  @override
  Future<void> cancelReminder(String reminderId) async {
    debugPrint('Cancel reminder: $reminderId');
  }

  @override
  Future<void> scheduleReminder(PolicyReminder reminder) async {
    debugPrint('Schedule reminder ${reminder.id} at ${reminder.scheduledAt}');
  }
}
