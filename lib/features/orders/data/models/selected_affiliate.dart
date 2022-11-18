import 'package:cash_admin_app/core/global.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SelectedOrder extends ChangeNotifier {
  String? desktopOrderId = orderId;

  void selectedOrder(String desktopOrderId) {
    this.desktopOrderId = desktopOrderId;
    notifyListeners();
  }

  Future setOrderId({required String orderId}) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    sharedPreferences.setString("order_id", orderId);
    desktopOrderId = orderId;
    notifyListeners();
  }
}
