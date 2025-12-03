import 'package:timezone/timezone.dart' as tz;

/// Utility helpers for converting reminder times between UTC and device zones.
class ReminderTimeUtil {
  const ReminderTimeUtil._();

  /// Normalizes the given [time] to UTC.
  static DateTime toUtc(DateTime time) {
    return time.isUtc ? time : time.toUtc();
  }

  /// Converts a UTC [time] into a [tz.TZDateTime] using the provided
  /// [location]. If no location is provided, [tz.local] is used.
  static tz.TZDateTime toDeviceZone(
    DateTime time, {
    tz.Location? location,
  }) {
    final targetLocation = location ?? tz.local;
    return tz.TZDateTime.from(time.toUtc(), targetLocation);
  }
}
