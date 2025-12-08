/// 정책 진행 상태 분류를 위한 상태값.
enum PolicyActiveState {
  active,
  closingSoon,
  closed,
}

/// 정책 마감일을 기준으로 진행 상태를 계산한다.
///
/// 규칙:
/// - endDate가 오늘보다 이전이면 [PolicyActiveState.closed]
/// - 오늘을 포함해 D-Day가 0~3일이면 [PolicyActiveState.closingSoon]
/// - 그 외에는 [PolicyActiveState.active]
PolicyActiveState resolvePolicyState(DateTime now, DateTime endDate) {
  final normalizedNow = DateTime.utc(now.year, now.month, now.day);
  final normalizedEnd = DateTime.utc(endDate.year, endDate.month, endDate.day);

  if (normalizedEnd.isBefore(normalizedNow)) {
    return PolicyActiveState.closed;
  }

  final days = normalizedEnd.difference(normalizedNow).inDays;
  if (days >= 0 && days <= 3) {
    return PolicyActiveState.closingSoon;
  }

  return PolicyActiveState.active;
}
