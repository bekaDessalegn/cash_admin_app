import 'package:another_flushbar/flushbar.dart';
import 'package:cash_admin_app/core/constants.dart';
import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';

Widget noDataWidget({required String message, required String icon}) =>
    Flushbar(
      flushbarStyle: FlushbarStyle.GROUNDED,
      backgroundColor: surfaceColor,
      message: message,
      messageColor: onBackgroundColor,
      icon: Iconify(
        icon,
        size: 28.0,
        color: primaryColor,
      ),
      leftBarIndicatorColor: primaryColor,
    );