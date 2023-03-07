import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:chat_app/theme.dart';

class InputField extends StatelessWidget {
  const InputField({
    Key? key,
    required this.hint,
    this.controller,
    this.obsecure,
    this.icon,
    this.validating,
    this.keyboardType,
    this.saving,
    this.autoCorrect,
    this.enableSuggestions,
    this.textCapitalization,
  }) : super(key: key);

  final String? hint;
  final bool? obsecure;
  final Widget? icon;
  final TextEditingController? controller;
  final String? Function(String?)? validating;
  final TextInputType? keyboardType;
  final Function(String?)? saving;
  final bool? autoCorrect;
  final bool? enableSuggestions;
  final TextCapitalization? textCapitalization;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: key,
      autocorrect: autoCorrect!,
      enableSuggestions: enableSuggestions!,
      textCapitalization: textCapitalization!,
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: subTitleStyle,
        border: const OutlineInputBorder(),
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        suffixIcon: icon,
        suffixIconColor: primaryClr,
        alignLabelWithHint: true,
        contentPadding: const EdgeInsets.only(left: 10.0),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.grey,
            width: 0,
          ),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: primaryClr,
            width: 2,
          ),
        ),
        errorBorder:
            const OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
      ),
      cursorColor: Get.isDarkMode ? Colors.grey[100] : Colors.grey[700],
      style: titleStyle,
      keyboardType: keyboardType,
      obscureText: obsecure!,
      validator: validating,
      onSaved: saving,
      obscuringCharacter: '•',
    );
  }
}
