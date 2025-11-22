import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 알림 기능 스텁. 실제 로컬 알림 연동 시 교체 가능.
class NotificationService {
  Future<void> init() async {}

  Future<void> schedule({
    required int id,
    required String title,
    required String body,
    required DateTime when,
  }) async {
    // 실제 알림 예약 구현은 추후 연동
  }
}

final notificationServiceProvider = Provider<NotificationService>((ref) {
  return NotificationService();
});
