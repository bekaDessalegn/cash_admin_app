import 'package:cash_admin_app/core/constants.dart';
import 'package:cash_admin_app/features/common_widgets/normal_text.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/carbon.dart';

Widget CreateButton({required BuildContext context, required double horizontal, required double vertical, required double fontSize}) {
  return ElevatedButton(
    onPressed: () {
      context.go('/add_product');
    },
    style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: onPrimaryColor,
        padding: EdgeInsets.symmetric(horizontal: horizontal, vertical: vertical),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10)
        )
    ),
    child: Row(
      children: [
        Iconify(Carbon.add_alt, color: onPrimaryColor,),
        SizedBox(width: smallSpacing,),
        normalText(
            value: "Create", size: fontSize, color: onPrimaryColor)
      ],
    ),
  );
}