import 'package:cash_admin_app/core/constants.dart';
import 'package:flutter/material.dart';

Widget loadingBox(){
  return Container(
    margin: EdgeInsets.only(top: 50),
    width: 250,
    height: 100,
    padding: EdgeInsets.symmetric(vertical: 30, horizontal: 10),
    decoration: BoxDecoration(
        border: Border.all(color: surfaceColor),
        borderRadius: BorderRadius.circular(10)
    ),
    alignment: Alignment.center,
    child: Column(
      children: [
        Text("Loading ...", style: TextStyle(color: onBackgroundColor, fontSize: 22, fontWeight: FontWeight.bold),),
      ],
    ),
  );
}