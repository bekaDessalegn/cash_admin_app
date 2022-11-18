import 'package:cash_admin_app/core/constants.dart';
import 'package:flutter/material.dart';

Widget mobileDashboardBox({required String value, required String type}){
  return Container(
    height: 113,
    padding: EdgeInsets.only(left: 20),
    decoration: BoxDecoration(
      color: surfaceColor,
      borderRadius: BorderRadius.circular(defaultRadius)
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(value,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 35,
          color: onBackgroundColor
        ),),
        Text(type,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 21,
              color: onBackgroundColor
          ),),
      ],
    ),
  );
}