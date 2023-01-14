// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_notif_shalat/pages/home.dart';
import 'package:flutter_notif_shalat/providers/jadwal_shalat_provider.dart';
import 'package:flutter_notif_shalat/theme.dart';
import 'package:timezone/data/latest.dart' as tz;

class SplashScreen extends StatefulWidget {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  const SplashScreen({
    Key? key,
    required this.flutterLocalNotificationsPlugin,
  }) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    tz.initializeTimeZones();
    getJadwalShalat();
  }

  getJadwalShalat() async {
    await JadwalShalatProvider().getJadwalShalat();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => MyHomePage(
          flutterLocalNotificationsPlugin:
              widget.flutterLocalNotificationsPlugin,
        ),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Text(
              'Aplikasi Reminder Shalat',
              style: blueTextStyle.copyWith(
                fontSize: 30,
                fontWeight: semiBold,
                letterSpacing: 2,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
