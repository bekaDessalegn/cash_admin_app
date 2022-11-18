import 'package:another_flushbar/flushbar.dart';
import 'package:cash_admin_app/core/constants.dart';
import 'package:flutter/material.dart';

Widget buildErrorLayout({required BuildContext context, required String message}) =>
    Flushbar(
      flushbarStyle: FlushbarStyle.GROUNDED,
      flushbarPosition: FlushbarPosition.TOP,
      message: message,
      mainButton: IconButton(onPressed: (){
        Navigator.pop(context);
      }, icon: Icon(Icons.close, color: primaryColor,)),
      icon: Icon(
        Icons.info_outline,
        size: 28.0,
        color: primaryColor,
      ),
      leftBarIndicatorColor: primaryColor,
    )..show(context);