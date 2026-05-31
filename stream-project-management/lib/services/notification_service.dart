import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

/// 通知服务
/// 设计文档 5.4：NotificationService - 本地通知、任务到期提醒、协作更新通知
class NotificationService {
  NotificationService._();

  static final NotificationService _instance = NotificationService._();

  factory NotificationService() => _instance;

  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  /// 初始化通知服务
  Future<void> initialize() async {
    tz.initializeTimeZones();

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');

    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );
  }

  /// 通知点击事件处理
  static void _onNotificationTapped(NotificationResponse response) {
    // TODO: 导航到对应页面
    print('Notification tapped: ${response.payload}');
  }

  /// 请求通知权限
  Future<bool> requestPermissions() async {
    final androidGranted = await _notifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission() ??
        false;

    final iosGranted = await _notifications
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        ) ??
        false;

    return androidGranted || iosGranted;
  }

  /// 发送即时通知
  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'ai_opc_channel',
      'AI OPC 通知',
      channelDescription: 'AI OPC 项目管理通知',
      importance: Importance.high,
      priority: Priority.high,
      showWhen: true,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notifications.show(id, title, body, details, payload: payload);
  }

  /// 调度任务到期提醒
  Future<void> scheduleTaskReminder({
    required String taskId,
    required String taskTitle,
    required DateTime dueDate,
  }) async {
    final scheduledDate = tz.TZDateTime.from(dueDate, tz.local);

    // 提前 1 天提醒
    final reminderDate = scheduledDate.subtract(const Duration(days: 1));
    if (reminderDate.isBefore(tz.TZDateTime.now(tz.local))) return;

    await _notifications.zonedSchedule(
      taskId.hashCode,
      '任务即将到期',
      '$taskTitle 将在明天到期',
      reminderDate,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'ai_opc_reminder_channel',
          '任务提醒',
          channelDescription: '任务到期提醒通知',
        ),
        iOS: DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      payload: taskId,
    );

    // 当天提醒
    final sameDayReminder = scheduledDate.subtract(const Duration(hours: 2));
    if (sameDayReminder.isAfter(tz.TZDateTime.now(tz.local))) {
      await _notifications.zonedSchedule(
        taskId.hashCode + 1,
        '任务已到期',
        '$taskTitle 今天到期，请尽快处理',
        sameDayReminder,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'ai_opc_reminder_channel',
            '任务提醒',
          ),
          iOS: DarwinNotificationDetails(),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        payload: taskId,
      );
    }
  }

  /// 取消任务提醒
  Future<void> cancelTaskReminder(String taskId) async {
    await _notifications.cancel(taskId.hashCode);
    await _notifications.cancel(taskId.hashCode + 1);
  }

  /// 发送任务到期通知
  Future<void> notifyTaskDue(String taskTitle) async {
    await showNotification(
      id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title: '任务已到期',
      body: '$taskTitle 已到期，请尽快处理',
      payload: 'task_due',
    );
  }

  /// 发送协作更新通知
  Future<void> notifyCollaborationUpdate({
    required String memberName,
    required String action,
  }) async {
    await showNotification(
      id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title: '协作更新',
      body: '$memberName $action',
      payload: 'collab_update',
    );
  }

  /// 发送项目进度更新通知
  Future<void> notifyProjectProgressChanged(
    String projectId,
    double progress,
  ) async {
    await showNotification(
      id: projectId.hashCode,
      title: '项目进度更新',
      body: '项目进度已更新至 ${(progress * 100).toInt()}%',
      payload: projectId,
    );
  }

  /// 发送 AI 任务完成通知
  Future<void> notifyAITaskCompleted(String taskTitle) async {
    await showNotification(
      id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title: 'AI 任务完成',
      body: '$taskTitle 已由 AI 完成',
      payload: 'ai_task_completed',
    );
  }

  /// 发送同步完成通知
  Future<void> notifySyncCompleted(int syncedCount) async {
    await showNotification(
      id: 'sync_completed'.hashCode,
      title: '同步完成',
      body: '已同步 $syncedCount 项变更',
      payload: 'sync_completed',
    );
  }

  /// 发送同步失败通知
  Future<void> notifySyncFailed(String error) async {
    await showNotification(
      id: 'sync_failed'.hashCode,
      title: '同步失败',
      body: error,
      payload: 'sync_failed',
    );
  }

  /// 获取所有待发送的通知
  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    return _notifications.pendingNotificationRequests();
  }

  /// 取消所有通知
  Future<void> cancelAllNotifications() async {
    await _notifications.cancelAll();
  }
}
