import 'package:intl/intl.dart';

class PolicyDateFormatter {
  PolicyDateFormatter._();

  static final DateFormat _dateWithWeekday =
      DateFormat('yyyy.MM.dd (E)', 'ko');
  static final DateFormat _dateTimeWithWeekday =
      DateFormat('yyyy.MM.dd (E) a h:mm', 'ko');

  static String formatDate(DateTime date) {
    return _dateWithWeekday.format(date.toLocal());
  }

  static String formatDateTime(DateTime date) {
    return _dateTimeWithWeekday.format(date.toLocal());
  }

  static String formatRange({DateTime? start, DateTime? end}) {
    if (start == null && end == null) {
      return '일정 미확정';
    }
    if (start != null && end == null) {
      return '신청 시작 · ${formatDate(start)}';
    }
    if (start == null && end != null) {
      return '신청 마감 · ${formatDate(end)}';
    }
    return '${formatDate(start!)} ~ ${formatDate(end!)}';
  }

  static String buildDeadlineText({
    required DateTime? end,
    String prefix = '신청 마감',
    String? dDayLabel,
  }) {
    if (end == null) return '$prefix 정보가 없습니다.';
    final dDayPart = dDayLabel != null ? '$dDayLabel · ' : '';
    return '$prefix $dDayPart${formatDate(end)}';
  }
}
