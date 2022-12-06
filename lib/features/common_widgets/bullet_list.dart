import 'package:cash_admin_app/core/constants.dart';
import 'package:flutter/material.dart';

Widget bulletList({required String text}){
  return Padding(
    padding: const EdgeInsets.only(left: 10.0, bottom: 10),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 5.0,
          width: 5.0,
          margin: EdgeInsets.only(top: 10),
          decoration: BoxDecoration(
            color: onBackgroundColor,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: 10,),
        Flexible(
          child: Text(
            text,
            overflow: TextOverflow.visible,
            style: TextStyle(
              color: onBackgroundColor,
              fontSize: defaultFontSize,
            ),
          ),
        ),
      ],
    ),
  );
}