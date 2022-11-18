import 'package:cash_admin_app/core/constants.dart';
import 'package:cash_admin_app/features/common_widgets/bold_text.dart';
import 'package:flutter/material.dart';

Widget verificationCodeBox(){
  return Column(
    children: [
      Padding(
        padding: const EdgeInsets.only(left: 10.0),
        child: boldText(
            value: "Verification code", size: 17, color: blackColor),
      ),

    ],
  );
}