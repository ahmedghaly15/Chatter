import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

// ================ Colors Of The App =======================
const Color backgroundColor = Color.fromRGBO(237, 241, 214, 1);
const Color primaryClr = Color.fromRGBO(107, 209, 117, 1);
const Color darkGreyClr = Color(0xFF121212);
const Color darkHeaderClr = Color.fromARGB(0, 18, 18, 18);

class Themes {
// =================== Light Mode Theme ======================
  static final lightTheme = ThemeData.light().copyWith(
    colorScheme: const ColorScheme.light(background: Colors.white),
    primaryColor: primaryClr,
    brightness: Brightness.light,
    bottomAppBarTheme: const BottomAppBarTheme(color: Colors.white),
  );

// =================== Dark Mode Theme ======================
  static final darkTheme = ThemeData.dark().copyWith(
    primaryColor: darkGreyClr,
    colorScheme: const ColorScheme.dark(background: darkGreyClr),
    brightness: Brightness.dark,
    bottomAppBarTheme: const BottomAppBarTheme(color: darkGreyClr),
  );
}

// =================== Fonts ======================
TextStyle get headingStyle {
  return GoogleFonts.lato(
    textStyle: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: Get.isDarkMode ? Colors.white : Colors.black,
      letterSpacing: 1,
    ),
  );
}

TextStyle get subHaedingStyle {
  return GoogleFonts.lato(
    textStyle: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: Get.isDarkMode ? Colors.white : Colors.black,
      letterSpacing: 0.5,
    ),
  );
}

TextStyle get titleStyle {
  return GoogleFonts.lato(
    textStyle: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w500,
      color: Get.isDarkMode ? Colors.white : Colors.black,
      letterSpacing: 0.5,
    ),
  );
}

TextStyle get subTitleStyle {
  return GoogleFonts.lato(
    textStyle: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: Get.isDarkMode ? Colors.white : Colors.black,
      letterSpacing: 0.5,
    ),
  );
}

TextStyle get titleBodyStyle {
  return GoogleFonts.lato(
    textStyle: const TextStyle(
      fontSize: 17,
      fontWeight: FontWeight.bold,
      color: Colors.white,
      letterSpacing: 0.5,
    ),
  );
}

TextStyle get bodyStyle1 {
  return GoogleFonts.lato(
    textStyle: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: Get.isDarkMode ? Colors.white : Colors.black,
      letterSpacing: 0.5,
    ),
  );
}

TextStyle get bodyStyle2 {
  return GoogleFonts.lato(
    textStyle: TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.w500,
      color: Get.isDarkMode ? Colors.white : Colors.black,
      letterSpacing: 0.5,
    ),
  );
}

TextStyle get bodyStyle3 {
  return GoogleFonts.lato(
    textStyle: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: Get.isDarkMode ? Colors.grey[100] : Colors.grey[700],
      letterSpacing: 0.5,
    ),
  );
}

TextStyle get caption {
  return GoogleFonts.inter(
    textStyle: const TextStyle(
      fontSize: 12,
      color: Colors.grey,
      height: 1.7,
    ),
  );
}
