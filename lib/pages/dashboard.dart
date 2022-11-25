//ignore_for_file: todo
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kg_pusat/globals.dart';
import 'package:kg_pusat/main.dart';
import 'package:kg_pusat/pages/cabang/cabang.dart';
import 'package:kg_pusat/pages/home/home.dart';
import 'package:kg_pusat/pages/keuangan/keuangan.dart';
import 'package:kg_pusat/pages/setting/pengaturan.dart';
import 'package:kg_pusat/themes/colors.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sidebarx/sidebarx.dart';

//TODO: Dashboard Navigation
class DashboardNavigation extends StatefulWidget {
  const DashboardNavigation({super.key});

  @override
  State<DashboardNavigation> createState() => _DashboardNavigationState();
}

class _DashboardNavigationState extends State<DashboardNavigation> {
  final _controllerSidebarX =
      SidebarXController(selectedIndex: 0, extended: true);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controllerSidebarX.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: deviceWidth < 800
          ? AppBar(
              iconTheme: IconThemeData(
                color: navButtonPrimaryVariant,
              ),
            )
          : null,
      body: Row(
        children: [
          if (deviceWidth > 800)
            NavigationSidebarX(controller: _controllerSidebarX),
          Expanded(
            child: Center(
              child: NavigationScreen(
                controller: _controllerSidebarX,
              ),
            ),
          ),
        ],
      ),
      drawerEnableOpenDragGesture: false,
      drawer: NavigationSidebarX(
        controller: _controllerSidebarX,
      ),
    );
  }
}

//TODO: SidebarX
class NavigationSidebarX extends StatelessWidget {
  final SidebarXController _controller;
  const NavigationSidebarX({
    Key? key,
    required SidebarXController controller,
  })  : _controller = controller,
        super(key: key);

  Future<void> signOut() async {
    final prefs = await SharedPreferences.getInstance();
    userStatus = false;
    kodeUser = "";
    kodeGereja = "";
    prefs.setBool('userStatus', userStatus);
    prefs.setString('kodeUser', kodeUser);
    prefs.setString('kodeGereja', kodeGereja);
  }

  @override
  Widget build(BuildContext context) {
    return SidebarX(
      animationDuration: const Duration(milliseconds: 400),
      controller: _controller,
      theme: SidebarXTheme(
        decoration: BoxDecoration(
          color: primaryColor,
        ),
        textStyle: GoogleFonts.nunito(
          color: navButtonPrimaryVariant,
          fontSize: 16,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.5,
        ),
        selectedTextStyle: GoogleFonts.nunito(
          color: navButtonPrimary,
          fontSize: 16,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.5,
        ),
        iconTheme: IconThemeData(
          color: navButtonPrimaryVariant,
          size: 24,
        ),
        selectedIconTheme: IconThemeData(
          color: navButtonPrimary,
          size: 24,
        ),
        itemTextPadding: const EdgeInsets.only(left: 20),
        selectedItemTextPadding: const EdgeInsets.only(left: 30),
        selectedItemDecoration: BoxDecoration(
          color: scaffoldBackgroundColor.withOpacity(0.4),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.transparent),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 5,
            )
          ],
        ),
      ),
      extendedTheme: SidebarXTheme(
        width: 200,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: primaryColor,
        ),
      ),
      headerDivider:
          Divider(color: navButtonPrimary.withOpacity(0.1), height: 1),
      headerBuilder: (context, extended) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: FittedBox(
            child: Image.asset(
              'lib/assets/images/KG_Logo.png',
              width: 56,
              height: 56,
            ),
          ),
        );
      },
      footerDivider:
          Divider(color: navButtonPrimary.withOpacity(0.1), height: 1),
      footerBuilder: (context, extended) {
        return Align(
          alignment: extended == true ? Alignment.centerLeft : Alignment.center,
          child: FittedBox(
            alignment: Alignment.centerLeft,
            child: Align(
              child: Padding(
                padding: EdgeInsets.only(
                    top: 10, bottom: 10, left: extended == true ? 12 : 0),
                child: GestureDetector(
                  onTap: () {
                    signOut().then((value) {
                      context.read<UserAuth>().setIsLoggedIn(false);
                    });
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.logout_rounded,
                        color: navButtonPrimaryVariant,
                        size: 24,
                      ),
                      Visibility(
                        visible: extended == true ? true : false,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 30),
                          child: Text(
                            'Keluar',
                            style: GoogleFonts.nunito(
                              color: navButtonPrimaryVariant,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
      items: const [
        // SidebarXItem(
        //   icon: Icons.home_rounded,
        //   label: 'Dashboard',
        // ),
        SidebarXItem(
          icon: Icons.wallet_rounded,
          label: 'Keuangan',
        ),
        SidebarXItem(
          icon: Icons.people,
          label: 'Cabang',
        ),
        // SidebarXItem(
        //   icon: Icons.settings,
        //   label: 'Pengaturan',
        // ),
      ],
    );
  }
}

class NavigationScreen extends StatelessWidget {
  final SidebarXController controller;
  const NavigationScreen({Key? key, required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        switch (controller.selectedIndex) {
          // case 0:
          //   return const HomePage();
          case 0:
            return const KeuanganControllerPage();
          case 1:
            return const AdminControllerCabangPage();
          // case 3:
          //   return const PengaturanPage();
          default:
            return const Text(
              "Halaman Ini Belum Tersedia",
            );
        }
      },
    );
  }
}
