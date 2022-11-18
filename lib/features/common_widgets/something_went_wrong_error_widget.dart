import 'package:another_flushbar/flushbar.dart';
import 'package:cash_admin_app/core/constants.dart';
import 'package:flutter/material.dart';

Widget somethingWentWrong({required BuildContext context, required String message, required VoidCallback onPressed}) =>
    Flushbar(
      flushbarStyle: FlushbarStyle.GROUNDED,
      flushbarPosition: FlushbarPosition.TOP,
      messageText: Row(children: [
        Text(message, style: TextStyle(color: onPrimaryColor),),
        SizedBox(width: 10,),
        TextButton(onPressed: (){
          onPressed();
          Navigator.pop(context);
        }, child: Text("Try again"))
      ],),
      // message: message,
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