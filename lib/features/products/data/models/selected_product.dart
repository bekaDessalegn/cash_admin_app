import 'package:cash_admin_app/core/global.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SelectedProduct extends ChangeNotifier {
  String? desktopProductId = productId;

  void selectedProduct(String desktopProductId) {
    this.desktopProductId = desktopProductId;
    notifyListeners();
  }

  Future setProductId({required String productId}) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    sharedPreferences.setString("product_id", productId);
    desktopProductId = productId;
    notifyListeners();
  }
}
