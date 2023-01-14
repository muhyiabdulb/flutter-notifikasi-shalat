import 'dart:io';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_notif_shalat/theme.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final NotificationService _notificationService =
      NotificationService._internal();

  factory NotificationService() {
    return _notificationService;
  }
  NotificationService._internal();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  static Future initialize(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
    var androidInitialize =
        const AndroidInitializationSettings('@drawable/sujud');
    void onDidReceiveLocalNotification(
        int id, String? title, String? body, String? payload) {
      print('id $id');
    }

    final DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
      onDidReceiveLocalNotification: onDidReceiveLocalNotification,
    );
    var initializationsSettings = InitializationSettings(
      android: androidInitialize,
      iOS: initializationSettingsIOS,
    );

    await flutterLocalNotificationsPlugin.initialize(initializationsSettings);
  }

  Future<String> _downloadAndSaveFile(String url, String fileName) async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final String filePath = '${directory.path}/$fileName';
    final http.Response response = await http.get(Uri.parse(url));
    final File file = File(filePath);
    await file.writeAsBytes(response.bodyBytes);
    return filePath;
  }

  Future<void> showNotifShalat(
    int id,
    String title,
    String body,
    int durasi,
  ) async {
    final String largeIconPath = await _downloadAndSaveFile(
        'https://awsimages.detik.net.id/community/media/visual/2020/04/23/ed3f9364-8891-4d6f-ab8b-cf866378a903_169.jpeg?w=700&q=90',
        'largeIcon');
    final String bigPicturePath = await _downloadAndSaveFile(
        'https://awsimages.detik.net.id/community/media/visual/2020/04/23/ed3f9364-8891-4d6f-ab8b-cf866378a903_169.jpeg?w=700&q=90',
        'bigPicture');
    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.now(tz.local).add(
        Duration(seconds: durasi),
      ), //schedule the notification to show after 2 seconds.
      NotificationDetails(
        // Android details
        android: AndroidNotificationDetails(
          'showNotifShalat',
          'Reminder Shalat',
          // groupKey: 'com.example.flutter_push_notifications',
          channelDescription: 'Reminder Shalat',
          importance: Importance.max,
          priority: Priority.high,
          autoCancel: false,
          enableVibration: false,
          audioAttributesUsage: AudioAttributesUsage.alarm,
          // vibrationPattern: vibrationPattern,
          icon: '@drawable/masjid',
          playSound: true,
          // ticker: 'ticker',
          // timeoutAfter: 100,
          // additionalFlags: Int32List.fromList(<int>[insistentFlag]),
          sound: const RawResourceAndroidNotificationSound('adzan'),
          largeIcon: const DrawableResourceAndroidBitmap('@drawable/sujud'),
          styleInformation: BigPictureStyleInformation(
            FilePathAndroidBitmap(bigPicturePath),
            largeIcon: FilePathAndroidBitmap(largeIconPath),
            hideExpandedLargeIcon: true,
            contentTitle: title,
            htmlFormatContentTitle: true,
            summaryText: body,
            htmlFormatSummaryText: true,
          ),
          color: primaryColor,
        ),
        // iOS details
        iOS: const DarwinNotificationDetails(
          sound: 'default.wav',
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),

      // Type of time interpretation
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidAllowWhileIdle:
          true, // To show notification even when the app is closed
    );
  }
}
