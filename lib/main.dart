import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';

import 'constants/themes.dart';
import 'screens/main_navigation_screen.dart';

final FlutterLocalNotificationsPlugin notificationsPlugin =
FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();
  tz.setLocalLocation(tz.getLocation('Asia/Seoul'));

  const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
  const initSettings = InitializationSettings(android: androidSettings);

  await notificationsPlugin.initialize(initSettings);

  runApp(const ProviderScope(child: EZSajuApp()));
}

class EZSajuApp extends StatefulWidget {
  const EZSajuApp({super.key});

  @override
  State<EZSajuApp> createState() => _EZSajuAppState();
}

class _EZSajuAppState extends State<EZSajuApp> {
  @override
  void initState() {
    super.initState();
    _requestNotificationPermission().then((_) {
      _scheduleDailyNotifications();
    });
  }

  Future<void> _requestNotificationPermission() async {
    if (Platform.isAndroid) {
      final status = await Permission.notification.status;
      if (status.isDenied) {
        await Permission.notification.request();
      } else if (status.isPermanentlyDenied) {
        await openAppSettings();
      }
    }
  }

  Future<void> _scheduleDailyNotifications() async {
    const androidDetails = AndroidNotificationDetails(
      'daily_channel_id',
      'Daily Notifications',
      channelDescription: '아침 8시 / 저녁 8시 알림',
      importance: Importance.max,
      priority: Priority.high,
    );
    const details = NotificationDetails(android: androidDetails);

    // 아침 8시
    await notificationsPlugin.zonedSchedule(
      0,
      '오늘의 운세',
      '오늘 운세를 확인해보세요!',
      _nextInstanceOfHour(8),
      details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
    );

    // 저녁 20시
    await notificationsPlugin.zonedSchedule(
      1,
      '오늘 하루 어땠나요?',
      '하루 기록을 남겨보세요!',
      _nextInstanceOfHour(20),
      details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  tz.TZDateTime _nextInstanceOfHour(int hour) {
    final now = tz.TZDateTime.now(tz.local);
    var scheduled = tz.TZDateTime(tz.local, now.year, now.month, now.day, hour);
    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }
    return scheduled;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '운세픽',
      locale: const Locale('ko', 'KR'),
      supportedLocales: const [Locale('ko', 'KR'), Locale('en', 'US')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: AppTheme.light(),
      home: const MainNavigationScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
