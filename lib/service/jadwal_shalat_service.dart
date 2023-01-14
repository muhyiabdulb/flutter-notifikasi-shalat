import 'dart:convert';

import 'package:flutter_notif_shalat/global.dart';
import 'package:flutter_notif_shalat/models/jadwal_shalat.dart';
import 'package:http/http.dart' as http;

class JadwalShalatService {
  Future getJadwalShalat(String bulan, String today) async {
    try {
      // print("response 1");
      var apiUrl = Uri.parse("${Global.BASE_API}/$bulan/$today");
      // print("response 2");
      var response = await http.get(apiUrl, headers: {
        'Content-type': 'application/json',
        'Accept': 'applicaton/json',
      });

      // print("response 3 ");
      // print("response ${response.statusCode}");
      var data = jsonDecode(response.body);
      // print("response jsondecode ${data['data']}");

      return JadwalShalatModel.fromJson(data);
    } catch (e) {
      print("error jadwal shalat $e");
      return null;
    }
  }
}
