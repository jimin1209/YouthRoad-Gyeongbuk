import 'dart:convert';

import 'package:crypto/crypto.dart';

import '../values/reminder_time_kind.dart';

/// Utility functions for building and parsing reminder identifiers.
class ReminderIdUtil {
  const ReminderIdUtil._();

  /// Builds a stable reminder id based on [policyId] and [timeKind].
  ///
  /// When [timeKind] is [ReminderTimeKind.dayOf], [ReminderTimeKind.day1],
  /// [ReminderTimeKind.day3], or [ReminderTimeKind.day7], the id is
  /// formatted as `policyId::timeKind`.
  ///
  /// When a [customTimeUtc] is provided, the id is formatted as
  /// `policyId::custom::yyyyMMddHHmm` where the timestamp is normalized to
  /// UTC to avoid ambiguity.
  static String buildReminderId(
    String policyId,
    ReminderTimeKind timeKind, {
    DateTime? customTimeUtc,
  }) {
    if (customTimeUtc != null) {
      final utc = customTimeUtc.toUtc();
      final formatted = _twoDigits(utc.year, 4) +
          _twoDigits(utc.month) +
          _twoDigits(utc.day) +
          _twoDigits(utc.hour) +
          _twoDigits(utc.minute);
      return '$policyId::custom::$formatted';
    }

    return '$policyId::${timeKind.name}';
  }

  /// Maps a reminder id string to a stable positive integer notification id.
  static int toNotificationId(String reminderId) {
    final digest = md5.convert(utf8.encode(reminderId)).bytes;
    final value = (digest[0] << 24) |
        (digest[1] << 16) |
        (digest[2] << 8) |
        digest[3];
    return value & 0x7fffffff;
  }

  /// Extracts the policy id component from a reminder id.
  static String parsePolicyId(String reminderId) {
    final parts = reminderId.split('::');
    return parts.first;
  }

  static String _twoDigits(int value, [int minLength = 2]) {
    final padded = value.toString().padLeft(minLength, '0');
    return padded;
  }
}
