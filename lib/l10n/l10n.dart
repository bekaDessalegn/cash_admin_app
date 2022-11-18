import 'package:flutter/material.dart';

class L10n {
  static final all = [
    const Locale('en'),
    const Locale('am')
  ];

  static String getLanguage(String code){
    switch(code){
      case 'am':
        return 'አማርኛ';
      case 'en':
      default:
        return 'English';
    }
  }
}