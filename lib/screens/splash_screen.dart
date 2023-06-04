import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../shared/constants.dart';
import 'auth/auth_screen.dart';
import '/screens/home_screen.dart';
import '../services/theme.dart';

class MySplashScreen extends StatefulWidget {
  const MySplashScreen({super.key});

  @override
  State<MySplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<MySplashScreen> {
  // ============ Storing User Email Using SharedPrererences ============
  goToApp() async {
    if (uId == null) {
      // Go To AuthScreen
      Get.off(() => const AuthScreen(), transition: Transition.fadeIn);
    } else {
      // Go To Home Screen
      Get.offAll(() => const HomeScreen(), transition: Transition.fadeIn);
    }
  }

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        systemNavigationBarColor:
            Get.isDarkMode ? darkGreyClr : Colors.transparent,
        statusBarColor: Get.isDarkMode ? darkGreyClr : Colors.transparent,
      ),
    );
    // Time Of Showing Splash Screen
    Timer(const Duration(milliseconds: 2200), goToApp);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomRight,
          colors: Get.isDarkMode
              ? [
                  const Color.fromARGB(255, 18, 18, 18),
                  const Color.fromARGB(100, 18, 18, 18),
                ]
              : [
                  const Color.fromRGBO(73, 178, 83, 1),
                  const Color.fromRGBO(73, 178, 83, 0.7),
                ],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(13),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(13),
              child: Image.asset(
                "assets/images/logo/app logo.jpg",
                width: 80,
                height: 80,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
