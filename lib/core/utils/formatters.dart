String joinListParam(List<String> values) {
  return values.where((v) => v.trim().isNotEmpty).join(',');
}

String formatDateRange(String? start, String? end) {
  if ((start == null || start.isEmpty) && (end == null || end.isEmpty)) {
    return '기간 정보 없음';
  }
  if (start == null || start.isEmpty) {
    return '~ $end';
  }
  if (end == null || end.isEmpty) {
    return '$start ~';
  }
  return '$start ~ $end';
}
