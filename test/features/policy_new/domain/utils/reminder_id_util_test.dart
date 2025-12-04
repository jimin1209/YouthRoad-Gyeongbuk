import 'package:flutter_test/flutter_test.dart';
import 'package:youth_road_app/features/policy_new/domain/utils/reminder_id_util.dart';
import 'package:youth_road_app/features/policy_new/domain/values/reminder_time_kind.dart';

void main() {
  group('ReminderIdUtil', () {
    test('builds id for standard kinds', () {
      expect(
        ReminderIdUtil.buildReminderId('policy-1', ReminderTimeKind.day1),
        'policy-1::day1',
      );
      expect(
        ReminderIdUtil.buildReminderId('policy-1', ReminderTimeKind.day7),
        'policy-1::day7',
      );
    });

    test('builds id for custom time using UTC normalization', () {
      final customTime = DateTime.utc(2024, 12, 31, 23, 45);
      final id = ReminderIdUtil.buildReminderId(
        'policy-2',
        ReminderTimeKind.dayOf,
        customTimeUtc: customTime,
      );

      expect(id, 'policy-2::custom::202412312345');
    });

    test('maps reminder id to stable notification id', () {
      final id1 = ReminderIdUtil.buildReminderId('p1', ReminderTimeKind.day1);
      final id2 = ReminderIdUtil.buildReminderId('p1', ReminderTimeKind.day3);

      final notificationId1 = ReminderIdUtil.toNotificationId(id1);
      final notificationId2 = ReminderIdUtil.toNotificationId(id2);

      expect(notificationId1, greaterThanOrEqualTo(0));
      expect(notificationId2, greaterThanOrEqualTo(0));
      expect(notificationId1, isNot(notificationId2));
      expect(ReminderIdUtil.toNotificationId(id1), notificationId1);
    });

    test('parses policy id from reminder id', () {
      final reminderId =
          ReminderIdUtil.buildReminderId('policy-3', ReminderTimeKind.day7);
      expect(ReminderIdUtil.parsePolicyId(reminderId), 'policy-3');
    });
  });
}
