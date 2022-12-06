import 'package:another_flushbar/flushbar.dart';
import 'package:cash_admin_app/core/constants.dart';
import 'package:flutter/material.dart';

Widget requireFlashBar({required BuildContext context, required String message}) =>
    Flushbar(
      flushbarStyle: FlushbarStyle.FLOATING,
      flushbarPosition: FlushbarPosition.TOP,
      message: message,
      duration:  Duration(seconds: 2),
      icon: Icon(
        Icons.info_outline,
        size: 28.0,
        color: primaryColor,
      ),
      leftBarIndicatorColor: Colors.orange,
    )..show(context);