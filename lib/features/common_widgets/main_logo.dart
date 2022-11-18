import 'package:flutter/material.dart';

Widget mainLogo(){
  return Container(
    width: 160,
    height: 40,
    decoration: const BoxDecoration(
        image: DecorationImage(image: AssetImage("images/cash_logo.png"), fit: BoxFit.fitWidth)
    ),
  );
}