import 'package:flutter/material.dart';

Widget semiBoldText({required String value, required double size, required Color color}){
  return Text(value, style: TextStyle(
      fontSize: size,
      fontWeight: FontWeight.w500,
    color: color
  ),);
}