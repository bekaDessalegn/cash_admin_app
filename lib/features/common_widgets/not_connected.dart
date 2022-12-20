import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';

Widget internetNotAvailable({required BuildContext context, required String message}) {
  return Flushbar(
    flushbarStyle: FlushbarStyle.GROUNDED,
    flushbarPosition: FlushbarPosition.TOP,
    message: message,
    leftBarIndicatorColor: Colors.orange,
  );
}

