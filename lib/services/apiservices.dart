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
  Future getAdminCabangGereja(kodeGerejaGet) async {
    final response = await http.get(
      Uri.parse(
          "${_linkPath}pst/read-admin?kode_gereja=$kodeGerejaGet"),
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

  Future getNeraca(kodeGereja, tanggal, status, statusNeraca) async {
    final response = await http.get(
      Uri.parse(
          "${_linkPath}neraca-saldo?kode_gereja=$kodeGereja&tanggal=$tanggal&status=$status&status_neraca=$statusNeraca"),
    );
    if (response.statusCode == 200) {
      var jsonRespStatus = json.decode(response.body)['status'];
      var jsonRespData = json.decode(response.body)['data'];
      return [jsonRespStatus, jsonRespData];
    } else {
      throw Exception("Gagal mengambil data");
    }
  }

  //TODO: Get User
  Future getSingleUser(kodeuser) async {
    final response = await http.get(
      Uri.parse("${_linkPath}get-profile?kode_user=$kodeuser"),
    );
    if (response.statusCode == 200) {
      var jsonRespStatus = json.decode(response.body)['status'];
      var jsonRespData = json.decode(response.body)['data'];

      return [jsonRespStatus, jsonRespData];
    } else {
      throw Exception("Gagal mengambil data");
    }
  }

  Future getKodeKegiatanJurnal(kodeGereja, tanggal) async {
    final response = await http.get(
      Uri.parse(
          "${_linkPath}read-kode-transaksi-jurnal?kode_gereja=$kodeGereja&tanggal=$tanggal"),
    );
    if (response.statusCode == 200) {
      var jsonRespStatus = json.decode(response.body)['status'];
      var jsonRespData = json.decode(response.body)['data'];
      return [jsonRespStatus, jsonRespData];
    } else {
      throw Exception("Gagal mengambil data");
    }
  }

  Future getJurnal(kodeGereja, tanggal, kodeTransaksi) async {
    final response = await http.get(
      Uri.parse(
          "${_linkPath}jurnal?kode_gereja=$kodeGereja&tanggal=$tanggal&kode_transaksi=$kodeTransaksi"),
    );
    if (response.statusCode == 200) {
      var jsonRespStatus = json.decode(response.body)['status'];
      var jsonRespData = json.decode(response.body)['data'];
      return [jsonRespStatus, jsonRespData];
    } else {
      throw Exception("Gagal mengambil data");
    }
  }

    //TODO: Laporan Buku Besar
  Future getKodeBukuBesar(kodeGereja) async {
    final response = await http.get(
      Uri.parse(
          "${_linkPath}read-kode-perkiraan-buku-besar?kode_gereja=$kodeGereja"),
    );
    if (response.statusCode == 200) {
      var jsonRespStatus = json.decode(response.body)['status'];
      var jsonRespData = json.decode(response.body)['data'];
      return [jsonRespStatus, jsonRespData];
    } else {
      throw Exception("Gagal mengambil data");
    }
  }

  Future getItemBukuBesar(
      kodeGereja, tanggal, kodeMaster, kodePerkiraan) async {
    final response = await http.get(
      Uri.parse(
          "${_linkPath}buku-besar?kode_gereja=$kodeGereja&tanggal=$tanggal&header_kode_perkiraan=$kodeMaster&kode_perkiraan=$kodePerkiraan"),
    );
    if (response.statusCode == 200) {
      var jsonRespStatus = json.decode(response.body)['status'];
      var jsonRespData = json.decode(response.body)['data'];
      return [jsonRespStatus, jsonRespData];
    } else {
      throw Exception("Gagal mengambil data");
    }
  }

  //TODO: Get Transaksi
  Future getTransaksi(kodeGereja) async {
    final response = await http.get(
      Uri.parse("${_linkPath}transaksi?kode_gereja=$kodeGereja"),
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
