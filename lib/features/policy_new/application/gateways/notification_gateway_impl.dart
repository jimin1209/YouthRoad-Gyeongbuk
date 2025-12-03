import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../domain/entities/policy_reminder.dart';
import 'notification_gateway.dart';

class FlutterLocalNotificationGateway implements NotificationGateway {
  FlutterLocalNotificationGateway({
    FlutterLocalNotificationsPlugin? plugin,
  }) : _plugin = plugin ?? FlutterLocalNotificationsPlugin() {
    _initialization = _initializePlugin();
  }

  final FlutterLocalNotificationsPlugin _plugin;
  late final Future<void> _initialization;

  static const _channelId = 'policy_reminder_channel';
  static const _channelName = '정책 신청 알림';
  static const _channelDescription = '정책 신청 마감 전에 알려드려요';

  Future<void> _initializePlugin() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const darwinSettings = DarwinInitializationSettings();

    await _plugin.initialize(
      const InitializationSettings(
        android: androidSettings,
        iOS: darwinSettings,
      ),
    );
  }

  Future<bool> _ensurePermissions() async {
    final androidImpl = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    final androidEnabled = await androidImpl?.areNotificationsEnabled();
    if (androidEnabled == false) {
      final granted = await androidImpl?.requestNotificationsPermission();
      if (granted == false) {
        return false;
      }
    } else {
      await androidImpl?.requestNotificationsPermission();
    }

    final darwinImpl =
        _plugin.resolvePlatformSpecificImplementation<DarwinFlutterLocalNotificationsPlugin>();
    await darwinImpl?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );

    return true;
  }

  NotificationDetails _notificationDetails() {
    const androidDetails = AndroidNotificationDetails(
      _channelId,
      _channelName,
      channelDescription: _channelDescription,
      importance: Importance.max,
      priority: Priority.high,
    );

    const darwinDetails = DarwinNotificationDetails();

    return const NotificationDetails(
      android: androidDetails,
      iOS: darwinDetails,
    );
  }

  int _notificationId(String reminderId) {
    return reminderId.hashCode & 0x7fffffff;
  }

  @override
  Future<void> scheduleReminder(PolicyReminder reminder) async {
    await _initialization;
    final hasPermission = await _ensurePermissions();
    if (!hasPermission) {
      return;
    }

    final scheduledLocal = reminder.scheduledAt.toLocal();
    if (scheduledLocal.isBefore(DateTime.now())) {
      return;
    }

    final notificationId = _notificationId(reminder.reminderId);
    await _plugin.cancel(notificationId);

    await _plugin.schedule(
      notificationId,
      '신청 알림: ${reminder.timeKind.label}',
      '정책 ID ${reminder.policyId} 신청 마감 전에 확인해 주세요.',
      scheduledLocal,
      _notificationDetails(),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  @override
  Future<void> cancelReminder(String reminderId) async {
    await _initialization;
    await _plugin.cancel(_notificationId(reminderId));
  }
}
