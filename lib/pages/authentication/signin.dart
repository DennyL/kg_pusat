//ignore_for_file: todo
import 'package:flutter/material.dart';
import 'package:kg_pusat/globals.dart';
import 'package:kg_pusat/main.dart';
import 'package:kg_pusat/services/apiservices.dart';
import 'package:kg_pusat/themes/colors.dart';
import 'package:kg_pusat/widgets/widgets/responsivetext.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  ServicesUser servicesUser = ServicesUser();
  final _controllerUsername = TextEditingController();
  final _controllerPassword = TextEditingController();
  bool _passwordVisible = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controllerUsername.dispose();
    _controllerPassword.dispose();
    super.dispose();
  }

  Future getAuth(username, password) async {
    var response = await servicesUser.getAuth(username, password);
    final prefs = await SharedPreferences.getInstance();

    if (response[0] != 404) {
      var resp = await servicesUser.getKodeGereja(response[1]['kode_user']);
      if (resp[0] != 404) {
        userStatus = true;
        kodeUser = response[1]['kode_user'].toString();
        kodeGereja = resp[1]['kode_gereja'].toString();
        prefs.setBool('userStatus', userStatus);
        prefs.setString('kodeUser', kodeUser);
        prefs.setString('kodeGereja', kodeGereja);
      }
      return true;
    } else {
      return false;
    }
  }

  imgBG(deviceWidth, deviceHeight) {
    if (deviceWidth < 800) {
      return deviceWidth;
    } else {
      return deviceHeight * 0.8;
    }
  }

  void _passwordVisibility() {
    if (mounted) {
      setState(() {
        _passwordVisible = !_passwordVisible;
      });
    }
  }

  responsiveTextField(deviceWidth, deviceHeight, controllerText, pw) {
    if (deviceWidth < 800) {
      return Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        child: TextField(
          controller: controllerText,
          obscureText: pw ? _passwordVisible : false,
          decoration: InputDecoration(
            filled: true,
            fillColor: surfaceColor,
            contentPadding:
                const EdgeInsets.symmetric(vertical: 0, horizontal: 25),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: const BorderSide(
                color: Colors.transparent,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: const BorderSide(
                color: Colors.transparent,
              ),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: const BorderSide(
                color: Colors.transparent,
              ),
            ),
            suffixIcon: pw == true
                ? IconButton(
                    color: buttonColor,
                    onPressed: () {
                      _passwordVisibility();
                    },
                    icon: Icon(_passwordVisible == true
                        ? Icons.visibility
                        : Icons.visibility_off),
                  )
                : null,
          ),
        ),
      );
    } else {
      return Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        child: SizedBox(
          width: deviceWidth * 0.4,
          child: TextField(
            controller: controllerText,
            obscureText: pw ? _passwordVisible : false,
            decoration: InputDecoration(
              filled: true,
              fillColor: surfaceColor,
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 0, horizontal: 25),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: const BorderSide(
                  color: Colors.transparent,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: const BorderSide(
                  color: Colors.transparent,
                ),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: const BorderSide(
                  color: Colors.transparent,
                ),
              ),
              suffixIcon: pw == true
                  ? IconButton(
                      color: buttonColor,
                      onPressed: () {
                        _passwordVisibility();
                      },
                      icon: Icon(_passwordVisible == true
                          ? Icons.visibility
                          : Icons.visibility_off),
                    )
                  : null,
            ),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      body: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          Positioned(
            bottom: 0,
            right: 0,
            child: Image(
              width: imgBG(deviceWidth, deviceHeight),
              image: const AssetImage('lib/assets/images/LoginBackground.png'),
            ),
          ),
          Positioned(
            top: 0,
            child: Image(
              width: deviceWidth,
              image: const AssetImage("lib/assets/images/Appbar.png"),
            ),
          ),
          Container(
            width: deviceWidth,
            height: deviceHeight,
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: SingleChildScrollView(
              child: SizedBox(
                width: deviceWidth < 800 ? deviceWidth : deviceWidth * 0.4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: deviceWidth * 0.12,
                    ),
                    responsiveText(
                      "Selamat Datang!",
                      64,
                      FontWeight.w900,
                      Colors.black,
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    responsiveText(
                      "Nama Pengguna",
                      20,
                      FontWeight.w900,
                      Colors.black,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    responsiveTextField(
                        deviceWidth, deviceHeight, _controllerUsername, false),
                    const SizedBox(
                      height: 25,
                    ),
                    responsiveText(
                      "Kata Sandi",
                      20,
                      FontWeight.w900,
                      Colors.black,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    responsiveTextField(
                        deviceWidth, deviceHeight, _controllerPassword, true),
                    const SizedBox(
                      height: 25,
                    ),
                    deviceWidth < 800
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Column(
                                children: [
                                  ElevatedButton(
                                    onPressed: () {
                                      getAuth(_controllerUsername.text,
                                              _controllerPassword.text)
                                          .then((value) {
                                        if (value) {
                                          context
                                              .read<UserAuth>()
                                              .setIsLoggedIn(true);
                                        } else {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                  "Data yang anda masukan salah"),
                                            ),
                                          );
                                        }
                                      });
                                    },
                                    child: const Text("MASUK"),
                                  ),
                                ],
                              )
                            ],
                          )
                        : SizedBox(
                            width: deviceWidth * 0.4,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Column(
                                  children: [
                                    ElevatedButton(
                                      onPressed: () {
                                        getAuth(_controllerUsername.text,
                                                _controllerPassword.text)
                                            .then((value) {
                                          if (value) {
                                            context
                                                .read<UserAuth>()
                                                .setIsLoggedIn(true);
                                          } else {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                    "Data yang anda masukan salah"),
                                              ),
                                            );
                                          }
                                        });
                                      },
                                      child: const Text("MASUK"),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                    const SizedBox(
                      height: 25,
                    ),
                    const SizedBox(
                      height: 90,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
