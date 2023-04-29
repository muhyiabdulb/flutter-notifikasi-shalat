import 'package:flutter_notif_shalat/models/jadwal_shalat.dart';
import 'package:flutter_notif_shalat/service/jadwal_shalat_service.dart';
import 'package:flutter_notif_shalat/service/notification_service.dart';

class JadwalShalatProvider {
  JadwalShalatModel? _jadwalShalatModel;
  var month = DateTime.now().month;
  var today = DateTime.now().day;

  Future getJadwalShalat() async {
    // print("month ${month.toString()}");
    // print("today ${today.toString()}");
    JadwalShalatModel data = await JadwalShalatService().getJadwalShalat(
      month.toString(),
      today.toString(),
    );

    _jadwalShalatModel = data;

    var tgl = _jadwalShalatModel?.data?.jadwal?.date;
    // print("tgl $tgl");

    var shalatShubuh = _jadwalShalatModel?.data?.jadwal?.subuh;
    // print("shalatShubuh $shalatShubuh");
    var shalatDzuhur = _jadwalShalatModel?.data?.jadwal?.dzuhur;
    // print("shalatDzuhur $shalatDzuhur");
    var shalatAshar = _jadwalShalatModel?.data?.jadwal?.ashar;
    // print("shalatAshar $shalatAshar");
    var shalatMaghrib = _jadwalShalatModel?.data?.jadwal?.maghrib;
    // print("shalatMaghrib $shalatMaghrib");
    var shalatIsya = _jadwalShalatModel?.data?.jadwal?.isya;
    // print("shalatIsya $shalatIsya");

    int durasiShubuh = convertTime(tgl.toString(), shalatShubuh.toString());
    // print("durasiShubuh $durasiShubuh");
    if (durasiShubuh > 0) {
      // print("masuk notif Shubuh");
      NotificationService().showNotifShalat(
        1,
        "Adzan Shubuh",
        "Waktu shalat Shubuh  sudah masuk",
        durasiShubuh,
      );
    }

    int durasiDzuhur = convertTime(tgl.toString(), shalatDzuhur.toString());
    // print("durasiDzuhur $durasiDzuhur");
    if (durasiDzuhur > 0) {
      // print("masuk notif Dzuhur");
      NotificationService().showNotifShalat(
        2,
        "Adzan Dzuhur",
        "Waktu shalat Dzuhur sudah masuk",
        durasiDzuhur,
      );
    }

    int durasiAshar = convertTime(tgl.toString(), shalatAshar.toString());
    // print("durasiAshar $durasiAshar");
    if (durasiAshar > 0) {
      // print("masuk notif Ashar");
      NotificationService().showNotifShalat(
        3,
        "Adzan Ashar",
        "Waktu shalat Ashar sudah masuk",
        durasiAshar,
      );
    }

    int durasiMaghrib = convertTime(tgl.toString(), shalatMaghrib.toString());
    // print("durasiMaghrib $durasiMaghrib");
    if (durasiMaghrib > 0) {
      // print("masuk notif Maghrib");
      NotificationService().showNotifShalat(
        4,
        "Adzan Maghrib",
        "Waktu shalat Maghrib sudah masuk",
        durasiMaghrib,
      );
    }

    int durasiIsya = convertTime(tgl.toString(), shalatIsya.toString());
    // print("durasiIsya $durasiIsya");
    if (durasiIsya > 0) {
      // print("masuk notif Isya");
      NotificationService().showNotifShalat(
        5,
        "Adzan Isya",
        "Waktu shalat Isya sudah masuk",
        durasiIsya,
      );
    }

    return _jadwalShalatModel;
  }

  convertTime(String today, String jamShalat) {
    var inputedStartTime = DateTime.parse("$today $jamShalat");
    var mili = inputedStartTime.millisecondsSinceEpoch / 1000;
    var waktuShalat = mili.toInt();
    // print("waktuShalat $waktuShalat");
    DateTime now = DateTime.now();
    // print("waktu now $now");
    var mili2 = now.millisecondsSinceEpoch / 1000;
    var waktuSekarang = mili2.toInt();
    int durasi = waktuShalat - waktuSekarang;
    // print('dikurang $durasi');
    return durasi;
  }
}
