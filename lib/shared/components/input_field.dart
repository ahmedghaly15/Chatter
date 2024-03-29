import 'package:chat_app/services/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InputField extends StatelessWidget {
  final String hint;
  final TextStyle? hintStyle;
  final bool? obsecure;
  final Widget? icon;
  final Widget? prefixIcon;
  final TextEditingController controller;
  final TextCapitalization textCapitalization;
  final String? Function(String?)? validating;
  final TextInputType keyboardType;

  const InputField({
    Key? key,
    required this.hint,
    this.hintStyle = const TextStyle(
      fontSize: 18,
      color: Colors.grey,
    ),
    required this.controller,
    required this.textCapitalization,
    required this.validating,
    required this.keyboardType,
    this.obsecure,
    this.prefixIcon,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: key,
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: hintStyle,
        prefixIcon: prefixIcon,
        prefixIconColor: primaryClr,
        suffixIcon: icon,
        suffixIconColor: primaryClr,
        contentPadding: const EdgeInsets.all(10),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Get.isDarkMode ? Colors.white54 : Colors.grey,
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
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Colors.red,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
      ),
      cursorColor: Get.isDarkMode ? Colors.white : Colors.black,
      style: TextStyle(
        fontSize: 20,
        color: Get.isDarkMode ? Colors.white : Colors.black,
      ),
      obscureText: obsecure!,
      keyboardType: keyboardType,
      textCapitalization: textCapitalization,
      validator: validating,
    );
  }
}
