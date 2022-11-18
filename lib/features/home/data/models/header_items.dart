import 'package:flutter/material.dart';

class HeaderItem {
  final String title;
  final String icon;
  final VoidCallback onTap;

  HeaderItem({
    required this.title,
    required this.icon,
    required this.onTap
  });
}
