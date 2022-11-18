import 'package:flutter/material.dart';

Widget boldText({required String value, required double size, required Color color}){
  return Text(value, style: TextStyle(
    fontSize: size,
    fontWeight: FontWeight.bold,
    color: color
  ),);
}