import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:flutter_native_timezone_updated_gradle/flutter_native_timezone.dart';

class NotificationsServices {
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  final AndroidInitializationSettings _androidInitializationSettings =
      const AndroidInitializationSettings('logo');

  void initialiseNotifications() async {
    InitializationSettings initializationSettings = InitializationSettings(
      android: _androidInitializationSettings,
    );

    await _flutterLocalNotificationsPlugin.initialize(initializationSettings);
    scheduleDailyNotifications('حديث اليوم', 'لا تنسى أذكار الصباح و المساء', 0, 17);
  }

  void sendNotification(String title, String body) async{
    AndroidNotificationDetails androidNotificationDetails =
        const AndroidNotificationDetails(
      'channel_id',
      'channel_name',

      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      // sound: RawResourceAndroidNotificationSound('birds_notification'),
      icon: 'logo',
    );

    NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
    );

    await _flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      notificationDetails,
    );
  }

  void scheduleNotification(String title, String body) async{

    AndroidNotificationDetails androidNotificationDetails =
    const AndroidNotificationDetails(
      'channel_id',
      'channel_name',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      icon: 'logo',
    );

    NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
    );

    await _flutterLocalNotificationsPlugin.periodicallyShow(0, title, body, RepeatInterval.daily
        , notificationDetails);
  }

  void scheduleDailyNotifications(String title, String body, int firstHour, int secondHour) async {
    // Initialize the timezone library
    tz.initializeTimeZones();

    // Get the local timezone
    tz.Location local = tz.getLocation(await FlutterNativeTimezone.getLocalTimezone());

    // Calculate the time for the notifications
    tz.TZDateTime now = tz.TZDateTime.now(local);
    tz.TZDateTime scheduledTimeMorning = tz.TZDateTime(local, now.year, now.month, now.day, firstHour);
    // tz.TZDateTime scheduledTimeEvening = tz.TZDateTime(local, now.year, now.month, now.day, secondHour, 58);

    // Schedule the notifications
    AndroidNotificationDetails androidNotificationDetails =
    const AndroidNotificationDetails(
      'channel_id',
      'channel_name',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      icon: 'logo',
      // sound: RawResourceAndroidNotificationSound('notification'),
    );

    NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
    );

    await _flutterLocalNotificationsPlugin.zonedSchedule(
      0, title, body, scheduledTimeMorning, notificationDetails,
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );

    // await _flutterLocalNotificationsPlugin.zonedSchedule(
    //   1, title, body, scheduledTimeEvening, notificationDetails,
    //   uiLocalNotificationDateInterpretation:
    //   UILocalNotificationDateInterpretation.absoluteTime,
    //   matchDateTimeComponents: DateTimeComponents.time,
    //   androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    // );
  }

  void stopNotification() async{
    await _flutterLocalNotificationsPlugin.cancelAll();
  }

}
