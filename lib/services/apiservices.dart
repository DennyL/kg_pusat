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
}
