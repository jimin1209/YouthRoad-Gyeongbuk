import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../policy/model/policy_item.dart';
import '../service/notification_service.dart';

class NotificationScheduler {
  NotificationScheduler(this._ref);

  final Ref _ref;

  Future<void> scheduleForPolicy(PolicyItem item) async {
    final service = _ref.read(notificationServiceProvider);
    await service.init();

    // 마감 7일 전
    final end = item.endDate;
    if (end != null && end.isNotEmpty) {
      try {
        final date = DateTime.parse(end).subtract(const Duration(days: 7));
        await service.schedule(
          id: item.id.hashCode,
          title: '${item.title ?? '정책'} 마감 임박',
          body: '마감일: ${item.endDate}',
          when: date,
        );
      } catch (_) {}
    }
  }
}

final notificationSchedulerProvider = Provider<NotificationScheduler>(
  (ref) => NotificationScheduler(ref),
);
