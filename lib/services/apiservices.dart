//ignore_for_file: todo
import 'dart:convert';
import 'package:http/http.dart' as http;

var _linkPath = "http://cfin.crossnet.co.id:1323/";

class ServicesUser {
  //TODO: Login
  Future getAuth(username, password) async {
    final response = await http.get(
      Uri.parse("${_linkPath}login?username=$username&password=$password"),
    );
    if (response.statusCode == 200) {
      var jsonRespStatus = json.decode(response.body)['status'];
      var jsonRespData = json.decode(response.body)['data'];
      return [jsonRespStatus, jsonRespData];
    } else {
      throw Exception("Gagal mengambil data");
    }
  }

  

  //TODO: Get Kode Gereja
  Future getKodeGereja(kodeuser) async {
    final response = await http.get(
      Uri.parse("${_linkPath}get-kode-gereja?kode_user=$kodeuser"),
    );
    if (response.statusCode == 200) {
      var jsonRespStatus = json.decode(response.body)['status'];
      var jsonRespData = json.decode(response.body)['data'];
      return [jsonRespStatus, jsonRespData];
    } else {
      throw Exception("Gagal mengambil data");
    }
  }

  //TODO: Get Gereja Cabang
  Future getCabangGereja(kodePusat) async {
    final response = await http.get(
      Uri.parse(
          "${_linkPath}pst/gereja?kode_pusat=$kodePusat"),
    );
    if (response.statusCode == 200) {
      var jsonRespStatus = json.decode(response.body)['status'];
      var jsonRespData = json.decode(response.body)['data'];

      return [jsonRespStatus, jsonRespData];
    } else {
      throw Exception("Gagal mengambil data");
    }
  }

  //TODO: Get Gereja Cabang
  Future getCabangGerejaDis(kodePusat) async {
    final response = await http.get(
      Uri.parse(
          "${_linkPath}pst/read-gereja-disable?kode_pusat=$kodePusat"),
    );
    if (response.statusCode == 200) {
      var jsonRespStatus = json.decode(response.body)['status'];
      var jsonRespData = json.decode(response.body)['data'];

      return [jsonRespStatus, jsonRespData];
    } else {
      throw Exception("Gagal mengambil data");
    }
  }

  //TODO: Input gereja cabang
  Future inputCabangGereja(kodeGerejaCabang, kodePusat, namaGereja, alamatGereja) async {
    final response = await http.post(
      Uri.parse(
          "${_linkPath}pst/input-gereja?kode_gereja=$kodeGerejaCabang&kode_pusat=$kodePusat&nama_gereja=$namaGereja&alamat_gereja=$alamatGereja"),
    );
    if (response.statusCode == 200) {
      var jsonRespStatus = json.decode(response.body)['status'];
      var jsonRespMessage = json.decode(response.body)['message'];
      return [jsonRespStatus, jsonRespMessage];
    } else {
      throw Exception("Gagal mengambil data");
    }
  }

  //TODO: Input admin gereja cabang
  Future inputAdminCabangGereja(kodeGerejaCabangAdmin, emailAdmin, telpAdmin, namaAdmin) async {
    final response = await http.post(
      Uri.parse(
          "${_linkPath}pst/input-admin?kode_gereja=$kodeGerejaCabangAdmin&email_user=$emailAdmin&no_telp_user=$telpAdmin&nama_lengkap_user=$namaAdmin"),
    );
    if (response.statusCode == 200) {
      var jsonRespStatus = json.decode(response.body)['status'];
      var jsonRespMessage = json.decode(response.body)['message'];
      return [jsonRespStatus, jsonRespMessage];
    } else {
      throw Exception("Gagal mengambil data");
    }
  }

  //TODO: Get admin gereja cabang
  Future getAdminCabangGereja(kode_gereja_get) async {
    final response = await http.get(
      Uri.parse(
          "${_linkPath}pst/read-admin?kode_gereja=$kode_gereja_get"),
    );
    if (response.statusCode == 200) {
      var jsonRespStatus = json.decode(response.body)['status'];
      var jsonRespData = json.decode(response.body)['data'];

      return [jsonRespStatus, jsonRespData];
    } else {
      throw Exception("Gagal mengambil data");
    }
  }

  //TODO: update status gereja
  Future updateStatusGereja(kodeGerStatus, kodePusStatus) async {
    final response = await http.put(
      Uri.parse(
          "${_linkPath}pst/update-status?kode_gereja=$kodeGerStatus&kode_pusat=$kodePusStatus"),
    );
    if (response.statusCode == 200) {
      var jsonRespStatus = json.decode(response.body)['status'];
      var jsonRespMessage = json.decode(response.body)['message'];
      return [jsonRespStatus, jsonRespMessage];
    } else {
      throw Exception("Gagal mengupdate data");
    }
  }
}
