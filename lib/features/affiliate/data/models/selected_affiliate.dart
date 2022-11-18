import 'package:cash_admin_app/core/global.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SelectedAffiliate extends ChangeNotifier {
  String? desktopAffiliateId = affiliateId;

  void selectedAffiliate(String desktopAffiliateId) {
    this.desktopAffiliateId = desktopAffiliateId;
    notifyListeners();
  }

  Future setAffiliateId({required String affiliateId}) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    sharedPreferences.setString("affiliate_id", affiliateId);
    desktopAffiliateId = affiliateId;
    notifyListeners();
  }
}
