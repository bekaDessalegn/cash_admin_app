import 'package:cash_admin_app/core/constants.dart';
import 'package:cash_admin_app/features/common_widgets/semi_bold_text.dart';
import 'package:flutter/material.dart';

Widget descriptionTextFormField({required TextEditingController controller}){
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      semiBoldText(value: "Description", size: defaultFontSize, color: onBackgroundColor),
      const SizedBox(height: smallSpacing,),
      TextFormField(
        controller: controller,
        maxLines: 7,
        minLines: 6,
        autocorrect: true,
        keyboardType: TextInputType.multiline,
        decoration: const InputDecoration(
          hintText: "Product description",
          hintStyle: TextStyle(color: textInputPlaceholderColor),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: textInputBorderColor),
            borderRadius: BorderRadius.all(
              Radius.circular(defaultRadius),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: primaryColor),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: dangerColor),
          ),
        ),
      ),
    ],
  );
}