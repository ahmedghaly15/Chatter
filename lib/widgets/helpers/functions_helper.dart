import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '/models/chat_user.dart';
import '/theme.dart';

class Helper {
// ======================== Build Snack Bar Function =============================
  static void buildSnackBar({
    required String title,
    String? message,
    Widget? icon,
  }) {
    Get.snackbar(
      title,
      message!,
      titleText: Text(title,
          style: GoogleFonts.lato(
            textStyle: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w900,
              color: Colors.white,
            ),
          )),
      messageText: Text(message,
          style: GoogleFonts.lato(
            textStyle: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          )),
      backgroundColor: primaryClr,
      colorText: Colors.white,
      icon: icon,
      duration: const Duration(milliseconds: 3500),
      shouldIconPulse: true,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 15),
      margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      borderRadius: 10,
      snackPosition: SnackPosition.BOTTOM,
      snackStyle: SnackStyle.FLOATING,
      forwardAnimationCurve: Curves.easeInExpo,
      reverseAnimationCurve: Curves.easeIn,
      animationDuration: const Duration(milliseconds: 800),
    );
  }

// ======================== Build Form User Info Function =============================
  static Padding buildForm({
    required ChatUser user,
    String? label,
    Widget? prefixIcon,
    String? hint,
    Function(String?)? saving,
    String? Function(String?)? validating,
    TextCapitalization? capitalize,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: TextFormField(
        initialValue: hint == "Name" ? user.username : user.about,
        onSaved: saving,
        validator: validating,
        keyboardType: TextInputType.name,
        textCapitalization: capitalize!,
        autocorrect: true,
        enableSuggestions: true,
        decoration: InputDecoration(
          prefixIcon: prefixIcon,
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Colors.grey,
              width: 0,
            ),
            borderRadius: BorderRadius.circular(15),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: primaryClr,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(15),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.red),
            borderRadius: BorderRadius.circular(15),
          ),
          hintText: hint,
          hintStyle: subTitleStyle,
          labelText: label,
          labelStyle: titleStyle,
        ),
      ),
    );
  }
}
