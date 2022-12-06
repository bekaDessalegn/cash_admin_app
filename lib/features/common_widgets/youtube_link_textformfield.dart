import 'package:cash_admin_app/core/constants.dart';
import 'package:cash_admin_app/features/common_widgets/semi_bold_text.dart';
import 'package:flutter/material.dart';

Widget youtubeTextFormField({required String type, required String hint, required TextEditingController controller}){
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      semiBoldText(value: type, size: defaultFontSize, color: onBackgroundColor),
      const SizedBox(height: smallSpacing,),
      TextFormField(
        controller: controller,
        validator: (value) {
          if (value!.isEmpty) {
            return "Value can not be empty";
          } else if (RegExp(
              r"((?:https?:)?\/\/)?((?:www|m)\.)?((?:youtube\.com|youtu.be))(\/(?:[\w\-]+\?v=|embed\/|v\/)?)([\w\-]+)(\S+)?")
              .hasMatch(value)) {
            return null;
          } else {
            return "Please enter valid youtube link";
          }
        },
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: textInputPlaceholderColor),
          contentPadding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 10.0),
          border: const OutlineInputBorder(
            borderSide: BorderSide(color: textInputBorderColor),
            borderRadius: BorderRadius.all(
              Radius.circular(defaultRadius),
            ),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: primaryColor),
          ),
          errorBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: dangerColor),
          ),
        ),
      ),
    ],
  );
}