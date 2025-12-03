import 'package:flutter_test/flutter_test.dart';
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;
import 'package:youth_road_app/features/policy_new/domain/utils/reminder_time_util.dart';

void main() {
  setUpAll(() {
    tzdata.initializeTimeZones();
  });

  group('ReminderTimeUtil', () {
    test('converts local time to UTC', () {
      final kst = tz.getLocation('Asia/Seoul');
      final localTime = tz.TZDateTime(kst, 2024, 1, 1, 12, 0);

      final utc = ReminderTimeUtil.toUtc(localTime);

      expect(utc.isUtc, isTrue);
      expect(utc, DateTime.utc(2024, 1, 1, 3, 0));
    });

    test('returns unchanged when already UTC', () {
      final utcNow = DateTime.utc(2024, 6, 1, 10, 30);

      final normalized = ReminderTimeUtil.toUtc(utcNow);

      expect(identical(normalized, utcNow), isTrue);
    });

    test('converts UTC to device timezone', () {
      final ny = tz.getLocation('America/New_York');
      final utcTime = DateTime.utc(2024, 3, 10, 6, 0);

      final localized = ReminderTimeUtil.toDeviceZone(utcTime, location: ny);

      expect(localized.location, ny);
      expect(localized.year, 2024);
      expect(localized.month, 3);
      expect(localized.day, 10);
      expect(localized.hour, 1);
      expect(localized.minute, 0);
    });
  });
}
