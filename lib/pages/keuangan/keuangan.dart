//ignore_for_file: todo
import 'dart:typed_data';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:kg_pusat/globals.dart';
import 'package:kg_pusat/services/apiservices.dart';
import 'package:kg_pusat/themes/colors.dart';
import 'package:kg_pusat/widgets/animations/animations.dart';
import 'package:kg_pusat/widgets/widgets/responsivetext.dart';
import 'package:kg_pusat/widgets/widgets/string_extension.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:signature/signature.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:dropdown_search/dropdown_search.dart';

final List<DataRow> _rowList = List.empty(growable: true);
final List _dataNeraca = List.empty(growable: true);
final List _dataBukuBesar = List.empty(growable: true);
final List _dataJurnal = List.empty(growable: true);

final List<DataRow> _saldoAwal = List.empty(growable: true);

final List<DataRow> _neracaTable = List.empty(growable: true);
final List<DataRow> _JurnalTable = List.empty(growable: true);
final List<DataRow> _BukuBesarTable = List.empty(growable: true);

final _pemasukanLancar = List.empty(growable: true);
final _pemasukanTetap = List.empty(growable: true);
final _pengeluaranLancar = List.empty(growable: true);
final _pengeluaranJangkaPanjang = List.empty(growable: true);

class KeuanganControllerPage extends StatefulWidget {
  const KeuanganControllerPage({super.key});

  @override
  State<KeuanganControllerPage> createState() => _KeuanganControllerPageState();
}

class _KeuanganControllerPageState extends State<KeuanganControllerPage> {
  final _controllerLaporan = PageController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controllerLaporan.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: _controllerLaporan,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        KeuanganPage(controllerLaporan: _controllerLaporan),
        AdminLaporanKeuangan(controllerLaporan: _controllerLaporan)
      ],
    );
  }
}

class KeuanganPage extends StatefulWidget {
  final PageController controllerLaporan;
  const KeuanganPage({super.key, required this.controllerLaporan});
  @override
  State<KeuanganPage> createState() => _KeuanganPageState();
}

class _KeuanganPageState extends State<KeuanganPage> {
  int _indexFilterTanggal = 0;

  DateTime selectedDate = DateTime.now();
  String formattedDate = "";
  String date = "Date";

  DateTime selectedDate1 = DateTime.now();
  String formattedDate1 = "";
  String dateFrom = "Date";

  DateTime selectedDate2 = DateTime.now();
  String formattedDate2 = "";
  String dateTo = "Date";

  DateTime selectedMonth = DateTime.now();
  String formattedMonth = "";
  String month = "Month";

  int dayOfWeek = DateTime.now().weekday - 1;
  DateTime firstDay = DateTime.now();
  DateTime lastDay = DateTime.now();

  @override
  void initState() {
    // TODO: implement initState
    _rowList.clear();
    _addRowTransaksi();

    formattedDate1 = DateFormat('dd-MM-yyyy').format(selectedDate1);
    dateFrom = formattedDate1;

    formattedDate2 = DateFormat('dd-MM-yyyy').format(selectedDate2);
    dateTo = formattedDate2;

    formattedDate = DateFormat('dd-MM-yyyy').format(selectedDate);
    date = formattedDate;

    formattedMonth = DateFormat('MM-yyyy').format(selectedMonth);
    month = formattedMonth;

    dayOfWeek = DateTime.now().weekday - 1;
    firstDay = DateTime(DateTime.now().year, DateTime.now().month,
        DateTime.now().day - dayOfWeek);
    lastDay = firstDay.add(
      const Duration(days: 6, hours: 23, minutes: 59),
    );
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  Future<void> selectMonth(context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      firstDate: DateTime(DateTime.now().year - 5, 1, 1),
      lastDate: DateTime(DateTime.now().year, 12, 31),
      initialDate: selectedMonth,
      builder: (context, child) {
        return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.light(
                primary: primaryColor, // header background color
                onPrimary: lightText, // header text color
                onSurface: darkText, // body text color
              ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  foregroundColor: navButtonPrimary, // button text color
                ),
              ),
            ),
            child: child!);
      },
    );
    if (picked != null && picked != selectedMonth) {
      if (mounted) {
        selectedMonth = picked;
        formattedMonth = DateFormat('MM-yyyy').format(selectedMonth);
        month = formattedMonth;
        debugPrint("Selected Month $month");
        setState(() {});
      }
    }
  }

  Future<void> selectDate(context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(DateTime.now().year - 5, 1, 1),
      lastDate: DateTime(DateTime.now().year, 12, 31),
      builder: (context, child) {
        return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.light(
                primary: primaryColor, // header background color
                onPrimary: lightText, // header text color
                onSurface: darkText, // body text color
              ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  foregroundColor: navButtonPrimary, // button text color
                ),
              ),
            ),
            child: child!);
      },
    );
    if (picked != null && picked != selectedDate) {
      if (mounted) {
        selectedDate = picked;
        formattedDate = DateFormat('dd-MM-yyyy').format(selectedDate);
        date = formattedDate;
        debugPrint("Selected Date From $selectedDate");

        setState(() {});
      }
    }
  }

  Future<void> selectDateFrom(context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: firstDay,
      firstDate: DateTime(DateTime.now().year - 5, 1, 1),
      lastDate: DateTime(DateTime.now().year, 12, 31),
      builder: (context, child) {
        return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.light(
                primary: primaryColor, // header background color
                onPrimary: lightText, // header text color
                onSurface: darkText, // body text color
              ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  foregroundColor: navButtonPrimary, // button text color
                ),
              ),
            ),
            child: child!);
      },
    );
    if (picked != null && picked != selectedDate1) {
      if (mounted) {
        dayOfWeek = picked.weekday - 1;
        firstDay = DateTime(picked.year, picked.month, picked.day - dayOfWeek);
        lastDay = firstDay.add(
          const Duration(days: 6, hours: 23, minutes: 59),
        );
        selectedDate1 = firstDay;
        selectedDate2 = lastDay;
        formattedDate1 = DateFormat('dd-MM-yyyy').format(selectedDate1);
        formattedDate2 = DateFormat('dd-MM-yyyy').format(selectedDate2);
        dateFrom = formattedDate1;
        dateTo = formattedDate2;
        debugPrint("$dateFrom, $dateTo");
        setState(() {});
      }
    }
  }

  Future<void> selectDateTo(context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate2,
      firstDate: DateTime(DateTime.now().year - 5, 1, 1),
      lastDate: DateTime(DateTime.now().year, 12, 31),
      builder: (context, child) {
        return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.light(
                primary: primaryColor, // header background color
                onPrimary: lightText, // header text color
                onSurface: darkText, // body text color
              ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  foregroundColor: navButtonPrimary, // button text color
                ),
              ),
            ),
            child: child!);
      },
    );
    if (picked != null && picked != selectedDate1) {
      if (mounted) {
        dayOfWeek = picked.weekday - 1;
        firstDay = DateTime(picked.year, picked.month, picked.day - dayOfWeek);
        lastDay = firstDay.add(
          const Duration(days: 6, hours: 23, minutes: 59),
        );
        selectedDate1 = firstDay;
        selectedDate2 = lastDay;
        formattedDate1 = DateFormat('dd-MM-yyyy').format(selectedDate1);
        formattedDate2 = DateFormat('dd-MM-yyyy').format(selectedDate2);
        dateFrom = formattedDate1;
        dateTo = formattedDate2;
        debugPrint("$dateFrom, $dateTo");
        setState(() {});
      }
    }
  }

  void _addRowTransaksi() {
    _rowList.add(
      const DataRow(
        cells: [
          DataCell(
            Text(
              "Gereja",
              overflow: TextOverflow.ellipsis,
            ),
          ),
          DataCell(
            Text(
              "kode",
              overflow: TextOverflow.ellipsis,
            ),
          ),
          DataCell(
            Text(
              "tanggal",
              overflow: TextOverflow.ellipsis,
            ),
          ),
          DataCell(
            Text(
              "deskripsi",
              overflow: TextOverflow.ellipsis,
            ),
          ),
          DataCell(
            Text(
              "pemasukan",
              overflow: TextOverflow.ellipsis,
            ),
          ),
          DataCell(
            Text(
              "pengeluaran",
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  _filterTanggalField() {
    if (_indexFilterTanggal == 0) {
      return Column(
        children: const [],
      );
    } else if (_indexFilterTanggal == 1) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          responsiveText("Tanggal", 14, FontWeight.w700, darkText),
          GestureDetector(
            onTap: () {
              selectDate(context);
            },
            child: Card(
              color: primaryColor,
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    responsiveText(date, 14, FontWeight.w700, lightText),
                    const IconButton(
                      onPressed: null,
                      icon: Icon(Icons.calendar_month),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          ElevatedButton(
            //TODO: search btn
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {},
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.search),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  "Cari",
                  style: GoogleFonts.nunito(
                      fontWeight: FontWeight.w700, fontSize: 16),
                ),
              ],
            ),
          ),
        ],
      );
    } else if (_indexFilterTanggal == 2) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          responsiveText("Dari Tanggal", 14, FontWeight.w700, darkText),
          GestureDetector(
            onTap: () {
              selectDateFrom(context);
            },
            child: Card(
              color: primaryColor,
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    responsiveText(dateFrom, 14, FontWeight.w700, lightText),
                    const IconButton(
                      onPressed: null,
                      icon: Icon(Icons.calendar_month),
                    ),
                  ],
                ),
              ),
            ),
          ),
          responsiveText("Sampai Tanggal", 14, FontWeight.w700, darkText),
          GestureDetector(
            onTap: () {
              selectDateTo(context);
            },
            child: Card(
              color: primaryColor,
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    responsiveText(dateTo, 14, FontWeight.w700, lightText),
                    const IconButton(
                      onPressed: null,
                      icon: Icon(Icons.calendar_month),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          ElevatedButton(
            //TODO: search btn
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {},
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.search),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  "Cari",
                  style: GoogleFonts.nunito(
                      fontWeight: FontWeight.w700, fontSize: 16),
                ),
              ],
            ),
          ),
        ],
      );
    } else if (_indexFilterTanggal == 3) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          responsiveText("Bulan", 14, FontWeight.w700, darkText),
          GestureDetector(
            onTap: () {
              selectMonth(context);
            },
            child: Card(
              color: primaryColor,
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    responsiveText(month, 14, FontWeight.w700, lightText),
                    const IconButton(
                      onPressed: null,
                      icon: Icon(Icons.calendar_month),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          ElevatedButton(
            //TODO: search btn
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {},
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.search),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  "Cari",
                  style: GoogleFonts.nunito(
                      fontWeight: FontWeight.w700, fontSize: 16),
                ),
              ],
            ),
          ),
        ],
      );
    } else {
      return Column();
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                responsiveText(
                    "Keuangan Cabang", 32, FontWeight.w900, darkText),
                ElevatedButton(
                  onPressed: () {
                    widget.controllerLaporan.animateToPage(1,
                        duration: const Duration(milliseconds: 250),
                        curve: Curves.ease);
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text("Laporan Keuangan"),
                ),
              ],
            ),
            const Divider(
              height: 56,
            ),
            Expanded(
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: deviceWidth < 1280
                                ? SingleChildScrollView(
                                    physics: const ClampingScrollPhysics(),
                                    controller: ScrollController(),
                                    scrollDirection: Axis.horizontal,
                                    child: DataTable(
                                      border: TableBorder.all(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.black.withOpacity(0.5),
                                        style: BorderStyle.solid,
                                      ),
                                      headingRowHeight: 70,
                                      dataRowHeight: 56,
                                      columns: [
                                        DataColumn(
                                          label: Text(
                                            "Gereja",
                                            style: GoogleFonts.nunito(
                                              fontWeight: FontWeight.w700,
                                              fontSize: 18,
                                            ),
                                          ),
                                        ),
                                        DataColumn(
                                          label: Text(
                                            "Kode",
                                            style: GoogleFonts.nunito(
                                              fontWeight: FontWeight.w700,
                                              fontSize: 18,
                                            ),
                                          ),
                                        ),
                                        DataColumn(
                                          label: Text(
                                            "Tanggal",
                                            style: GoogleFonts.nunito(
                                              fontWeight: FontWeight.w700,
                                              fontSize: 18,
                                            ),
                                          ),
                                        ),
                                        DataColumn(
                                          label: Text(
                                            "Deskripsi",
                                            style: GoogleFonts.nunito(
                                              fontWeight: FontWeight.w700,
                                              fontSize: 18,
                                            ),
                                          ),
                                        ),
                                        DataColumn(
                                          label: Text(
                                            "Pemasukan",
                                            style: GoogleFonts.nunito(
                                              fontWeight: FontWeight.w700,
                                              fontSize: 18,
                                            ),
                                          ),
                                        ),
                                        DataColumn(
                                          label: Text(
                                            "Pengeluaran",
                                            style: GoogleFonts.nunito(
                                              fontWeight: FontWeight.w700,
                                              fontSize: 18,
                                            ),
                                          ),
                                        ),
                                      ],
                                      rows: List.generate(
                                        _rowList.length,
                                        (index) {
                                          return DataRow(
                                              color: MaterialStateColor
                                                  .resolveWith(
                                                (states) {
                                                  return index % 2 == 1
                                                      ? Colors.white
                                                      : primaryColor
                                                          .withOpacity(0.2);
                                                },
                                              ),
                                              cells: _rowList[index].cells);
                                        },
                                      ),
                                    ),
                                  )
                                : DataTable(
                                    border: TableBorder.all(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.black.withOpacity(0.5),
                                      style: BorderStyle.solid,
                                    ),
                                    headingRowHeight: 70,
                                    dataRowHeight: 56,
                                    columns: [
                                      DataColumn(
                                        label: Text(
                                          "Gereja",
                                          style: GoogleFonts.nunito(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 18,
                                          ),
                                        ),
                                      ),
                                      DataColumn(
                                        label: Text(
                                          "Kode",
                                          style: GoogleFonts.nunito(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 18,
                                          ),
                                        ),
                                      ),
                                      DataColumn(
                                        label: Text(
                                          "Tanggal",
                                          style: GoogleFonts.nunito(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 18,
                                          ),
                                        ),
                                      ),
                                      DataColumn(
                                        label: Text(
                                          "Deskripsi",
                                          style: GoogleFonts.nunito(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 18,
                                          ),
                                        ),
                                      ),
                                      DataColumn(
                                        label: Text(
                                          "Pemasukan",
                                          style: GoogleFonts.nunito(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 18,
                                          ),
                                        ),
                                      ),
                                      DataColumn(
                                        label: Text(
                                          "Pengeluaran",
                                          style: GoogleFonts.nunito(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 18,
                                          ),
                                        ),
                                      ),
                                    ],
                                    rows: List.generate(
                                      _rowList.length,
                                      (index) {
                                        return DataRow(
                                            color:
                                                MaterialStateColor.resolveWith(
                                              (states) {
                                                return index % 2 == 1
                                                    ? Colors.white
                                                    : primaryColor
                                                        .withOpacity(0.2);
                                              },
                                            ),
                                            cells: _rowList[index].cells);
                                      },
                                    ),
                                  ),
                          ),
                          const SizedBox(
                            width: 16,
                          ),
                          SizedBox(
                            width: 300,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                ToggleSwitch(
                                  initialLabelIndex: _indexFilterTanggal,
                                  totalSwitches: 4,
                                  labels: const [
                                    'Semua',
                                    'Hari',
                                    'Minggu',
                                    'Bulan'
                                  ],
                                  activeBgColor: [primaryColorVariant],
                                  activeFgColor: darkText,
                                  inactiveBgColor: Colors.grey[200],
                                  inactiveFgColor: darkText,
                                  dividerColor: Colors.white,
                                  animate: true,
                                  animationDuration: 250,
                                  onToggle: (index) {
                                    setState(() {
                                      _indexFilterTanggal = index!;
                                    });
                                    debugPrint(
                                        'switched to: $_indexFilterTanggal');
                                    if (_indexFilterTanggal == 0) {}
                                  },
                                ),
                                const SizedBox(
                                  height: 25,
                                ),
                                _filterTanggalField(),
                                const Divider(
                                  height: 56,
                                ),
                                responsiveText("Filter Gereja", 14,
                                    FontWeight.w700, darkText),
                                Card(
                                  color: primaryColor,
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  child: DropdownSearch<dynamic>(
                                    popupProps: PopupProps.menu(
                                      showSearchBox: true,
                                      searchFieldProps: TextFieldProps(
                                        decoration: InputDecoration(
                                          border: const OutlineInputBorder(),
                                          hintText: "Cari Disini",
                                          suffixIcon: IconButton(
                                            onPressed: () {
                                              //_controllerDropdownFilter.clear();
                                            },
                                            icon: Icon(
                                              Icons.clear,
                                              color:
                                                  Colors.black.withOpacity(0.5),
                                            ),
                                          ),
                                        ),
                                        //controller: _controllerDropdownFilter,
                                      ),
                                    ),
                                    //items: _kodePerkiraan,
                                    onChanged: (val) {},
                                    selectedItem: "pilih Kode Gereja",
                                  ),
                                ),
                                responsiveText("Filter Transaksi", 14,
                                    FontWeight.w700, darkText),
                                Card(
                                  color: primaryColor,
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  child: DropdownSearch<dynamic>(
                                    popupProps: PopupProps.menu(
                                      showSearchBox: true,
                                      searchFieldProps: TextFieldProps(
                                        decoration: InputDecoration(
                                          border: const OutlineInputBorder(),
                                          hintText: "Cari Disini",
                                          suffixIcon: IconButton(
                                            onPressed: () {},
                                            icon: Icon(
                                              Icons.clear,
                                              color:
                                                  Colors.black.withOpacity(0.5),
                                            ),
                                          ),
                                        ),
                                        //controller: _controllerDropdownFilter,
                                      ),
                                    ),
                                    //items: _kodeTransaksiAdded,
                                    onChanged: (val) {},
                                    selectedItem: "pilih Transaksi",
                                  ),
                                ),
                                responsiveText("Filter Kode Perkiraan", 14,
                                    FontWeight.w700, darkText),
                                Card(
                                  color: primaryColor,
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  child: DropdownSearch<dynamic>(
                                    popupProps: PopupProps.menu(
                                      showSearchBox: true,
                                      searchFieldProps: TextFieldProps(
                                        decoration: InputDecoration(
                                          border: const OutlineInputBorder(),
                                          hintText: "Cari Disini",
                                          suffixIcon: IconButton(
                                            onPressed: () {
                                              //_controllerDropdownFilter.clear();
                                            },
                                            icon: Icon(
                                              Icons.clear,
                                              color:
                                                  Colors.black.withOpacity(0.5),
                                            ),
                                          ),
                                        ),
                                        //controller: _controllerDropdownFilter,
                                      ),
                                    ),
                                    //items: _kodePerkiraan,
                                    onChanged: (val) {},
                                    selectedItem: "pilih Kode Perkiraan",
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AdminLaporanKeuangan extends StatefulWidget {
  final PageController controllerLaporan;
  const AdminLaporanKeuangan({super.key, required this.controllerLaporan});

  @override
  State<AdminLaporanKeuangan> createState() => _AdminLaporanKeuanganState();
}

class _AdminLaporanKeuanganState extends State<AdminLaporanKeuangan>
    with TickerProviderStateMixin {
  ServicesUser servicesUser = ServicesUser();
  late TabController _tabController;

  DateTime selectedMonth = DateTime.now();
  String formattedMonth = "";
  String month = "Month";

  late SignatureController controller;
  int _currentValue = 5;
  Color pickerColor = darkText;
  Color currentColor = darkText;

  Uint8List? exportedImage;

  String nama = "User";

  late Future getAktivaLancar;
  late Future getAktivaTetap;
  late Future getPasivaLancar;
  late Future getPasivaJangkaPanjang;

  @override
  void initState() {
    // TODO: implement initState
    getUserName(kodeUser);
    _tabController = TabController(length: 3, vsync: this);
    formattedMonth = DateFormat('MM-yyyy').format(selectedMonth);
    month = formattedMonth;
    controller = SignatureController(
        penStrokeWidth: 5,
        penColor: currentColor,
        exportBackgroundColor: Colors.transparent);
    getAktivaLancar =
        servicesUser.getNeraca(kodeGereja, month, "pemasukan", "lancar");
    getAktivaTetap =
        servicesUser.getNeraca(kodeGereja, month, "pemasukan", "tetap");
    getPasivaLancar =
        servicesUser.getNeraca(kodeGereja, month, "pengeluaran", "lancar");
    getPasivaJangkaPanjang = servicesUser.getNeraca(
        kodeGereja, month, "pengeluaran", "jangka panjang");

    _getNeracaTable(kodeGereja);
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  Future getUserName(userStatus) async {
    var response = await servicesUser.getSingleUser(userStatus);
    nama = response[1]['nama_lengkap_user'].toString();
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> selectMonth(context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      firstDate: DateTime(DateTime.now().year - 5, 1, 1),
      lastDate: DateTime(DateTime.now().year, 12, 31),
      initialDate: selectedMonth,
      builder: (context, child) {
        return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.light(
                primary: primaryColor, // header background color
                onPrimary: lightText, // header text color
                onSurface: darkText, // body text color
              ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  foregroundColor: navButtonPrimary, // button text color
                ),
              ),
            ),
            child: child!);
      },
    );
    if (picked != null && picked != selectedMonth) {
      if (mounted) {
        selectedMonth = picked;
        formattedMonth = DateFormat('MM-yyyy').format(selectedMonth);
        month = formattedMonth;
        debugPrint("Selected Month $month");
        setState(() {});
      }
    }
  }

  Future _getJurnalData(kodeGereja, month) async {
    _dataJurnal.clear();
    var tempKode = List.empty(growable: true);
    var tempData = List.empty(growable: true);
    var responseKode =
        await servicesUser.getKodeKegiatanJurnal(kodeGereja, month);
    if (responseKode[0] != 404) {
      for (var element in responseKode[1]) {
        var responseData = await servicesUser.getJurnal(
            kodeGereja, month, element['kode_transaksi']);

        for (var element in responseData[1]) {
          tempData.add(DateFormat('dd MMM').format(
            DateTime.parse(element['tanggal_transaksi']),
          ));
          tempData.add(element['nama_kode_perkiraan']);
          tempData.add(element['kode_kegiatan']);
          tempData.add(element['status']);
          tempData.add(element['jurnal']);
          tempKode.add(tempData.toList());
          tempData.clear();
        }
        _dataJurnal.add(tempKode.toList());
        tempKode.clear();
      }
    } else {
      throw "Gagal Mengambil Data";
    }
    debugPrint(_dataJurnal.toString());
  }

  void changeColor(Color color) {
    setState(() => pickerColor = color);
  }

  Future showPicker() {
    return showDialog(
      builder: (context) => AlertDialog(
        title: const Text('Pilih Warna Garis'),
        content: SingleChildScrollView(
          child: ColorPicker(
            pickerColor: pickerColor,
            onColorChanged: changeColor,
          ),
          // Use Material color picker:
          //
          // child: MaterialPicker(
          //     pickerColor: pickerColor, onColorChanged: changeColor),
          //
          // Use Block color picker:
          //
          // child: BlockPicker(
          //   pickerColor: currentColor,
          //   onColorChanged: changeColor,
          // ),
          //
          // child: MultipleChoiceBlockPicker(
          //   pickerColors: currentColors,
          //   onColorsChanged: changeColors,
          // ),
        ),
        actions: <Widget>[
          ElevatedButton(
              child: const Text('Ok'),
              onPressed: () {
                currentColor = pickerColor;
                Navigator.of(context).pop();
                controller = SignatureController(
                  penStrokeWidth: double.parse(_currentValue.toString()),
                  penColor: currentColor,
                );
                setState(() {});
              }),
        ],
      ),
      context: context,
    ).whenComplete(() {
      setState(() {});
    });
  }

  showAsign(dw, dh, tipe) {
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
                            children: [
                              IconButton(
                                onPressed: () {
                                  controller.clear();
                                  Navigator.pop(context);
                                },
                                icon: const Icon(
                                    Icons.arrow_back_ios_new_rounded),
                              ),
                              const SizedBox(
                                width: 25,
                              ),
                              responsiveText("Tanda Tangan", 26,
                                  FontWeight.w900, darkText),
                              const Spacer(),
                            ],
                          ),
                          const Divider(
                            thickness: 1,
                            height: 56,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              responsiveText(
                                  "Warna Garis", 16, FontWeight.w600, darkText),
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    showPicker();
                                    controller = SignatureController(
                                      penStrokeWidth: double.parse(
                                          _currentValue.toString()),
                                      penColor: currentColor,
                                    );
                                  });
                                },
                                icon: const Icon(Icons.color_lens),
                              ),
                            ],
                          ),
                          Center(
                            child: SizedBox(
                              height: 300,
                              width: dw,
                              child: Signature(
                                backgroundColor: primaryColor,
                                controller: controller,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          responsiveText(
                              "Ketebalan Garis", 16, FontWeight.w600, darkText),
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 15.0,
                                  vertical: 15.0,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFFFFFF),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: Colors.grey.shade200,
                                  ),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 15.0,
                                ),
                                alignment: Alignment.center,
                                height: 40,
                              ),
                              Positioned(
                                  child: Container(
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(50),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.shade300,
                                      blurRadius: 15.0,
                                      spreadRadius: 1.0,
                                      offset: const Offset(
                                        0.0,
                                        0.0,
                                      ),
                                    ),
                                  ],
                                ),
                              )),
                              Container(
                                alignment: Alignment.center,
                                child: NumberPicker(
                                  axis: Axis.horizontal,
                                  itemHeight: 45,
                                  itemWidth: 45.0,
                                  step: 1,
                                  selectedTextStyle: const TextStyle(
                                    fontSize: 20.0,
                                    color: Colors.blue,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  textStyle: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 12.0,
                                  ),
                                  itemCount: 7,
                                  value: _currentValue,
                                  minValue: 1,
                                  maxValue: 10,
                                  onChanged: (v) {
                                    setState(() {
                                      _currentValue = v;
                                    });
                                    controller = SignatureController(
                                      penStrokeWidth: double.parse(
                                          _currentValue.toString()),
                                      penColor: currentColor,
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  onPressed: () {
                                    controller.clear();
                                  },
                                  child: Text(
                                    "Hapus",
                                    style: GoogleFonts.nunito(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 14),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 15,
                              ),
                              Expanded(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  onPressed: () async {
                                    // exportedImage =
                                    //     await controller.toPngBytes();
                                    //API
                                    if (controller.isNotEmpty) {
                                      exportSignature(tipe);

                                      controller.clear();
                                    }
                                    setState(() {});
                                  },
                                  child: Text(
                                    "Lanjutkan",
                                    style: GoogleFonts.nunito(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 14),
                                  ),
                                ),
                              ),
                            ],
                          )
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
      setState(() {});
    });
  }

  exportSignature(int tipe) async {
    final exportController = SignatureController(
      penStrokeWidth: double.parse(_currentValue.toString()),
      penColor: currentColor,
      exportBackgroundColor: Colors.white,
      points: controller.points,
    );

    exportController.toPngBytes().then((value) {
      if (tipe == 0) {
        _getJurnalData(kodeGereja, month).whenComplete(
          () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return AdminLaporanPreviewPDF(
                    tipe: tipe,
                    month: month,
                    signature: value as Uint8List,
                    nama: nama,
                  );
                },
              ),
            );
          },
        );
      } else if (tipe == 1) {
        _getBukuBesarData(kodeGereja, month).whenComplete(
          () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return AdminLaporanPreviewPDF(
                    tipe: tipe,
                    month: month,
                    signature: value as Uint8List,
                    nama: nama,
                  );
                },
              ),
            );
          },
        );
      } else {
        _getNeraca(kodeGereja, month).whenComplete(
          () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return AdminLaporanPreviewPDF(
                    tipe: tipe,
                    month: month,
                    signature: value as Uint8List,
                    nama: nama,
                  );
                },
              ),
            );
          },
        );
      }
    });
    exportController.dispose();
  }

  jurnalUmumView(dw, dh) {
    return ScrollConfiguration(
      behavior: ScrollConfiguration.of(context).copyWith(
        dragDevices: {
          PointerDeviceKind.touch,
          PointerDeviceKind.mouse,
        },
      ),
      child: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        controller: ScrollController(),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () {
                    selectMonth(context);
                  },
                  child: Card(
                    color: primaryColor,
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          responsiveText(month, 14, FontWeight.w700, lightText),
                          const IconButton(
                            onPressed: null,
                            icon: Icon(Icons.calendar_month),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                ElevatedButton(
                  //TODO: search btn
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    backgroundColor: const Color(0xff960000),
                  ),
                  onPressed: () {
                    showAsign(dw, dh, 0);
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(4.0),
                    child: FaIcon(FontAwesomeIcons.solidFilePdf),
                  ),
                ),
              ],
            ),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    ListTile(
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: Text(
                              "Tanggal",
                              style: GoogleFonts.nunito(
                                  color: darkText,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16,
                                  letterSpacing: 0.125),
                            ),
                          ),
                          const SizedBox(width: 5),
                          Expanded(
                            flex: 2,
                            child: Text(
                              "Keterangan",
                              style: GoogleFonts.nunito(
                                  color: darkText,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16,
                                  letterSpacing: 0.125),
                            ),
                          ),
                          const SizedBox(width: 5),
                          Expanded(
                            flex: 2,
                            child: Text(
                              "Ref",
                              style: GoogleFonts.nunito(
                                  color: darkText,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16,
                                  letterSpacing: 0.125),
                            ),
                          ),
                          const SizedBox(width: 5),
                          Expanded(
                            flex: 2,
                            child: Text(
                              "Debit",
                              style: GoogleFonts.nunito(
                                  color: darkText,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16,
                                  letterSpacing: 0.125),
                            ),
                          ),
                          const SizedBox(width: 5),
                          Expanded(
                            flex: 2,
                            child: Text(
                              "Kredit",
                              style: GoogleFonts.nunito(
                                  color: darkText,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16,
                                  letterSpacing: 0.125),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      color: darkText.withOpacity(0.2),
                    ),
                    FutureBuilder(
                      future:
                          servicesUser.getKodeKegiatanJurnal(kodeGereja, month),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          List snapData = snapshot.data! as List;
                          debugPrint(snapData.toString());
                          debugPrint(snapData[1].length.toString());

                          if (snapData[0] != 404) {
                            return ListView.separated(
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              controller: ScrollController(),
                              physics: const ClampingScrollPhysics(),
                              itemCount: snapData[1].length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.only(
                                    bottom: 25,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Text(
                                      //   snapData[1][index]['kode_transaksi']
                                      //       .toString(),
                                      //   style: GoogleFonts.nunito(
                                      //       color: darkText,
                                      //       fontWeight: FontWeight.w800,
                                      //       fontSize: 18,
                                      //       letterSpacing: 0.125),
                                      // ),
                                      // const SizedBox(
                                      //   height: 16,
                                      // ),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: FutureBuilder(
                                              future: servicesUser.getJurnal(
                                                  kodeGereja,
                                                  month,
                                                  snapData[1][index]
                                                      ['kode_transaksi']),
                                              builder: (context, snapshot) {
                                                if (snapshot.hasData) {
                                                  List snapData =
                                                      snapshot.data! as List;
                                                  debugPrint(
                                                      snapData.toString());
                                                  debugPrint(snapData[1]
                                                      .length
                                                      .toString());
                                                  if (snapData[0] != 404) {
                                                    return ListView.builder(
                                                      shrinkWrap: true,
                                                      scrollDirection:
                                                          Axis.vertical,
                                                      controller:
                                                          ScrollController(),
                                                      physics:
                                                          const ClampingScrollPhysics(),
                                                      itemCount:
                                                          snapData[1].length,
                                                      itemBuilder:
                                                          (context, index) {
                                                        return ListTile(
                                                          title: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceEvenly,
                                                            children: [
                                                              Expanded(
                                                                child: Text(
                                                                  index != 0
                                                                      ? ""
                                                                      : DateFormat(
                                                                              'dd MMM')
                                                                          .format(
                                                                          DateTime.parse(snapData[1][index]
                                                                              [
                                                                              'tanggal_transaksi']),
                                                                        ),
                                                                  style: GoogleFonts.nunito(
                                                                      color:
                                                                          darkText,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                      fontSize:
                                                                          16,
                                                                      letterSpacing:
                                                                          0.125),
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                  width: 5),
                                                              Expanded(
                                                                flex: 2,
                                                                child: Text(
                                                                  snapData[1][index]
                                                                          [
                                                                          'nama_kode_perkiraan']
                                                                      .toString(),
                                                                  style: GoogleFonts.nunito(
                                                                      color:
                                                                          darkText,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                      fontSize:
                                                                          16,
                                                                      letterSpacing:
                                                                          0.125),
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                  width: 5),
                                                              Expanded(
                                                                flex: 2,
                                                                child: Text(
                                                                  snapData[1][index]
                                                                          [
                                                                          'kode_kegiatan']
                                                                      .toString(),
                                                                  style: GoogleFonts.nunito(
                                                                      color:
                                                                          darkText,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                      fontSize:
                                                                          16,
                                                                      letterSpacing:
                                                                          0.125),
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                  width: 5),
                                                              Expanded(
                                                                flex: 2,
                                                                child: snapData[1][index]
                                                                            [
                                                                            'status'] ==
                                                                        "pemasukan"
                                                                    ? Text(
                                                                        CurrencyFormatAkuntansi.convertToIdr(snapData[1][index]['jurnal'].abs(),
                                                                                2)
                                                                            .toString(),
                                                                        style: GoogleFonts.nunito(
                                                                            color:
                                                                                darkText,
                                                                            fontWeight: FontWeight
                                                                                .w600,
                                                                            fontSize:
                                                                                16,
                                                                            letterSpacing:
                                                                                0.125),
                                                                      )
                                                                    : const Text(
                                                                        ""),
                                                              ),
                                                              const SizedBox(
                                                                  width: 5),
                                                              Expanded(
                                                                flex: 2,
                                                                child: snapData[1][index]
                                                                            [
                                                                            'status'] ==
                                                                        "pengeluaran"
                                                                    ? Text(
                                                                        CurrencyFormatAkuntansi.convertToIdr(snapData[1][index]['jurnal'].abs(),
                                                                                2)
                                                                            .toString(),
                                                                        style: GoogleFonts.nunito(
                                                                            color:
                                                                                darkText,
                                                                            fontWeight: FontWeight
                                                                                .w600,
                                                                            fontSize:
                                                                                16,
                                                                            letterSpacing:
                                                                                0.125),
                                                                      )
                                                                    : const Text(
                                                                        ""),
                                                              ),
                                                            ],
                                                          ),
                                                        );
                                                      },
                                                    );
                                                  } else if (snapData[0] ==
                                                      404) {
                                                    return noDataFound();
                                                  }
                                                }
                                                return loadingAnimation();
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              },
                              separatorBuilder:
                                  (BuildContext context, int index) {
                                return Divider(
                                  height: 0,
                                  color: dividerColor.withOpacity(0.1),
                                );
                              },
                            );
                          }
                          if (snapData[0] == 404) {
                            return noDataFound();
                          }
                        }
                        return loadingAnimation();
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future _getBukuBesarData(kodeGereja, month) async {
    _dataBukuBesar.clear();
    var tempKode = List.empty(growable: true);
    var tempData = List.empty(growable: true);
    var responseKode = await servicesUser.getKodeBukuBesar(kodeGereja);
    if (responseKode[0] != 404) {
      for (var element in responseKode[1]) {
        var responseData = await servicesUser.getItemBukuBesar(kodeGereja,
            month, element['header_kode_perkiraan'], element['kode_perkiraan']);
        if (responseData[0] != 404) {
          for (var element in responseData[1]) {
            tempData.add(element['tanggal_transaksi']);
            tempData.add(element['uraian_transaksi']);
            tempData.add(element['jenis_transaksi']);
            tempData.add(element['nominal']);
            tempData.add(element['saldo']);
            tempData.add(element['kode_perkiraan']);
            tempKode.add(tempData.toList());
            tempData.clear();
          }
          _dataBukuBesar.add(tempKode.toList());
          tempKode.clear();
        } else {
          throw "Gagal Mengambil Data";
        }
      }
    } else {
      throw "Gagal Mengambil Data";
    }
  }

  bukuBesarView(dw, dh) {
    return ScrollConfiguration(
      behavior: ScrollConfiguration.of(context).copyWith(
        dragDevices: {
          PointerDeviceKind.touch,
          PointerDeviceKind.mouse,
        },
      ),
      child: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        controller: ScrollController(),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () {
                    selectMonth(context);
                  },
                  child: Card(
                    color: primaryColor,
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          responsiveText(month, 14, FontWeight.w700, lightText),
                          const IconButton(
                            onPressed: null,
                            icon: Icon(Icons.calendar_month),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                ElevatedButton(
                  //TODO: search btn
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    backgroundColor: const Color(0xff960000),
                  ),
                  onPressed: () {
                    showAsign(dw, dh, 1);
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(4.0),
                    child: FaIcon(FontAwesomeIcons.solidFilePdf),
                  ),
                ),
              ],
            ),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: FutureBuilder(
                  future: servicesUser.getKodeBukuBesar(kodeGereja),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      List snapData = snapshot.data! as List;
                      debugPrint(snapData.toString());
                      debugPrint(snapData[1].length.toString());

                      if (snapData[0] != 404) {
                        return ListView.separated(
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          controller: ScrollController(),
                          physics: const ClampingScrollPhysics(),
                          itemCount: snapData[1].length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(
                                bottom: 25,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    snapData[1][index]['kode_perkiraan']
                                        .toString(),
                                    style: GoogleFonts.nunito(
                                        color: darkText,
                                        fontWeight: FontWeight.w800,
                                        fontSize: 18,
                                        letterSpacing: 0.125),
                                  ),
                                  const SizedBox(
                                    height: 16,
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: FutureBuilder(
                                          future: servicesUser.getItemBukuBesar(
                                              kodeGereja,
                                              month,
                                              snapData[1][index]
                                                  ['header_kode_perkiraan'],
                                              snapData[1][index]
                                                  ['kode_perkiraan']),
                                          builder: (context, snapshot) {
                                            if (snapshot.hasData) {
                                              List snapData =
                                                  snapshot.data! as List;
                                              debugPrint(snapData.toString());
                                              debugPrint(snapData[1]
                                                  .length
                                                  .toString());
                                              if (snapData[0] != 404) {
                                                return Column(
                                                  children: [
                                                    ListTile(
                                                      title: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceEvenly,
                                                        children: [
                                                          Expanded(
                                                            child: Text(
                                                              "Tanggal",
                                                              style: GoogleFonts.nunito(
                                                                  color:
                                                                      darkText,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700,
                                                                  fontSize: 16,
                                                                  letterSpacing:
                                                                      0.125),
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                              width: 5),
                                                          Expanded(
                                                            flex: 2,
                                                            child: Text(
                                                              "Uraian",
                                                              style: GoogleFonts.nunito(
                                                                  color:
                                                                      darkText,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700,
                                                                  fontSize: 16,
                                                                  letterSpacing:
                                                                      0.125),
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                              width: 5),
                                                          Expanded(
                                                            child: Text(
                                                              "Debit",
                                                              style: GoogleFonts.nunito(
                                                                  color:
                                                                      darkText,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700,
                                                                  fontSize: 16,
                                                                  letterSpacing:
                                                                      0.125),
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                              width: 5),
                                                          Expanded(
                                                            child: Text(
                                                              "Kredit",
                                                              style: GoogleFonts.nunito(
                                                                  color:
                                                                      darkText,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700,
                                                                  fontSize: 16,
                                                                  letterSpacing:
                                                                      0.125),
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                              width: 5),
                                                          Expanded(
                                                            child: Text(
                                                              "Saldo",
                                                              style: GoogleFonts.nunito(
                                                                  color:
                                                                      darkText,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700,
                                                                  fontSize: 16,
                                                                  letterSpacing:
                                                                      0.125),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Divider(color: lightText),
                                                    ListView.builder(
                                                      shrinkWrap: true,
                                                      scrollDirection:
                                                          Axis.vertical,
                                                      controller:
                                                          ScrollController(),
                                                      physics:
                                                          const ClampingScrollPhysics(),
                                                      itemCount:
                                                          snapData[1].length,
                                                      itemBuilder:
                                                          (context, index) {
                                                        return ListTile(
                                                          title: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceEvenly,
                                                            children: [
                                                              Expanded(
                                                                child: Text(
                                                                  snapData[1][index]
                                                                          [
                                                                          'tanggal_transaksi']
                                                                      .toString(),
                                                                  style: GoogleFonts.nunito(
                                                                      color:
                                                                          darkText,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                      fontSize:
                                                                          16,
                                                                      letterSpacing:
                                                                          0.125),
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                  width: 5),
                                                              Expanded(
                                                                flex: 2,
                                                                child: Text(
                                                                  snapData[1][index]
                                                                          [
                                                                          'uraian_transaksi']
                                                                      .toString(),
                                                                  style: GoogleFonts.nunito(
                                                                      color:
                                                                          darkText,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                      fontSize:
                                                                          16,
                                                                      letterSpacing:
                                                                          0.125),
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                  width: 5),
                                                              Expanded(
                                                                child: snapData[1][index]
                                                                            [
                                                                            'jenis_transaksi'] ==
                                                                        "pemasukan"
                                                                    ? Text(
                                                                        CurrencyFormatAkuntansi.convertToIdr(snapData[1][index]['nominal'].abs(),
                                                                                2)
                                                                            .toString(),
                                                                        style: GoogleFonts.nunito(
                                                                            color:
                                                                                darkText,
                                                                            fontWeight: FontWeight
                                                                                .w600,
                                                                            fontSize:
                                                                                16,
                                                                            letterSpacing:
                                                                                0.125),
                                                                      )
                                                                    : const Text(
                                                                        ""),
                                                              ),
                                                              const SizedBox(
                                                                  width: 5),
                                                              Expanded(
                                                                child: snapData[1][index]
                                                                            [
                                                                            'jenis_transaksi'] ==
                                                                        "pengeluaran"
                                                                    ? Text(
                                                                        CurrencyFormatAkuntansi.convertToIdr(snapData[1][index]['nominal'].abs(),
                                                                                2)
                                                                            .toString(),
                                                                        style: GoogleFonts.nunito(
                                                                            color:
                                                                                darkText,
                                                                            fontWeight: FontWeight
                                                                                .w600,
                                                                            fontSize:
                                                                                16,
                                                                            letterSpacing:
                                                                                0.125),
                                                                      )
                                                                    : const Text(
                                                                        ""),
                                                              ),
                                                              const SizedBox(
                                                                  width: 5),
                                                              Expanded(
                                                                child: Text(
                                                                  CurrencyFormatAkuntansi.convertToIdr(
                                                                          snapData[1][index]['saldo']
                                                                              .abs(),
                                                                          2)
                                                                      .toString(),
                                                                  style: GoogleFonts.nunito(
                                                                      color:
                                                                          darkText,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                      fontSize:
                                                                          16,
                                                                      letterSpacing:
                                                                          0.125),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                  ],
                                                );
                                              } else {
                                                return noDataFound();
                                              }
                                            }
                                            return loadingAnimation();
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) {
                            return Divider(
                              height: 32,
                              color: dividerColor.withOpacity(0.5),
                            );
                          },
                        );
                      } else {
                        return noDataFound();
                      }
                    }
                    return loadingAnimation();
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future _getNeraca(kodeGereja, month) async {
    _pemasukanLancar.clear();
    _pemasukanTetap.clear();
    _pengeluaranLancar.clear();
    _pengeluaranJangkaPanjang.clear();

    var tempAktiva1 = List.empty(growable: true);
    var tempAktiva2 = List.empty(growable: true);
    var tempPasiva1 = List.empty(growable: true);
    var tempPasiva2 = List.empty(growable: true);

    var responseAktivaLancar =
        await servicesUser.getNeraca(kodeGereja, month, "pemasukan", "lancar");
    if (responseAktivaLancar[0] != 404) {
      for (var element in responseAktivaLancar[1]) {
        tempAktiva1.add(element['nama_kode_perkiraan']);
        tempAktiva1.add(element['saldo']);
        _pemasukanLancar.add(tempAktiva1.toList());
        tempAktiva1.clear();
      }
    }

    var responseAktivaTetap =
        await servicesUser.getNeraca(kodeGereja, month, "pemasukan", "tetap");
    if (responseAktivaTetap[0] != 404) {
      for (var element in responseAktivaTetap[1]) {
        tempAktiva2.add(element['nama_kode_perkiraan']);
        tempAktiva2.add(element['saldo']);
        _pemasukanTetap.add(tempAktiva2.toList());
        tempAktiva2.clear();
      }
    }

    var responsePasivaLancar = await servicesUser.getNeraca(
        kodeGereja, month, "pengeluaran", "lancar");
    if (responsePasivaLancar[0] != 404) {
      for (var element in responsePasivaLancar[1]) {
        tempPasiva1.add(element['nama_kode_perkiraan']);
        tempPasiva1.add(element['saldo']);
        _pengeluaranLancar.add(tempPasiva1.toList());
        tempPasiva1.clear();
      }
    }

    var responsePasivaJangkaPanjang = await servicesUser.getNeraca(
        kodeGereja, month, "pengeluaran", "jangka panjang");
    if (responsePasivaJangkaPanjang[0] != 404) {
      for (var element in responsePasivaJangkaPanjang[1]) {
        tempPasiva2.add(element['nama_kode_perkiraan']);
        tempPasiva2.add(element['saldo']);
        _pengeluaranJangkaPanjang.add(tempPasiva2.toList());
        tempPasiva2.clear();
      }
    }
  }

  neracaView(dw, dh) {
    return ScrollConfiguration(
      behavior: ScrollConfiguration.of(context).copyWith(
        dragDevices: {
          PointerDeviceKind.touch,
          PointerDeviceKind.mouse,
        },
      ),
      child: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        controller: ScrollController(),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () {
                    selectMonth(context).whenComplete(() {
                      getAktivaLancar = servicesUser.getNeraca(
                          kodeGereja, month, "pemasukan", "lancar");
                      getAktivaTetap = servicesUser.getNeraca(
                          kodeGereja, month, "pemasukan", "tetap");
                      getPasivaLancar = servicesUser.getNeraca(
                          kodeGereja, month, "pengeluaran", "lancar");
                      getPasivaJangkaPanjang = servicesUser.getNeraca(
                          kodeGereja, month, "pengeluaran", "jangka panjang");
                    });
                  },
                  child: Card(
                    color: primaryColor,
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          responsiveText(month, 14, FontWeight.w700, lightText),
                          const IconButton(
                            onPressed: null,
                            icon: Icon(Icons.calendar_month),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                ElevatedButton(
                  //TODO: search btn
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    backgroundColor: const Color(0xff960000),
                  ),
                  onPressed: () {
                    showAsign(dw, dh, 2);
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(4.0),
                    child: FaIcon(FontAwesomeIcons.solidFilePdf),
                  ),
                ),
              ],
            ),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              Text(
                                "Aktiva Lancar",
                                style: GoogleFonts.nunito(
                                    color: darkText,
                                    fontWeight: FontWeight.w900,
                                    fontSize: 18,
                                    letterSpacing: 0.125),
                              ),
                              Divider(
                                height: 16,
                                color: dividerColor,
                              ),
                              FutureBuilder(
                                future: getAktivaLancar,
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    List snapData = snapshot.data! as List;
                                    if (snapData[0] != 404) {
                                      return ListView.separated(
                                        shrinkWrap: true,
                                        scrollDirection: Axis.vertical,
                                        controller: ScrollController(),
                                        physics: const ClampingScrollPhysics(),
                                        itemCount: snapData.length,
                                        itemBuilder: (context, index) {
                                          return ListTile(
                                            title: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Expanded(
                                                  flex: 2,
                                                  child: Text(
                                                    snapData[1][index]
                                                        ['nama_kode_perkiraan'],
                                                    style: GoogleFonts.nunito(
                                                        color: darkText,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 16,
                                                        letterSpacing: 0.125),
                                                  ),
                                                ),
                                                const SizedBox(width: 5),
                                                Expanded(
                                                  child: Text(
                                                    CurrencyFormatAkuntansi
                                                            .convertToIdr(
                                                                snapData[1][index]
                                                                        [
                                                                        'saldo']
                                                                    .abs(),
                                                                2)
                                                        .toString(),
                                                    style: GoogleFonts.nunito(
                                                        color: darkText,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 16,
                                                        letterSpacing: 0.125),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                        separatorBuilder:
                                            (BuildContext context, int index) {
                                          return Divider(
                                            height: 32,
                                            color: lightText.withOpacity(0.5),
                                          );
                                        },
                                      );
                                    } else if (snapData[0] == 404) {
                                      return noDataFound();
                                    }
                                  }
                                  return loadingAnimation();
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            children: [
                              Text(
                                "Pasiva Lancar",
                                style: GoogleFonts.nunito(
                                    color: darkText,
                                    fontWeight: FontWeight.w900,
                                    fontSize: 18,
                                    letterSpacing: 0.125),
                              ),
                              Divider(
                                height: 16,
                                color: dividerColor,
                              ),
                              FutureBuilder(
                                future: getPasivaLancar,
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    List snapData = snapshot.data! as List;
                                    if (snapData[0] != 404) {
                                      return ListView.separated(
                                        shrinkWrap: true,
                                        scrollDirection: Axis.vertical,
                                        controller: ScrollController(),
                                        physics: const ClampingScrollPhysics(),
                                        itemCount: snapData.length,
                                        itemBuilder: (context, index) {
                                          return ListTile(
                                            title: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Expanded(
                                                  flex: 2,
                                                  child: Text(
                                                    snapData[1][index]
                                                        ['nama_kode_perkiraan'],
                                                    style: GoogleFonts.nunito(
                                                        color: darkText,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 16,
                                                        letterSpacing: 0.125),
                                                  ),
                                                ),
                                                const SizedBox(width: 5),
                                                Expanded(
                                                  child: Text(
                                                    CurrencyFormatAkuntansi
                                                            .convertToIdr(
                                                                snapData[1][index]
                                                                        [
                                                                        'saldo']
                                                                    .abs(),
                                                                2)
                                                        .toString(),
                                                    style: GoogleFonts.nunito(
                                                        color: darkText,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 16,
                                                        letterSpacing: 0.125),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                        separatorBuilder:
                                            (BuildContext context, int index) {
                                          return Divider(
                                            height: 32,
                                            color: lightText.withOpacity(0.5),
                                          );
                                        },
                                      );
                                    } else if (snapData[0] == 404) {
                                      return noDataFound();
                                    }
                                  }
                                  return loadingAnimation();
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 25),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              Text(
                                "Aktiva Tetap",
                                style: GoogleFonts.nunito(
                                    color: darkText,
                                    fontWeight: FontWeight.w900,
                                    fontSize: 18,
                                    letterSpacing: 0.125),
                              ),
                              Divider(
                                height: 16,
                                color: dividerColor,
                              ),
                              FutureBuilder(
                                future: getAktivaTetap,
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    List snapData = snapshot.data! as List;
                                    if (snapData[0] != 404) {
                                      return ListView.separated(
                                        shrinkWrap: true,
                                        scrollDirection: Axis.vertical,
                                        controller: ScrollController(),
                                        physics: const ClampingScrollPhysics(),
                                        itemCount: snapData.length,
                                        itemBuilder: (context, index) {
                                          return ListTile(
                                            title: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Expanded(
                                                  flex: 2,
                                                  child: Text(
                                                    snapData[1][index]
                                                        ['nama_kode_perkiraan'],
                                                    style: GoogleFonts.nunito(
                                                        color: darkText,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 16,
                                                        letterSpacing: 0.125),
                                                  ),
                                                ),
                                                const SizedBox(width: 5),
                                                Expanded(
                                                  child: Text(
                                                    CurrencyFormatAkuntansi
                                                            .convertToIdr(
                                                                snapData[1][index]
                                                                        [
                                                                        'saldo']
                                                                    .abs(),
                                                                2)
                                                        .toString(),
                                                    style: GoogleFonts.nunito(
                                                        color: darkText,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 16,
                                                        letterSpacing: 0.125),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                        separatorBuilder:
                                            (BuildContext context, int index) {
                                          return Divider(
                                            height: 32,
                                            color: lightText.withOpacity(0.5),
                                          );
                                        },
                                      );
                                    } else if (snapData[0] == 404) {
                                      return noDataFound();
                                    }
                                  }
                                  return loadingAnimation();
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            children: [
                              Text(
                                "Pasiva Janga Panjang",
                                style: GoogleFonts.nunito(
                                    color: darkText,
                                    fontWeight: FontWeight.w900,
                                    fontSize: 18,
                                    letterSpacing: 0.125),
                              ),
                              Divider(
                                height: 16,
                                color: dividerColor,
                              ),
                              FutureBuilder(
                                future: getPasivaJangkaPanjang,
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    List snapData = snapshot.data! as List;
                                    if (snapData[0] != 404) {
                                      return ListView.separated(
                                        shrinkWrap: true,
                                        scrollDirection: Axis.vertical,
                                        controller: ScrollController(),
                                        physics: const ClampingScrollPhysics(),
                                        itemCount: snapData.length,
                                        itemBuilder: (context, index) {
                                          return ListTile(
                                            title: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Expanded(
                                                  flex: 2,
                                                  child: Text(
                                                    snapData[1][index]
                                                        ['nama_kode_perkiraan'],
                                                    style: GoogleFonts.nunito(
                                                        color: darkText,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 16,
                                                        letterSpacing: 0.125),
                                                  ),
                                                ),
                                                const SizedBox(width: 5),
                                                Expanded(
                                                  child: Text(
                                                    CurrencyFormatAkuntansi
                                                            .convertToIdr(
                                                                snapData[1][index]
                                                                        [
                                                                        'saldo']
                                                                    .abs(),
                                                                2)
                                                        .toString(),
                                                    style: GoogleFonts.nunito(
                                                        color: darkText,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 16,
                                                        letterSpacing: 0.125),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                        separatorBuilder:
                                            (BuildContext context, int index) {
                                          return Divider(
                                            height: 32,
                                            color: lightText.withOpacity(0.5),
                                          );
                                        },
                                      );
                                    } else if (snapData[0] == 404) {
                                      return noDataFound();
                                    }
                                  }
                                  return loadingAnimation();
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future _getNeracaTable(kodeGereja) async {
    _neracaTable.clear();
    var response = await servicesUser.getTransaksi(kodeGereja);
    if (response[0] != 404) {
      for (var element in response[1]) {
        _addRowNeraca(
          element['kode_transaksi'],
          element['uraian_transaksi'],
          element['nominal'],
        );
      }
      if (mounted) {
        setState(() {});
      }
    }
  }

  void _addRowNeraca(kode, deskripsi, nominal) {
    _neracaTable.add(
      DataRow(
        cells: [
          DataCell(
            Text(
              kode.toString(),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          DataCell(
            Text(
              deskripsi.toString(),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          DataCell(
            Text(
              CurrencyFormatAkuntansi.convertToIdr(
                  int.parse(nominal.toString()), 2),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  neracaViewVer2(dw, dh) {
    return ScrollConfiguration(
      behavior: ScrollConfiguration.of(context).copyWith(
        dragDevices: {
          PointerDeviceKind.touch,
          PointerDeviceKind.mouse,
        },
      ),
      child: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        controller: ScrollController(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () {},
                  child: Card(
                    color: primaryColor,
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          responsiveText(month, 14, FontWeight.w700, lightText),
                          const IconButton(
                            onPressed: null,
                            icon: Icon(Icons.calendar_month),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                ElevatedButton(
                  //TODO: search btn
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    backgroundColor: const Color(0xff960000),
                  ),
                  onPressed: () {
                    showAsign(dw, dh, 2);
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(4.0),
                    child: FaIcon(FontAwesomeIcons.solidFilePdf),
                  ),
                ),
              ],
            ),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: dw > 1200
                    ? Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                DataTable(
                                  border: TableBorder.all(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.black.withOpacity(0.5),
                                    style: BorderStyle.solid,
                                  ),
                                  headingRowHeight: 70,
                                  dataRowHeight: 56,
                                  columns: [
                                    DataColumn(
                                      label: Text(
                                        "KODE ANGGARAN",
                                        style: GoogleFonts.nunito(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                    DataColumn(
                                      label: Text(
                                        "PENERIMAAN",
                                        style: GoogleFonts.nunito(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                    DataColumn(
                                      label: Text(
                                        "JUMLAH",
                                        style: GoogleFonts.nunito(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ],
                                  rows: List.generate(
                                    _neracaTable.length,
                                    (index) {
                                      return DataRow(
                                          color: MaterialStateColor.resolveWith(
                                            (states) {
                                              return index % 2 == 1
                                                  ? primaryColor
                                                      .withOpacity(0.2)
                                                  : Colors.white;
                                            },
                                          ),
                                          cells: _neracaTable[index].cells);
                                    },
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 25, vertical: 16),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                        "2.500.000,00",
                                        style: GoogleFonts.nunito(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                DataTable(
                                  border: TableBorder.all(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.black.withOpacity(0.5),
                                    style: BorderStyle.solid,
                                  ),
                                  headingRowHeight: 70,
                                  dataRowHeight: 56,
                                  columns: [
                                    DataColumn(
                                      label: Text(
                                        "KODE ANGGARAN",
                                        style: GoogleFonts.nunito(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                    DataColumn(
                                      label: Text(
                                        "PENGELUARAN",
                                        style: GoogleFonts.nunito(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                    DataColumn(
                                      label: Text(
                                        "JUMLAH",
                                        style: GoogleFonts.nunito(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ],
                                  rows: List.generate(
                                    _neracaTable.length,
                                    (index) {
                                      return DataRow(
                                          color: MaterialStateColor.resolveWith(
                                            (states) {
                                              return index % 2 == 1
                                                  ? primaryColor
                                                      .withOpacity(0.2)
                                                  : Colors.white;
                                            },
                                          ),
                                          cells: _neracaTable[index].cells);
                                    },
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 25, vertical: 16),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                        "2.500.000,00",
                                        style: GoogleFonts.nunito(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    : Column(children: [
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  DataTable(
                                    border: TableBorder.all(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.black.withOpacity(0.5),
                                      style: BorderStyle.solid,
                                    ),
                                    headingRowHeight: 70,
                                    dataRowHeight: 56,
                                    columns: [
                                      DataColumn(
                                        label: Text(
                                          "KODE ANGGARAN",
                                          style: GoogleFonts.nunito(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                      DataColumn(
                                        label: Text(
                                          "PENERIMAAN",
                                          style: GoogleFonts.nunito(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                      DataColumn(
                                        label: Text(
                                          "JUMLAH",
                                          style: GoogleFonts.nunito(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                    ],
                                    rows: List.generate(
                                      _neracaTable.length,
                                      (index) {
                                        return DataRow(
                                            color:
                                                MaterialStateColor.resolveWith(
                                              (states) {
                                                return index % 2 == 1
                                                    ? primaryColor
                                                        .withOpacity(0.2)
                                                    : Colors.white;
                                              },
                                            ),
                                            cells: _neracaTable[index].cells);
                                      },
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 25, vertical: 16),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          "2.500.000,00",
                                          style: GoogleFonts.nunito(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  DataTable(
                                    border: TableBorder.all(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.black.withOpacity(0.5),
                                      style: BorderStyle.solid,
                                    ),
                                    headingRowHeight: 70,
                                    dataRowHeight: 56,
                                    columns: [
                                      DataColumn(
                                        label: Text(
                                          "KODE ANGGARAN",
                                          style: GoogleFonts.nunito(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                      DataColumn(
                                        label: Text(
                                          "PENGELUARAN",
                                          style: GoogleFonts.nunito(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                      DataColumn(
                                        label: Text(
                                          "JUMLAH",
                                          style: GoogleFonts.nunito(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                    ],
                                    rows: List.generate(
                                      _neracaTable.length,
                                      (index) {
                                        return DataRow(
                                            color:
                                                MaterialStateColor.resolveWith(
                                              (states) {
                                                return index % 2 == 1
                                                    ? primaryColor
                                                        .withOpacity(0.2)
                                                    : Colors.white;
                                              },
                                            ),
                                            cells: _neracaTable[index].cells);
                                      },
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 25, vertical: 16),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          "2.500.000,00",
                                          style: GoogleFonts.nunito(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        widget.controllerLaporan.animateToPage(0,
                            duration: const Duration(milliseconds: 250),
                            curve: Curves.ease);
                      },
                      icon: const Icon(Icons.arrow_back_ios_new_rounded),
                    ),
                    const SizedBox(
                      width: 25,
                    ),
                    responsiveText(
                        "Laporan Keuangan", 26, FontWeight.w900, darkText),
                  ],
                ),
              ],
            ),
            const Divider(
              height: 56,
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  jurnalUmumView(deviceWidth, deviceHeight),
                  bukuBesarView(deviceWidth, deviceHeight),
                  neracaView(deviceWidth, deviceHeight),
                ],
              ),
            ),
            TabBar(
              controller: _tabController,
              isScrollable: true,
              labelColor: darkText,
              indicatorColor: buttonColor,
              labelPadding: const EdgeInsets.symmetric(horizontal: 16),
              labelStyle: GoogleFonts.nunito(
                  color: lightText,
                  fontWeight: FontWeight.w800,
                  fontSize: 14,
                  letterSpacing: 0.125),
              tabs: const <Widget>[
                Tab(
                  text: "Jurnal",
                ),
                Tab(
                  text: "Buku Besar",
                ),
                Tab(
                  text: "Neraca",
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class AdminLaporanPreviewPDF extends StatefulWidget {
  final int tipe;
  final String month;
  final Uint8List signature;
  final String nama;
  const AdminLaporanPreviewPDF(
      {super.key,
      required this.tipe,
      required this.month,
      required this.signature,
      required this.nama});

  @override
  State<AdminLaporanPreviewPDF> createState() => _AdminLaporanPreviewPDFState();
}

class _AdminLaporanPreviewPDFState extends State<AdminLaporanPreviewPDF> {
  ServicesUser servicesUser = ServicesUser();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  splitMonth(String val) {
    var split = val.indexOf("-");
    var month = val.substring(0, split);
    var year = val.substring(split + 1, val.length);
    return [month, year];
  }

  getMonth(String val) {
    var dt = splitMonth(val);
    if (dt[0] == "01") {
      return "Januari ${dt[1]}";
    } else if (dt[0] == "02") {
      return "Febriari ${dt[1]}";
    } else if (dt[0] == "03") {
      return "Maret ${dt[1]}";
    } else if (dt[0] == "04") {
      return "April ${dt[1]}";
    } else if (dt[0] == "05") {
      return "Mei ${dt[1]}";
    } else if (dt[0] == "06") {
      return "Juni ${dt[1]}";
    } else if (dt[0] == "07") {
      return "Juli ${dt[1]}";
    } else if (dt[0] == "08") {
      return "Agustus ${dt[1]}";
    } else if (dt[0] == "09") {
      return "September ${dt[1]}";
    } else if (dt[0] == "10") {
      return "Oktober ${dt[1]}";
    } else if (dt[0] == "11") {
      return "November ${dt[1]}";
    } else if (dt[0] == "12") {
      return "Desember ${dt[1]}";
    }
  }

  Future<Uint8List> _generateNeraca(PdfPageFormat format) async {
    final pdf = pw.Document(version: PdfVersion.pdf_1_5, compress: true);
    final headingFont = await PdfGoogleFonts.nunitoBold();
    final boldHeadingFont = await PdfGoogleFonts.nunitoExtraBold();
    final regularFont = await PdfGoogleFonts.nunitoRegular();

    final image = pw.MemoryImage(widget.signature);

    pdf.addPage(
      pw.MultiPage(
        pageFormat: format.portrait,
        build: (context) {
          return [
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.center,
              children: [
                pw.Text(
                  "LAPORAN KEUANGAN GEREJA $kodeGereja",
                  style: pw.TextStyle(
                    font: boldHeadingFont,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.center,
              children: [
                pw.Text(
                  "NERACA SALDO",
                  style: pw.TextStyle(
                    font: boldHeadingFont,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.center,
              children: [
                pw.Text(
                  getMonth(widget.month),
                  style: pw.TextStyle(
                    font: boldHeadingFont,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            pw.Divider(
              height: 56,
            ),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Column(
                  children: [
                    pw.Text(
                      "Aktiva Lancar",
                      style: pw.TextStyle(
                        font: headingFont,
                        fontSize: 14,
                      ),
                    ),
                    pw.SizedBox(
                      height: 10,
                    ),
                    pw.Table(
                      border: pw.TableBorder.all(
                        style: pw.BorderStyle.solid,
                        width: 1,
                      ),
                      columnWidths: {
                        0: const pw.FixedColumnWidth(110),
                        1: const pw.FixedColumnWidth(110),
                      },
                      children: [
                        //TODO: Header Table
                        pw.TableRow(
                          children: [
                            pw.Column(
                              children: [
                                pw.Text(
                                  "Kode",
                                  style: pw.TextStyle(
                                    font: headingFont,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                            pw.Column(
                              children: [
                                pw.Text(
                                  "Saldo",
                                  style: pw.TextStyle(
                                    font: headingFont,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        //TODO: Data Pemasukan

                        for (int i = 0; i < _pemasukanLancar.length; i++)
                          pw.TableRow(
                            children: [
                              pw.Column(
                                crossAxisAlignment: pw.CrossAxisAlignment.start,
                                mainAxisAlignment: pw.MainAxisAlignment.start,
                                children: [
                                  pw.Padding(
                                    padding: const pw.EdgeInsets.symmetric(
                                        horizontal: 5),
                                    child: pw.Text(
                                      "${_pemasukanLancar[i][0]}",
                                      style: pw.TextStyle(
                                        font: regularFont,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              pw.Column(
                                crossAxisAlignment: pw.CrossAxisAlignment.start,
                                mainAxisAlignment: pw.MainAxisAlignment.start,
                                children: [
                                  pw.Padding(
                                    padding: const pw.EdgeInsets.symmetric(
                                        horizontal: 5),
                                    child: pw.Text(
                                      CurrencyFormatAkuntansi.convertToIdr(
                                              _pemasukanLancar[i][1].abs(), 2)
                                          .toString(),
                                      style: pw.TextStyle(
                                        font: regularFont,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                      ],
                    ),
                  ],
                ),
                pw.Column(
                  children: [
                    pw.Text(
                      "Pasiva Lancar",
                      style: pw.TextStyle(
                        font: headingFont,
                        fontSize: 14,
                      ),
                    ),
                    pw.SizedBox(
                      height: 10,
                    ),
                    pw.Table(
                      border: pw.TableBorder.all(
                        style: pw.BorderStyle.solid,
                        width: 1,
                      ),
                      columnWidths: {
                        0: const pw.FixedColumnWidth(110),
                        1: const pw.FixedColumnWidth(110),
                      },
                      children: [
                        //TODO: Header Table
                        pw.TableRow(
                          children: [
                            pw.Column(
                              children: [
                                pw.Text(
                                  "Kode",
                                  style: pw.TextStyle(
                                    font: headingFont,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                            pw.Column(
                              children: [
                                pw.Text(
                                  "Saldo",
                                  style: pw.TextStyle(
                                    font: headingFont,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        //TODO: Data Pemasukan

                        for (int i = 0; i < _pengeluaranLancar.length; i++)
                          pw.TableRow(
                            children: [
                              pw.Column(
                                crossAxisAlignment: pw.CrossAxisAlignment.start,
                                mainAxisAlignment: pw.MainAxisAlignment.start,
                                children: [
                                  pw.Padding(
                                    padding: const pw.EdgeInsets.symmetric(
                                        horizontal: 5),
                                    child: pw.Text(
                                      "${_pengeluaranLancar[i][0]}",
                                      style: pw.TextStyle(
                                        font: regularFont,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              pw.Column(
                                crossAxisAlignment: pw.CrossAxisAlignment.start,
                                mainAxisAlignment: pw.MainAxisAlignment.start,
                                children: [
                                  pw.Padding(
                                    padding: const pw.EdgeInsets.symmetric(
                                        horizontal: 5),
                                    child: pw.Text(
                                      CurrencyFormatAkuntansi.convertToIdr(
                                              _pengeluaranLancar[i][1].abs(), 2)
                                          .toString(),
                                      style: pw.TextStyle(
                                        font: regularFont,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            pw.SizedBox(
              height: 56,
            ),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Column(
                  children: [
                    pw.Text(
                      "Aktiva Tetap",
                      style: pw.TextStyle(
                        font: headingFont,
                        fontSize: 14,
                      ),
                    ),
                    pw.SizedBox(
                      height: 10,
                    ),
                    pw.Table(
                      border: pw.TableBorder.all(
                        style: pw.BorderStyle.solid,
                        width: 1,
                      ),
                      columnWidths: {
                        0: const pw.FixedColumnWidth(110),
                        1: const pw.FixedColumnWidth(110),
                      },
                      children: [
                        //TODO: Header Table
                        pw.TableRow(
                          children: [
                            pw.Column(
                              children: [
                                pw.Text(
                                  "Kode",
                                  style: pw.TextStyle(
                                    font: headingFont,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                            pw.Column(
                              children: [
                                pw.Text(
                                  "Saldo",
                                  style: pw.TextStyle(
                                    font: headingFont,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        //TODO: Data Pemasukan

                        for (int i = 0; i < _pemasukanTetap.length; i++)
                          pw.TableRow(
                            children: [
                              pw.Column(
                                crossAxisAlignment: pw.CrossAxisAlignment.start,
                                mainAxisAlignment: pw.MainAxisAlignment.start,
                                children: [
                                  pw.Padding(
                                    padding: const pw.EdgeInsets.symmetric(
                                        horizontal: 5),
                                    child: pw.Text(
                                      "${_pemasukanTetap[i][0]}",
                                      style: pw.TextStyle(
                                        font: regularFont,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              pw.Column(
                                crossAxisAlignment: pw.CrossAxisAlignment.start,
                                mainAxisAlignment: pw.MainAxisAlignment.start,
                                children: [
                                  pw.Padding(
                                    padding: const pw.EdgeInsets.symmetric(
                                        horizontal: 5),
                                    child: pw.Text(
                                      CurrencyFormatAkuntansi.convertToIdr(
                                              _pemasukanTetap[i][1].abs(), 2)
                                          .toString(),
                                      style: pw.TextStyle(
                                        font: regularFont,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                      ],
                    ),
                  ],
                ),
                pw.Column(
                  children: [
                    pw.Text(
                      "Pasiva Jangka Panjang",
                      style: pw.TextStyle(
                        font: headingFont,
                        fontSize: 14,
                      ),
                    ),
                    pw.SizedBox(
                      height: 10,
                    ),
                    pw.Table(
                      border: pw.TableBorder.all(
                        style: pw.BorderStyle.solid,
                        width: 1,
                      ),
                      columnWidths: {
                        0: const pw.FixedColumnWidth(110),
                        1: const pw.FixedColumnWidth(110),
                      },
                      children: [
                        //TODO: Header Table
                        pw.TableRow(
                          children: [
                            pw.Column(
                              children: [
                                pw.Text(
                                  "Kode",
                                  style: pw.TextStyle(
                                    font: headingFont,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                            pw.Column(
                              children: [
                                pw.Text(
                                  "Saldo",
                                  style: pw.TextStyle(
                                    font: headingFont,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        //TODO: Data Pemasukan

                        for (int i = 0;
                            i < _pengeluaranJangkaPanjang.length;
                            i++)
                          pw.TableRow(
                            children: [
                              pw.Column(
                                crossAxisAlignment: pw.CrossAxisAlignment.start,
                                mainAxisAlignment: pw.MainAxisAlignment.start,
                                children: [
                                  pw.Padding(
                                    padding: const pw.EdgeInsets.symmetric(
                                        horizontal: 5),
                                    child: pw.Text(
                                      "${_pengeluaranJangkaPanjang[i][0]}",
                                      style: pw.TextStyle(
                                        font: regularFont,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              pw.Column(
                                crossAxisAlignment: pw.CrossAxisAlignment.start,
                                mainAxisAlignment: pw.MainAxisAlignment.start,
                                children: [
                                  pw.Padding(
                                    padding: const pw.EdgeInsets.symmetric(
                                        horizontal: 5),
                                    child: pw.Text(
                                      CurrencyFormatAkuntansi.convertToIdr(
                                              _pengeluaranJangkaPanjang[i][1]
                                                  .abs(),
                                              2)
                                          .toString(),
                                      style: pw.TextStyle(
                                        font: regularFont,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            pw.SizedBox(
              height: 56,
            ),
            pw.Container(
              child: pw.Row(
                children: [
                  pw.Expanded(
                    child: pw.Container(),
                  ),
                  pw.Column(
                    mainAxisAlignment: pw.MainAxisAlignment.end,
                    children: [
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.center,
                        children: [
                          pw.Text("Penanggung Jawab, "),
                        ],
                      ),
                      pw.SizedBox(
                        height: 5,
                      ),
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.center,
                        children: [
                          pw.SizedBox(
                            width: 200,
                            height: 200,
                            child: pw.Image(image),
                          ),
                        ],
                      ),
                      pw.SizedBox(
                        height: 5,
                      ),
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.center,
                        children: [
                          pw.Text(widget.nama),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ];
        },
      ),
    );

    return pdf.save();
  }

  Future<Uint8List> _generateBukuBesar(PdfPageFormat format) async {
    final pdf = pw.Document(version: PdfVersion.pdf_1_5, compress: true);
    final headingFont = await PdfGoogleFonts.nunitoBold();
    final boldHeadingFont = await PdfGoogleFonts.nunitoExtraBold();
    final regularFont = await PdfGoogleFonts.nunitoRegular();

    final image = pw.MemoryImage(widget.signature);

    pdf.addPage(
      pw.MultiPage(
        pageFormat: format.portrait,
        build: (context) {
          return [
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.center,
              children: [
                pw.Text(
                  "LAPORAN KEUANGAN GEREJA $kodeGereja",
                  style: pw.TextStyle(
                    font: boldHeadingFont,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.center,
              children: [
                pw.Text(
                  "BUKU BESAR",
                  style: pw.TextStyle(
                    font: boldHeadingFont,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.center,
              children: [
                pw.Text(
                  getMonth(widget.month),
                  style: pw.TextStyle(
                    font: boldHeadingFont,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            pw.Divider(
              height: 56,
            ),
            pw.ListView.separated(
                itemBuilder: (context, index) {
                  return pw.Column(
                    children: [
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.start,
                        children: [
                          pw.Text(
                            "${_dataBukuBesar[index][0][5]}",
                            style: pw.TextStyle(
                              font: boldHeadingFont,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      pw.Table(
                        border: pw.TableBorder.all(
                          style: pw.BorderStyle.solid,
                          width: 1,
                        ),
                        columnWidths: {
                          0: const pw.FixedColumnWidth(80),
                          1: const pw.FlexColumnWidth(3),
                          2: const pw.FractionColumnWidth(.2),
                          3: const pw.FractionColumnWidth(.2),
                          4: const pw.FractionColumnWidth(.2),
                        },
                        children: [
                          //TODO: Header Table
                          pw.TableRow(
                            children: [
                              pw.Column(
                                children: [
                                  pw.Text(
                                    "Tanggal",
                                    style: pw.TextStyle(
                                      font: headingFont,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                              pw.Column(
                                children: [
                                  pw.Text(
                                    "Uraian",
                                    style: pw.TextStyle(
                                      font: headingFont,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                              pw.Column(
                                children: [
                                  pw.Text(
                                    "Debit",
                                    style: pw.TextStyle(
                                      font: headingFont,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                              pw.Column(
                                children: [
                                  pw.Text(
                                    "Kredit",
                                    style: pw.TextStyle(
                                      font: headingFont,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                              pw.Column(
                                children: [
                                  pw.Text(
                                    "Saldo",
                                    style: pw.TextStyle(
                                      font: headingFont,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          //TODO: Data Pemasukan

                          for (int i = 0; i < _dataBukuBesar[index].length; i++)
                            pw.TableRow(
                              children: [
                                pw.Column(
                                  crossAxisAlignment:
                                      pw.CrossAxisAlignment.start,
                                  mainAxisAlignment: pw.MainAxisAlignment.start,
                                  children: [
                                    pw.Padding(
                                      padding: const pw.EdgeInsets.symmetric(
                                          horizontal: 5),
                                      child: pw.Text(
                                        "${_dataBukuBesar[index][i][0]}",
                                        style: pw.TextStyle(
                                          font: regularFont,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                pw.Column(
                                  crossAxisAlignment:
                                      pw.CrossAxisAlignment.start,
                                  mainAxisAlignment: pw.MainAxisAlignment.start,
                                  children: [
                                    pw.Padding(
                                      padding: const pw.EdgeInsets.symmetric(
                                          horizontal: 5),
                                      child: pw.Text(
                                        "${_dataBukuBesar[index][i][1]}",
                                        style: pw.TextStyle(
                                          font: regularFont,
                                          fontSize: 12,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                pw.Column(
                                  crossAxisAlignment:
                                      pw.CrossAxisAlignment.start,
                                  mainAxisAlignment: pw.MainAxisAlignment.start,
                                  children: [
                                    _dataBukuBesar[index][i][2] == "pemasukan"
                                        ? pw.Padding(
                                            padding:
                                                const pw.EdgeInsets.symmetric(
                                                    horizontal: 5),
                                            child: pw.Text(
                                              CurrencyFormatAkuntansi
                                                      .convertToIdr(
                                                          _dataBukuBesar[index]
                                                                  [i][3]
                                                              .abs(),
                                                          2)
                                                  .toString(),
                                              style: pw.TextStyle(
                                                font: regularFont,
                                                fontSize: 12,
                                              ),
                                            ),
                                          )
                                        : pw.Padding(
                                            padding:
                                                const pw.EdgeInsets.symmetric(
                                                    horizontal: 5),
                                            child: pw.Text(
                                              "",
                                              style: pw.TextStyle(
                                                font: regularFont,
                                                fontSize: 12,
                                              ),
                                            ),
                                          )
                                  ],
                                ),
                                pw.Column(
                                  crossAxisAlignment:
                                      pw.CrossAxisAlignment.start,
                                  mainAxisAlignment: pw.MainAxisAlignment.start,
                                  children: [
                                    _dataBukuBesar[index][i][2] == "pengeluaran"
                                        ? pw.Padding(
                                            padding:
                                                const pw.EdgeInsets.symmetric(
                                                    horizontal: 5),
                                            child: pw.Text(
                                              CurrencyFormatAkuntansi
                                                      .convertToIdr(
                                                          _dataBukuBesar[index]
                                                                  [i][3]
                                                              .abs(),
                                                          2)
                                                  .toString(),
                                              style: pw.TextStyle(
                                                font: regularFont,
                                                fontSize: 12,
                                              ),
                                            ),
                                          )
                                        : pw.Padding(
                                            padding:
                                                const pw.EdgeInsets.symmetric(
                                                    horizontal: 5),
                                            child: pw.Text(
                                              "",
                                              style: pw.TextStyle(
                                                font: regularFont,
                                                fontSize: 12,
                                              ),
                                            ),
                                          )
                                  ],
                                ),
                                pw.Column(
                                  crossAxisAlignment:
                                      pw.CrossAxisAlignment.start,
                                  mainAxisAlignment: pw.MainAxisAlignment.start,
                                  children: [
                                    pw.Padding(
                                      padding: const pw.EdgeInsets.symmetric(
                                          horizontal: 5),
                                      child: pw.Text(
                                        CurrencyFormatAkuntansi.convertToIdr(
                                                _dataBukuBesar[index][i][4]
                                                    .abs(),
                                                2)
                                            .toString(),
                                        style: pw.TextStyle(
                                          font: regularFont,
                                          fontSize: 12,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                        ],
                      ),
                    ],
                  );
                },
                separatorBuilder: (context, index) {
                  return pw.Divider(height: 56, color: PdfColors.grey200);
                },
                itemCount: _dataBukuBesar.length),
            pw.SizedBox(
              height: 56,
            ),
            pw.Container(
              child: pw.Row(
                children: [
                  pw.Expanded(
                    child: pw.Container(),
                  ),
                  pw.Column(
                    mainAxisAlignment: pw.MainAxisAlignment.end,
                    children: [
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.center,
                        children: [
                          pw.Text("Penanggung Jawab, "),
                        ],
                      ),
                      pw.SizedBox(
                        height: 5,
                      ),
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.center,
                        children: [
                          pw.SizedBox(
                            width: 200,
                            height: 200,
                            child: pw.Image(image),
                          ),
                        ],
                      ),
                      pw.SizedBox(
                        height: 5,
                      ),
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.center,
                        children: [
                          pw.Text(widget.nama),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ];
        },
      ),
    );

    return pdf.save();
  }

  Future<Uint8List> _generateJurnal(PdfPageFormat format) async {
    final pdf = pw.Document(version: PdfVersion.pdf_1_5, compress: true);
    final headingFont = await PdfGoogleFonts.nunitoBold();
    final boldHeadingFont = await PdfGoogleFonts.nunitoExtraBold();
    final regularFont = await PdfGoogleFonts.nunitoRegular();

    final image = pw.MemoryImage(widget.signature);

    pdf.addPage(
      pw.MultiPage(
        pageFormat: format.portrait,
        build: (context) {
          return [
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.center,
              children: [
                pw.Text(
                  "LAPORAN KEUANGAN GEREJA $kodeGereja",
                  style: pw.TextStyle(
                    font: boldHeadingFont,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.center,
              children: [
                pw.Text(
                  "JURNAL",
                  style: pw.TextStyle(
                    font: boldHeadingFont,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.center,
              children: [
                pw.Text(
                  getMonth(widget.month),
                  style: pw.TextStyle(
                    font: boldHeadingFont,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            pw.Divider(
              height: 56,
            ),
            pw.ListView.separated(
                itemBuilder: (context, index) {
                  return pw.Column(
                    children: [
                      pw.Table(
                        border: pw.TableBorder.all(
                          style: pw.BorderStyle.solid,
                          width: 1,
                        ),
                        columnWidths: {
                          0: const pw.FixedColumnWidth(80),
                          1: const pw.FlexColumnWidth(.3),
                          2: const pw.FlexColumnWidth(.3),
                          3: const pw.FractionColumnWidth(.2),
                          4: const pw.FractionColumnWidth(.2),
                        },
                        children: [
                          //TODO: Header Table
                          pw.TableRow(
                            children: [
                              pw.Column(
                                children: [
                                  pw.Text(
                                    "Tanggal",
                                    style: pw.TextStyle(
                                      font: headingFont,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                              pw.Column(
                                children: [
                                  pw.Text(
                                    "Keterangan",
                                    style: pw.TextStyle(
                                      font: headingFont,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                              pw.Column(
                                children: [
                                  pw.Text(
                                    "Ref",
                                    style: pw.TextStyle(
                                      font: headingFont,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                              pw.Column(
                                children: [
                                  pw.Text(
                                    "Debit",
                                    style: pw.TextStyle(
                                      font: headingFont,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                              pw.Column(
                                children: [
                                  pw.Text(
                                    "Kredit",
                                    style: pw.TextStyle(
                                      font: headingFont,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          //TODO: Data Pemasukan

                          for (int i = 0; i < _dataJurnal[index].length; i++)
                            pw.TableRow(
                              children: [
                                pw.Column(
                                  crossAxisAlignment:
                                      pw.CrossAxisAlignment.start,
                                  mainAxisAlignment: pw.MainAxisAlignment.start,
                                  children: [
                                    pw.Padding(
                                      padding: const pw.EdgeInsets.symmetric(
                                          horizontal: 5),
                                      child: pw.Text(
                                        i == 0
                                            ? "${_dataJurnal[index][i][0]}"
                                            : "",
                                        style: pw.TextStyle(
                                          font: regularFont,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                pw.Column(
                                  crossAxisAlignment:
                                      pw.CrossAxisAlignment.start,
                                  mainAxisAlignment: pw.MainAxisAlignment.start,
                                  children: [
                                    pw.Padding(
                                      padding: const pw.EdgeInsets.symmetric(
                                          horizontal: 5),
                                      child: pw.Text(
                                        "${_dataJurnal[index][i][1]}",
                                        style: pw.TextStyle(
                                          font: regularFont,
                                          fontSize: 12,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                pw.Column(
                                  crossAxisAlignment:
                                      pw.CrossAxisAlignment.start,
                                  mainAxisAlignment: pw.MainAxisAlignment.start,
                                  children: [
                                    pw.Padding(
                                      padding: const pw.EdgeInsets.symmetric(
                                          horizontal: 5),
                                      child: pw.Text(
                                        "${_dataJurnal[index][i][2]}",
                                        style: pw.TextStyle(
                                          font: regularFont,
                                          fontSize: 12,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                pw.Column(
                                  crossAxisAlignment:
                                      pw.CrossAxisAlignment.start,
                                  mainAxisAlignment: pw.MainAxisAlignment.start,
                                  children: [
                                    _dataJurnal[index][i][3] == "pemasukan"
                                        ? pw.Padding(
                                            padding:
                                                const pw.EdgeInsets.symmetric(
                                                    horizontal: 5),
                                            child: pw.Text(
                                              CurrencyFormatAkuntansi
                                                      .convertToIdr(
                                                          _dataJurnal[index][i]
                                                                  [4]
                                                              .abs(),
                                                          2)
                                                  .toString(),
                                              style: pw.TextStyle(
                                                font: regularFont,
                                                fontSize: 12,
                                              ),
                                            ),
                                          )
                                        : pw.Padding(
                                            padding:
                                                const pw.EdgeInsets.symmetric(
                                                    horizontal: 5),
                                            child: pw.Text(
                                              "",
                                              style: pw.TextStyle(
                                                font: regularFont,
                                                fontSize: 12,
                                              ),
                                            ),
                                          )
                                  ],
                                ),
                                pw.Column(
                                  crossAxisAlignment:
                                      pw.CrossAxisAlignment.start,
                                  mainAxisAlignment: pw.MainAxisAlignment.start,
                                  children: [
                                    _dataJurnal[index][i][3] == "pengeluaran"
                                        ? pw.Padding(
                                            padding:
                                                const pw.EdgeInsets.symmetric(
                                                    horizontal: 5),
                                            child: pw.Text(
                                              CurrencyFormatAkuntansi
                                                      .convertToIdr(
                                                          _dataJurnal[index][i]
                                                                  [4]
                                                              .abs(),
                                                          2)
                                                  .toString(),
                                              style: pw.TextStyle(
                                                font: regularFont,
                                                fontSize: 12,
                                              ),
                                            ),
                                          )
                                        : pw.Padding(
                                            padding:
                                                const pw.EdgeInsets.symmetric(
                                                    horizontal: 5),
                                            child: pw.Text(
                                              "",
                                              style: pw.TextStyle(
                                                font: regularFont,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                  ],
                                ),
                              ],
                            ),
                        ],
                      ),
                    ],
                  );
                },
                separatorBuilder: (context, index) {
                  return pw.Divider(height: 56, color: PdfColors.grey200);
                },
                itemCount: _dataJurnal.length),
            pw.SizedBox(
              height: 56,
            ),
            pw.Container(
              child: pw.Row(
                children: [
                  pw.Expanded(
                    child: pw.Container(),
                  ),
                  pw.Column(
                    mainAxisAlignment: pw.MainAxisAlignment.end,
                    children: [
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.center,
                        children: [
                          pw.Text("Penanggung Jawab, "),
                        ],
                      ),
                      pw.SizedBox(
                        height: 10,
                      ),
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.center,
                        children: [
                          pw.SizedBox(
                            width: 200,
                            height: 200,
                            child: pw.Image(image),
                          ),
                        ],
                      ),
                      pw.SizedBox(
                        height: 10,
                      ),
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.center,
                        children: [
                          pw.Text(widget.nama),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ];
        },
      ),
    );

    return pdf.save();
  }

  checkTipe(tipe, format) {
    if (tipe == 0) {
      return _generateJurnal(format);
    } else if (tipe == 1) {
      return _generateBukuBesar(format);
    } else {
      return _generateNeraca(format);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
      ),
      body: PdfPreview(
        initialPageFormat: PdfPageFormat.a4,
        allowPrinting: false,
        pdfFileName: "Laporan_Keuangan_Gereja.pdf",
        dynamicLayout: false,
        build: (format) => checkTipe(widget.tipe, format),
      ),
    );
  }
}
