import 'dart:convert';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

import '../../domain/entities/policy_reminder.dart';
import '../../domain/utils/reminder_id_util.dart';
import '../../domain/utils/reminder_time_util.dart';
import '../../domain/values/reminder_time_kind.dart';
import '../../domain/values/schedule_result.dart';
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

  Future<void> _initializePlugin() async {
    _initializeTimeZones();

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const darwinSettings = DarwinInitializationSettings();

    await _plugin.initialize(
      const InitializationSettings(
        android: androidSettings,
        iOS: darwinSettings,
      ),
    );
  }

  void _initializeTimeZones() {
    tzdata.initializeTimeZones();
    try {
      final timeZoneName = DateTime.now().timeZoneName;
      tz.setLocalLocation(tz.getLocation(timeZoneName));
    } catch (_) {
      tz.setLocalLocation(tz.getLocation('Asia/Seoul'));
    }
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
        _plugin.resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>();
    await darwinImpl?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );

    return true;
  }

  int _notificationId(String reminderId) {
    return ReminderIdUtil.toNotificationId(reminderId);
  }

  String _buildPayload(PolicyReminder reminder) {
    return jsonEncode({
      'reminderId': reminder.reminderId,
      'policyId': reminder.policyId,
      'timeKind': reminder.timeKind.name,
    });
  }

  String? _policyIdFromPayload(String? payload) {
    if (payload == null) return null;
    try {
      final decoded = jsonDecode(payload) as Map<String, dynamic>;
      return decoded['policyId'] as String?;
    } catch (_) {
      return null;
    }
  }

  String? _reminderIdFromPayload(String? payload) {
    if (payload == null) return null;
    try {
      final decoded = jsonDecode(payload) as Map<String, dynamic>;
      return decoded['reminderId'] as String?;
    } catch (_) {
      return null;
    }
  }

  @override
  Future<ScheduleResult> scheduleReminder(PolicyReminder reminder) async {
    await _initialization;
    final pending = await _plugin.pendingNotificationRequests();
    final notificationId = _notificationId(reminder.reminderId);
    final hadExisting = pending.any((request) => request.id == notificationId);
    final hasPermission = await _ensurePermissions();
    if (!hasPermission) {
      return const ScheduleResult.failure(
        ScheduleFailure(
          type: ScheduleFailureType.permissionDenied,
          message: 'Notification permission denied',
        ),
        isDuplicate: hadExisting,
      );
    }

    final scheduledLocal = ReminderTimeUtil.toUtc(reminder.scheduledAt).toLocal();
    if (scheduledLocal.isBefore(DateTime.now())) {
      return const ScheduleResult.failure(
        ScheduleFailure(
          type: ScheduleFailureType.invalidDate,
          message: 'Scheduled time is already in the past',
        ),
        isDuplicate: hadExisting,
      );
    }

    try {
      await _plugin.cancel(notificationId);

      final notificationTitle =
          '[${reminder.policyTitleSnapshot ?? '정책 신청'}] ${reminder.timeKind.label}';
      final formattedTime = DateFormat('M월 d일 a h:mm', 'ko_KR').format(scheduledLocal);
      final notificationBody =
          '${reminder.policyTitleSnapshot ?? reminder.policyId} 마감 ${formattedTime} 전에 신청을 완료해 주세요.';

      await _plugin.zonedSchedule(
        notificationId,
        notificationTitle,
        notificationBody,
        tz.TZDateTime.from(scheduledLocal, tz.local),
        _notificationDetails(),
        payload: _buildPayload(reminder),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );
    } catch (error) {
      return ScheduleResult.failure(
        ScheduleFailure(
          type: ScheduleFailureType.gatewayError,
          message: 'Failed to schedule notification: $error',
        ),
      );
    }

    return ScheduleResult.success(
      localNotificationId: notificationId.toString(),
      scheduledAt: reminder.scheduledAt,
      isDuplicate: hadExisting,
    );
  }

  @override
  Future<ScheduleResult> cancelReminder(String reminderId) async {
    await _initialization;
    try {
      await _plugin.cancel(_notificationId(reminderId));
    } catch (error) {
      return ScheduleResult.failure(
        ScheduleFailure(
          type: ScheduleFailureType.gatewayError,
          message: 'Failed to cancel notification: $error',
        ),
      );
    }
    return const ScheduleResult.success();
  }

  @override
  Future<ScheduleResult> cancelAllForPolicy(String policyId) async {
    await _initialization;
    try {
      final pending = await _plugin.pendingNotificationRequests();
      for (final request in pending) {
        final payloadPolicyId = _policyIdFromPayload(request.payload);
        if (payloadPolicyId == policyId) {
          await _plugin.cancel(request.id);
        }
      }
    } catch (error) {
      return ScheduleResult.failure(
        ScheduleFailure(
          type: ScheduleFailureType.gatewayError,
          message: 'Failed to cancel notifications: $error',
        ),
      );
    }
    return const ScheduleResult.success();
  }

  @override
  Future<Set<String>> listScheduledReminderIds() async {
    await _initialization;
    try {
      final pending = await _plugin.pendingNotificationRequests();
      final ids = <String>{};
      for (final request in pending) {
        final reminderId = _reminderIdFromPayload(request.payload);
        if (reminderId != null) {
          ids.add(reminderId);
        }
      }
      return ids;
    } catch (_) {
      return {};
    }
  }

  @override
  Future<bool> refreshEnvironment() async {
    await _initialization;
    _initializeTimeZones();
    return _ensurePermissions();
  }
}
