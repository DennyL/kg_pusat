//ignore_for_file: todo
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kg_pusat/globals.dart';
import 'package:kg_pusat/services/apiservices.dart';
import 'package:kg_pusat/widgets/animations/animations.dart';
import 'package:kg_pusat/widgets/widgets/responsivetext.dart';

import '../../themes/colors.dart';

String _kodeGerejaSimpan = "";
String _namaGerejaAdmin = "";
String _kodeGerejaAdmin = "";

bool cekBuatAkun = false;

class AdminControllerCabangPage extends StatefulWidget {
  const AdminControllerCabangPage({Key? key}) : super(key: key);

  @override
  State<AdminControllerCabangPage> createState() =>
      _AdminControllerCabangPageState();
}

class _AdminControllerCabangPageState extends State<AdminControllerCabangPage> {
  final _controllerCabang = PageController();
  final _controllerDisableCabang = PageController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controllerCabang.dispose();
    _controllerDisableCabang.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: _controllerDisableCabang,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        CabangPage(
            controllerPageCabang: _controllerCabang,
            controllerDisableCabang: _controllerDisableCabang),
        DisablePage(controllerDisableCabang: _controllerDisableCabang)
      ],
    );
  }
}

class CabangPage extends StatefulWidget {
  final PageController controllerPageCabang;
  final PageController controllerDisableCabang;

  const CabangPage(
      {Key? key,
      required this.controllerPageCabang,
      required this.controllerDisableCabang})
      : super(key: key);

  @override
  State<CabangPage> createState() => _CabangPageState();
}

class _CabangPageState extends State<CabangPage> {
  final _controllerKodeCabang = TextEditingController();
  final _controllerNamaCabang = TextEditingController();
  final _controllerAlamatCabang = TextEditingController();
  final _controllerNamaAdminCabang = TextEditingController();
  final _controllerEmailAdminCabang = TextEditingController();
  final _controllerTelpAdminCabang = TextEditingController();
  final _controllerSearchGerejaCabang = TextEditingController();

  final List _user = ["", "kevin", ""];

  bool visibleAddCabang = false;

  ServicesUser servicesUserItem = ServicesUser();
  late Future kategoriGerejaCabang;

  Future postGerejaCabang(
      kodeGerejaCabang, kodePusat, namaGereja, alamatGereja, context) async {
    var response = await servicesUserItem.inputCabangGereja(
        kodeGerejaCabang, kodePusat, namaGereja, alamatGereja);

    if (response[0] != 404) {
      return true;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(response[1]),
        ),
      );
    }
  }

  Future _updateStatusGereja(kodeGerStatus, kodePusStatus, context) async {
    var response =
        await servicesUserItem.updateStatusGereja(kodeGerStatus, kodePusStatus);
    if (response[0] != 404) {
      return true;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(response[1]),
        ),
      );
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    kategoriGerejaCabang = servicesUserItem.getCabangGereja(kodeGereja);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  responsiveTextField(deviceWidth, deviceHeight, controllerText) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: SizedBox(
        width: deviceWidth * 0.5,
        child: TextField(
          controller: controllerText,
          autofocus: false,
          decoration: InputDecoration(
            filled: true,
            fillColor: surfaceColor,
            contentPadding:
                const EdgeInsets.symmetric(vertical: 0, horizontal: 25),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: Colors.transparent,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: Colors.transparent,
              ),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: Colors.transparent,
              ),
            ),
          ),
        ),
      ),
    );
  }

  _showTambahDialogAdmin(dw, dh) {
    showDialog(
      barrierDismissible: false,
      useRootNavigator: true,
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: ScrollConfiguration(
                behavior: ScrollConfiguration.of(context).copyWith(
                  dragDevices: {
                    PointerDeviceKind.touch,
                    PointerDeviceKind.mouse,
                  },
                ),
                child: SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  controller: ScrollController(),
                  child: SizedBox(
                    width: dw * 0.5,
                    child: Column(
                      children: [
                        Container(
                          width: dw * 0.5,
                          decoration: BoxDecoration(
                            color: primaryColor,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const SizedBox(
                                height: 16,
                              ),
                              responsiveText(
                                  "Tambah Admin Gereja $_namaGerejaAdmin",
                                  26,
                                  FontWeight.w700,
                                  lightText),
                              const SizedBox(
                                height: 16,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  responsiveText("Kode Gereja : $_kodeGerejaAdmin", 16,
                                      FontWeight.w700, darkText),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  responsiveText("Nama Lengkap", 16,
                                      FontWeight.w700, darkText),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  responsiveTextField(
                                      dw, dh, _controllerNamaAdminCabang),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  responsiveText(
                                      "Email", 16, FontWeight.w700, darkText),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  responsiveTextField(
                                    dw,
                                    dh,
                                    _controllerEmailAdminCabang,
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  responsiveText("Nomor Telepon", 16,
                                      FontWeight.w700, darkText),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  responsiveTextField(
                                      dw, dh, _controllerTelpAdminCabang),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  if (mounted) {}
                                  Navigator.pop(context);
                                },
                                child: const Text("Batal"),
                              ),
                              const SizedBox(
                                width: 25,
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  if (mounted) {}
                                  Navigator.pop(context);
                                },
                                child: const Text("Tambah"),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    ).whenComplete(() {
      kategoriGerejaCabang = servicesUserItem.getCabangGereja(kodeGereja);
      return setState(() {});
    });
  }

  _showTambahDialogGerejaCabang(dw, dh) {
    showDialog(
      barrierDismissible: false,
      useRootNavigator: true,
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: ScrollConfiguration(
                behavior: ScrollConfiguration.of(context).copyWith(
                  dragDevices: {
                    PointerDeviceKind.touch,
                    PointerDeviceKind.mouse,
                  },
                ),
                child: SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  controller: ScrollController(),
                  child: SizedBox(
                    width: dw * 0.5,
                    child: Column(
                      children: [
                        Container(
                          width: dw * 0.5,
                          decoration: BoxDecoration(
                            color: primaryColor,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const SizedBox(
                                height: 16,
                              ),
                              responsiveText("Tambah Gereja Cabang", 26,
                                  FontWeight.w700, lightText),
                              const SizedBox(
                                height: 16,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  responsiveText("Kode Gereja Cabang", 16,
                                      FontWeight.w700, darkText),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  responsiveTextField(
                                      dw, dh, _controllerKodeCabang),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  responsiveText("Nama Gereja Cabang", 16,
                                      FontWeight.w700, darkText),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  responsiveTextField(
                                    dw,
                                    dh,
                                    _controllerNamaCabang,
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  responsiveText("Alamat Gereja Cabang", 16,
                                      FontWeight.w700, darkText),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  responsiveTextField(
                                      dw, dh, _controllerAlamatCabang),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  if (mounted) {
                                    setState(() {
                                      _controllerKodeCabang.clear();
                                      _controllerNamaCabang.clear();
                                      _controllerAlamatCabang.clear();
                                    });
                                  }
                                  Navigator.pop(context);
                                },
                                child: const Text("Batal"),
                              ),
                              const SizedBox(
                                width: 25,
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  if (mounted) {
                                    setState(() {
                                      postGerejaCabang(
                                          _controllerKodeCabang.text,
                                          kodeGereja,
                                          _controllerNamaCabang.text,
                                          _controllerAlamatCabang.text,
                                          context);
                                      _controllerKodeCabang.clear();
                                      _controllerNamaCabang.clear();
                                      _controllerAlamatCabang.clear();
                                      Navigator.pop(context);
                                    });
                                  }
                                },
                                child: const Text("Tambah"),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    ).whenComplete(() {
      kategoriGerejaCabang = servicesUserItem.getCabangGereja(kodeGereja);
      return setState(() {});
    });
  }

  _showDisable(dw, dh) {
    showDialog(
      barrierDismissible: false,
      useRootNavigator: true,
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: ScrollConfiguration(
                behavior: ScrollConfiguration.of(context).copyWith(
                  dragDevices: {
                    PointerDeviceKind.touch,
                    PointerDeviceKind.mouse,
                  },
                ),
                child: SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  controller: ScrollController(),
                  child: SizedBox(
                    width: dw < 800 ? dw * 0.8 : dw * 0.4,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 25, horizontal: 25),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                icon: const Icon(
                                    Icons.arrow_back_ios_new_rounded),
                              ),
                              Text(
                                "Disable Gereja",
                                style: GoogleFonts.nunito(
                                  fontWeight: FontWeight.w900,
                                  fontSize: 30,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const Text("")
                            ],
                          ),
                          const Divider(
                            thickness: 1,
                            height: 56,
                          ),
                          Text(
                            "Apakah anda yakin untuk disable Gereja ini ? Gereja yang disable akan dipindahkan pada halaman disable.",
                            style: GoogleFonts.nunito(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 16),
                            ),
                            onPressed: () {
                              _updateStatusGereja(
                                      _kodeGerejaSimpan, kodeGereja, context)
                                  .whenComplete(() {
                                kategoriGerejaCabang = servicesUserItem
                                    .getCabangGereja(kodeGereja);
                                return setState(() {});
                              });
                              ;
                              Navigator.pop(context);
                            },
                            child: const Text("Simpan"),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    ).whenComplete(() {
      kategoriGerejaCabang = servicesUserItem.getCabangGereja(kodeGereja);
      return setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 25),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(0),
                width: deviceWidth,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        responsiveText(
                            "Daftar Cabang", 32, FontWeight.w900, darkText),
                        ElevatedButton(
                          style: TextButton.styleFrom(
                            primary: Colors.white,
                            backgroundColor: buttonColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40),
                            ),
                          ),
                          onPressed: () {
                            widget.controllerDisableCabang.animateToPage(1,
                                duration: const Duration(milliseconds: 250),
                                curve: Curves.ease);
                          },
                          child: responsiveText("Disable Gereja Cabang", 15,
                              FontWeight.w700, lightText),
                        ),
                      ],
                    ),
                    const Divider(
                      height: 56,
                    ),
                    Column(
                      children: [
                        Row(
                          children: [
                            ElevatedButton(
                              style: TextButton.styleFrom(
                                primary: Colors.white,
                                backgroundColor: buttonColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(40),
                                ),
                              ),
                              onPressed: () {
                                _showTambahDialogGerejaCabang(
                                    deviceWidth, deviceHeight);
                              },
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.add_circle_outline_rounded,
                                    color: lightText,
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  responsiveText("Buat Gereja Cabang", 15,
                                      FontWeight.w700, lightText)
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        TextField(
                          controller: _controllerSearchGerejaCabang,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: surfaceColor,
                            labelText: 'Cari Nama Gereja Cabang',
                            labelStyle: TextStyle(
                              color: Colors.black.withOpacity(0.5),
                            ),
                            prefixIcon: Icon(
                              Icons.search_rounded,
                              color: navButtonPrimary.withOpacity(0.5),
                            ),
                            suffix: IconButton(
                              onPressed: () {
                                _controllerSearchGerejaCabang.clear();
                              },
                              icon: Icon(
                                Icons.clear,
                                color: navButtonPrimary.withOpacity(0.5),
                              ),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 0, horizontal: 25),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(
                                color: navButtonPrimary.withOpacity(0.5),
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide(
                                color: navButtonPrimary.withOpacity(0.5),
                              ),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide(
                                color: navButtonPrimary.withOpacity(0.5),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    FutureBuilder(
                      future: kategoriGerejaCabang,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          List snapData = snapshot.data! as List;
                          if (snapData[0] != 404) {
                            return ScrollConfiguration(
                              behavior:
                                  ScrollConfiguration.of(context).copyWith(
                                dragDevices: {
                                  PointerDeviceKind.touch,
                                  PointerDeviceKind.mouse,
                                },
                              ),
                              child: ListView.builder(
                                shrinkWrap: true,
                                scrollDirection: Axis.vertical,
                                controller: ScrollController(),
                                physics: const ClampingScrollPhysics(),
                                itemCount: snapData[1].length,
                                itemBuilder: (context, index) {
                                  return Card(
                                    shape: RoundedRectangleBorder(
                                      side: BorderSide(
                                        color:
                                            navButtonPrimary.withOpacity(0.5),
                                      ),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: ListTile(
                                      title: Row(
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                snapData[1][index]
                                                        ['nama_gereja'] +
                                                    " " +
                                                    "(" +
                                                    snapData[1][index]
                                                        ['kode_gereja'] +
                                                    ")",
                                                style: GoogleFonts.nunito(
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 16,
                                                  color: darkText,
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                    "Admin : " + _user[index],
                                                    style: GoogleFonts.nunito(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 15,
                                                      color: darkText,
                                                    ),
                                                  ),
                                                  Visibility(
                                                    visible: _user[index] != ""
                                                        ? false
                                                        : true,
                                                    child: Tooltip(
                                                      message:
                                                          "Tambahkan Akun Admin",
                                                      child: IconButton(
                                                          splashColor: Colors
                                                              .transparent,
                                                          highlightColor: Colors
                                                              .transparent,
                                                          hoverColor: Colors
                                                              .transparent,
                                                          onPressed: () {
                                                            _namaGerejaAdmin =
                                                                snapData[1]
                                                                        [index][
                                                                    'nama_gereja'];
                                                            _kodeGerejaAdmin =
                                                                snapData[1]
                                                                        [index][
                                                                    'kode_gereja'];
                                                            _showTambahDialogAdmin(
                                                                deviceWidth,
                                                                deviceHeight);
                                                          },
                                                          icon: const Icon(
                                                            Icons.edit,
                                                            size: 20,
                                                          )),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          const Spacer(),
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              padding: EdgeInsets.all(12),
                                              shape: CircleBorder(),
                                            ),
                                            onPressed: () {},
                                            child: const Tooltip(
                                              message: "Cek Anggota Gereja",
                                              child: Icon(Icons.people_outline),
                                            ),
                                          ),
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              padding: EdgeInsets.all(12),
                                              shape: CircleBorder(),
                                            ),
                                            onPressed: () {
                                              _kodeGerejaSimpan = snapData[1]
                                                  [index]['kode_gereja'];
                                              _showDisable(
                                                  deviceWidth, deviceHeight);
                                            },
                                            child: const Tooltip(
                                              message: "Disable Gereja",
                                              child: Icon(Icons.lock_outline),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            );
                          } else if (snapData[0] == 404) {
                            return noDataFound();
                          }
                        }
                        return loadingAnimation();
                      },
                    )
                  ],
                ),
              )
            ],
          )),
    );
  }
}

class DisablePage extends StatefulWidget {
  final PageController controllerDisableCabang;
  const DisablePage({Key? key, required this.controllerDisableCabang})
      : super(key: key);

  @override
  State<DisablePage> createState() => _DisablePageState();
}

class _DisablePageState extends State<DisablePage> {
  ServicesUser servicesUserItem = ServicesUser();
  late Future kategoriGerejaCabangDis;

  Future _updateStatusGereja(kodeGerStatus, kodePusStatus, context) async {
    var response =
        await servicesUserItem.updateStatusGereja(kodeGerStatus, kodePusStatus);
    if (response[0] != 404) {
      return true;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(response[1]),
        ),
      );
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    kategoriGerejaCabangDis = servicesUserItem.getCabangGerejaDis(kodeGereja);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  _showUndisable(dw, dh) {
    showDialog(
      barrierDismissible: false,
      useRootNavigator: true,
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: ScrollConfiguration(
                behavior: ScrollConfiguration.of(context).copyWith(
                  dragDevices: {
                    PointerDeviceKind.touch,
                    PointerDeviceKind.mouse,
                  },
                ),
                child: SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  controller: ScrollController(),
                  child: SizedBox(
                    width: dw < 800 ? dw * 0.8 : dw * 0.4,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 25, horizontal: 25),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                icon: const Icon(
                                    Icons.arrow_back_ios_new_rounded),
                              ),
                              Text(
                                "Unisable Gereja",
                                style: GoogleFonts.nunito(
                                  fontWeight: FontWeight.w900,
                                  fontSize: 30,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const Text("")
                            ],
                          ),
                          const Divider(
                            thickness: 1,
                            height: 56,
                          ),
                          Text(
                            "Apakah anda yakin untuk undisable Gereja ini ? Gereja yang di undisable akan dipindahkan pada halaman pertama.",
                            style: GoogleFonts.nunito(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 16),
                            ),
                            onPressed: () {
                              _updateStatusGereja(
                                      _kodeGerejaSimpan, kodeGereja, context)
                                  .whenComplete(() {
                                kategoriGerejaCabangDis = servicesUserItem
                                    .getCabangGerejaDis(kodeGereja);
                                return setState(() {});
                              });
                              Navigator.pop(context);
                            },
                            child: const Text("Simpan"),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    ).whenComplete(() {
      kategoriGerejaCabangDis = servicesUserItem.getCabangGerejaDis(kodeGereja);
      return setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height;
    return Stack(
      children: [
        ScrollConfiguration(
          behavior: ScrollConfiguration.of(context).copyWith(
            dragDevices: {
              PointerDeviceKind.touch,
              PointerDeviceKind.mouse,
            },
          ),
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            controller: ScrollController(),
            child: Container(
              padding: const EdgeInsets.all(16),
              width: deviceWidth,
              child: Column(
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios_new_rounded),
                        onPressed: () {
                          widget.controllerDisableCabang.animateToPage(0,
                              duration: const Duration(milliseconds: 250),
                              curve: Curves.ease);
                        },
                      ),
                      const SizedBox(
                        width: 25,
                      ),
                      Text(
                        "Disable Gereja Cabang",
                        style: Theme.of(context).textTheme.headline5,
                      ),
                    ],
                  ),
                  const Divider(
                    thickness: 1,
                    height: 56,
                  ),
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide(
                        color: navButtonPrimary.withOpacity(0.4),
                      ),
                    ),
                    child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: FutureBuilder(
                          future: kategoriGerejaCabangDis,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              List snapData = snapshot.data! as List;
                              if (snapData[0] != 404) {
                                return ScrollConfiguration(
                                  behavior: ScrollConfiguration.of(context)
                                      .copyWith(dragDevices: {
                                    PointerDeviceKind.touch,
                                    PointerDeviceKind.mouse
                                  }),
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    scrollDirection: Axis.vertical,
                                    controller: ScrollController(),
                                    physics: const ClampingScrollPhysics(),
                                    itemCount: snapData[1].length,
                                    itemBuilder: (context, index) {
                                      return Card(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          side: BorderSide(
                                            color: navButtonPrimary
                                                .withOpacity(0.4),
                                          ),
                                        ),
                                        color: scaffoldBackgroundColor,
                                        child: ListTile(
                                          title: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              responsiveText(
                                                  snapData[1][index]
                                                      ['nama_gereja'],
                                                  18,
                                                  FontWeight.w700,
                                                  darkText),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              responsiveText(
                                                  snapData[1][index]
                                                      ['kode_gereja'],
                                                  16,
                                                  FontWeight.w500,
                                                  darkText),
                                            ],
                                          ),
                                          trailing: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              padding: const EdgeInsets.all(12),
                                              shape: const CircleBorder(),
                                            ),
                                            onPressed: () {
                                              _kodeGerejaSimpan = snapData[1]
                                                  [index]['kode_gereja'];
                                              _showUndisable(
                                                  deviceWidth, deviceHeight);
                                            },
                                            child: const Tooltip(
                                              message: "Undisable Gereja",
                                              child: Icon(
                                                  Icons.lock_open_outlined),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                );
                              } else if (snapData[0] == 404) {
                                return noDataFound();
                              }
                            }
                            return loadingAnimation();
                          },
                        )),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
