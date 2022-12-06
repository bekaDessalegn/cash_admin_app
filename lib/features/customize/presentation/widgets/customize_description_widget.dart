import 'package:cash_admin_app/core/constants.dart';
import 'package:cash_admin_app/features/common_widgets/semi_bold_text.dart';
import 'package:flutter/material.dart';

Widget customizeDescriptionTextFormField({required TextEditingController controller, required String label, required String hintText}){
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      semiBoldText(value: label, size: defaultFontSize, color: onBackgroundColor),
      const SizedBox(height: smallSpacing,),
      TextFormField(
        controller: controller,
        maxLines: 7,
        minLines: 6,
        autocorrect: true,
        keyboardType: TextInputType.multiline,
        validator: (value){
          if(value!.isEmpty){
            return "Value can not be empty";
          } else{
            return null;
          }
        },
        decoration: InputDecoration(
          hintText: hintText,
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