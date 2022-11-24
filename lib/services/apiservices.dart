//ignore_for_file: todo
import 'dart:convert';
import 'package:http/http.dart' as http;

var _linkPath = "http://cfin.crossnet.co.id:1323/";

class ServicesUser {
  //TODO: Login
  Future getAuth(username, password) async {
    final response = await http.get(
      Uri.parse(
          "${_linkPath}login?username=$username&password=$password&status1=1&status2="),
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
      Uri.parse("${_linkPath}pst/gereja?kode_pusat=$kodePusat"),
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
      Uri.parse("${_linkPath}pst/read-gereja-disable?kode_pusat=$kodePusat"),
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
  Future inputCabangGereja(
      kodeGerejaCabang, kodePusat, namaGereja, alamatGereja) async {
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
  Future inputAdminCabangGereja(kodeGerejaCabangAdmin, emailAdmin, telpAdmin,
      namaAdmin, usernameAdmin, passwordAdmin) async {
    final response = await http.post(
      Uri.parse(
          "${_linkPath}pst/input-admin?kode_gereja=$kodeGerejaCabangAdmin&email_user=$emailAdmin&no_telp_user=$telpAdmin&nama_lengkap_user=$namaAdmin&username=$usernameAdmin&password=$passwordAdmin"),
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
      Uri.parse("${_linkPath}pst/read-admin?kode_gereja=$kodeGerejaGet"),
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

  Future getNeraca(kodePusat, tanggal, status, statusNeraca) async {
    final response = await http.get(
      Uri.parse(
          "${_linkPath}pst/read-neraca-pusat?kode_pusat=$kodePusat&tanggal=$tanggal&status=$status&status_neraca=$statusNeraca"),
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

  Future getKodeKegiatanJurnal(kodePusat, tanggal) async {
    final response = await http.get(
      Uri.parse(
          "${_linkPath}pst/read-kode-transaksi-jurnal-pusat?kode_pusat=$kodePusat&tanggal=$tanggal"),
    );
    if (response.statusCode == 200) {
      var jsonRespStatus = json.decode(response.body)['status'];
      var jsonRespData = json.decode(response.body)['data'];
      return [jsonRespStatus, jsonRespData];
    } else {
      throw Exception("Gagal mengambil data");
    }
  }

  Future getJurnal(kodePusat, kodeTransaksi) async {
    final response = await http.get(
      Uri.parse(
          "${_linkPath}pst/jurnal-bulanan-pusat?kode_pusat=$kodePusat&kode_transaksi=$kodeTransaksi"),
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
      Uri.parse("${_linkPath}pst/transaksi-pusat?kode_pusat=$kodeGereja"),
    );
    if (response.statusCode == 200) {
      var jsonRespStatus = json.decode(response.body)['status'];
      var jsonRespData = json.decode(response.body)['data'];
      return [jsonRespStatus, jsonRespData];
    } else {
      throw Exception("Gagal mengambil data");
    }
  }

  Future queryKodeGereja(kodeGereja) async {
    final response = await http.get(
      Uri.parse("${_linkPath}pst/query-kode-gereja?kode_gereja=$kodeGereja"),
    );
    if (response.statusCode == 200) {
      var jsonRespStatus = json.decode(response.body)['status'];
      var jsonRespData = json.decode(response.body)['data'];
      return [jsonRespStatus, jsonRespData];
    } else {
      throw Exception("Gagal mengambil data");
    }
  }

  Future queryTransaksiKode(
      kodeGereja, kodeTransaksi, kodePerkiraan, tipe) async {
    final response = await http.get(
      Uri.parse(
          "${_linkPath}pst/query-kode-transaksi-pusat?kode_transaksi=$kodeTransaksi&kode_perkiraan=$kodePerkiraan&kode_gereja=$kodeGereja&tipe=$tipe"),
    );
    if (response.statusCode == 200) {
      var jsonRespStatus = json.decode(response.body)['status'];
      var jsonRespData = json.decode(response.body)['data'];
      return [jsonRespStatus, jsonRespData];
    } else {
      throw Exception("Gagal mengambil data");
    }
  }

  Future queryTransaksiTanggal(
      kodeGereja, tanggal1, tanggal2, tipe, kode) async {
    final response = await http.get(
      Uri.parse(
          "${_linkPath}pst/query-tanggal-pusat?kode_gereja=$kodeGereja&tanggal_ke_1=$tanggal1&tanggal_ke_2=$tanggal2&tipe_gereja=$tipe&kode=$kode"),
    );
    if (response.statusCode == 200) {
      var jsonRespStatus = json.decode(response.body)['status'];
      var jsonRespData = json.decode(response.body)['data'];
      return [jsonRespStatus, jsonRespData];
    } else {
      throw Exception("Gagal mengambil data");
    }
  }

  //TODO: get kode Perkiraan
  Future getKodePerkiraanSingleKegiatan(
      kodeGereja, kodeKegiatan, kodeTransaksi, status) async {
    final response = await http.get(
      Uri.parse(
          "${_linkPath}read-kode-perkiraan-single-kegiatan?kode_gereja=$kodeGereja&kode_kegiatan=$kodeKegiatan&kode_transaksi=$kodeTransaksi&status=$status"),
    );
    if (response.statusCode == 200) {
      var jsonRespStatus = json.decode(response.body)['status'];
      var jsonRespData = json.decode(response.body)['data'];
      return [jsonRespStatus, jsonRespData];
    } else {
      throw Exception("Gagal mengambil data");
    }
  }

  //TODO: get All kode Gereja
  Future getAllKodeGereja(kodeGereja) async {
    final response = await http.get(
      Uri.parse("${_linkPath}pst/read-kode-gereja?kode_pusat=$kodeGereja"),
    );
    if (response.statusCode == 200) {
      var jsonRespStatus = json.decode(response.body)['status'];
      var jsonRespData = json.decode(response.body)['data'];
      return [jsonRespStatus, jsonRespData];
    } else {
      throw Exception("Gagal mengambil data");
    }
  }

  //TODO: get All kode Transaksi
  Future getAllKodeTransaksi(kodeGereja) async {
    final response = await http.get(
      Uri.parse(
          "${_linkPath}pst/read-all-kode-transaksi?kode_pusat=$kodeGereja"),
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
