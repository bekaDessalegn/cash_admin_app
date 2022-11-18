import 'package:cash_admin_app/core/constants.dart';
import 'package:flutter/material.dart';

Widget noDataBox({required String text, required String description}){
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
        Text(text, style: TextStyle(color: onBackgroundColor, fontSize: 22, fontWeight: FontWeight.bold),),
        SizedBox(height: 5,),
        Text(description, style: TextStyle(color: onBackgroundColor, fontSize: 16),)
      ],
    ),
  );
}