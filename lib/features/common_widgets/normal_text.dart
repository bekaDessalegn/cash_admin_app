import 'package:flutter/material.dart';

Widget normalText({required String value, required double size, required Color color}){
  return Text(value,
    style: TextStyle(
    fontSize: size,
    color: color
  ),);
}