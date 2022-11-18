import 'package:cash_admin_app/core/constants.dart';
import 'package:flutter/material.dart';

Widget errorBox({required VoidCallback onPressed}){
  return Container(
    margin: EdgeInsets.only(top: 50),
    width: 250,
    padding: EdgeInsets.symmetric(vertical: 30, horizontal: 10),
    decoration: BoxDecoration(
        border: Border.all(color: surfaceColor),
        borderRadius: BorderRadius.circular(10)
    ),
    alignment: Alignment.center,
    child: Column(
      children: [
        Text("Something went wrong, please try again.",
          textAlign: TextAlign.center,
          style: TextStyle(color: onBackgroundColor, fontSize: 18),),
        SizedBox(height: 30,),
        ElevatedButton(onPressed: onPressed, child: Text("Try again", style: TextStyle(color: onPrimaryColor),))
      ],
    ),
  );
}