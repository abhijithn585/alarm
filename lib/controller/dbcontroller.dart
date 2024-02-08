import 'package:alarm/main.dart';
import 'package:alarm/model/alarm_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive/hive.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;


class DbController extends ChangeNotifier {
  List<AlarmModel> alarmlist = [];

  addAlarm(AlarmModel alarm) async {
    final alarmbox = await Hive.openBox<AlarmModel>('alarmbox');
    alarmlist.add(alarm);
    alarmbox.add(alarm);
    notifyListeners();

    // Schedule the notification when a new alarm is added
    await scheduleNotification(alarm);
  }

  getAlarms() async {
    final alarmbox = await Hive.openBox<AlarmModel>('alarmbox');
    alarmlist.clear();
    alarmlist = alarmbox.values.toList();
    notifyListeners();
  }

  Future<void> scheduleNotification(AlarmModel alarm) async {
  // Ensure alarm.time is not null; use DateTime.now() as a default if it is
  final scheduledTime = alarm.time ?? DateTime.now();

  const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
    'your_channel_id',
    'your_channel_name',
   channelDescription:  'your_channel_description',
    importance: Importance.max,
    priority: Priority.high,
  );

  const NotificationDetails platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics);

  await flutterLocalNotificationsPlugin.zonedSchedule(
    alarm.hashCode, // Use a unique ID for each alarm to avoid overwriting
    alarm.title,
    alarm.description,
    tz.TZDateTime.from(scheduledTime, tz.local),
    platformChannelSpecifics,
    uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
    matchDateTimeComponents: DateTimeComponents.time,
  );
}

}
