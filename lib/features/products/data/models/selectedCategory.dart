import 'package:flutter/material.dart';

class SelectedCategory extends ChangeNotifier {
  int index = 0;

  void selectedIndex(int index){
    this.index = index;
    notifyListeners();
  }

}