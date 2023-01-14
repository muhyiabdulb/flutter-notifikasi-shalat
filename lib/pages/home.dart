import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_notif_shalat/models/jadwal_shalat.dart';
import 'package:flutter_notif_shalat/providers/jadwal_shalat_provider.dart';
import 'package:flutter_notif_shalat/theme.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:intl/intl.dart';

class MyHomePage extends StatefulWidget {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  const MyHomePage({
    Key? key,
    required this.flutterLocalNotificationsPlugin,
  }) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  JadwalShalatModel? _jadwalShalatModel;
  bool isLoading = false;
  var month = DateTime.now().month;
  var today = DateTime.now().day;

  @override
  void initState() {
    super.initState();
    tz.initializeTimeZones();
    getJadwalShalat();
  }

  getJadwalShalat() async {
    setState(() {
      isLoading = true;
    });
    JadwalShalatModel data = await JadwalShalatProvider().getJadwalShalat();
    _jadwalShalatModel = data;
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Aplikasi Reminder Shalat",
          style: whiteTextStyle.copyWith(),
        ),
        backgroundColor: primaryColor,
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: spaceHeight,
            vertical: spaceHeight,
          ),
          child: Container(
            child: isLoading
                ? Center(
                    child: CircularProgressIndicator(
                      color: primaryColor,
                    ),
                  )
                : ListView(
                    children: [
                      Text(
                        "Jadwal Shalat hari ini",
                        style: blueTextStyle.copyWith(
                          fontSize: 21,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(
                        height: spaceHeight,
                      ),
                      StreamBuilder(
                        stream: Stream.periodic(const Duration(seconds: 1)),
                        builder: (context, snapshot) {
                          return Text(
                            DateFormat('HH:mm:ss').format(DateTime.now()),
                            style: blueTextStyle.copyWith(
                              fontSize: 21,
                            ),
                            textAlign: TextAlign.center,
                          );
                        },
                      ),
                      const SizedBox(
                        height: spaceHeight,
                      ),
                      Text(
                        _jadwalShalatModel?.data?.jadwal?.tanggal ?? "",
                        style: blueTextStyle.copyWith(
                          fontSize: 18,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(
                        height: spaceHeight,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                              child: cardShalat(
                            "Shubuh",
                            _jadwalShalatModel?.data?.jadwal?.subuh ?? "",
                          )),
                          const SizedBox(
                            width: spaceWidth,
                          ),
                          Expanded(
                              child: cardShalat(
                            "Dzuhur",
                            _jadwalShalatModel?.data?.jadwal?.dzuhur ?? "",
                          )),
                        ],
                      ),
                      const SizedBox(
                        height: spaceHeight,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                              child: cardShalat(
                            "Ashar",
                            _jadwalShalatModel?.data?.jadwal?.ashar ?? "",
                          )),
                          const SizedBox(
                            width: spaceWidth,
                          ),
                          Expanded(
                              child: cardShalat(
                            "Maghrib",
                            _jadwalShalatModel?.data?.jadwal?.maghrib ?? "",
                          )),
                        ],
                      ),
                      const SizedBox(
                        height: spaceHeight,
                      ),
                      cardShalat(
                        "Isya",
                        _jadwalShalatModel?.data?.jadwal?.isya ?? "",
                      ),
                      const SizedBox(
                        height: spaceHeight,
                      ),
                      ElevatedButton(
                        style: TextButton.styleFrom(
                          backgroundColor: primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () async {
                          await getJadwalShalat();
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Refresh",
                              style: whiteTextStyle.copyWith(
                                fontWeight: medium,
                                fontSize: 17,
                              ),
                            ),
                            const SizedBox(
                              width: spaceWidth,
                            ),
                            const Icon(
                              Icons.refresh,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  cardShalat(String shalat, String waktu) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.circular(rounded),
        boxShadow: [
          BoxShadow(
            color: greyColor,
            spreadRadius: 1,
            blurRadius: 2,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.mosque,
            color: whiteColor,
          ),
          const SizedBox(height: spaceWidth),
          Row(
            children: [
              Text(
                shalat,
                style: whiteTextStyle.copyWith(
                  fontWeight: medium,
                ),
              ),
              const SizedBox(width: spaceWidth),
              Text(
                "$waktu WIB",
                style: whiteTextStyle.copyWith(
                  fontWeight: medium,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
