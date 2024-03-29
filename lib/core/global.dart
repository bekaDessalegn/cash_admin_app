import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

final formkey = GlobalKey<FormState>();
final usernameController = TextEditingController();
final passwordController = TextEditingController();
final webContentController = TextEditingController();
final howToEarnWithUsController = TextEditingController();
final carouselController = CarouselController();

const String apiKey = "2S9f4e2D886aGa231caH2H44f2R25Jf487cDfaa3G";
// const String baseUrl = "https://dev-api.cash.et";
const String baseUrl = "https://api.cash.et";
// const String baseUrl = "http://localhost:5000";
// const String baseUrl = "http://192.168.1.7:5000";

enum OrderListItem {Pending, Rejected, Accepted}
enum AffiliateListItem {Date, EarningUp, EarningDown, MostParents}

Future getAccessTokens() async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  return sharedPreferences.getString("accessToken");
}

Future getRefreshTokens() async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  return sharedPreferences.getString("refreshToken");
}

Future getEmailData() async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  return sharedPreferences.getString("email");
}

Future getDesktopProductId() async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  return sharedPreferences.getString("product_id");
}

Future getDesktopAffiliateId() async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  return sharedPreferences.getString("affiliate_id");
}

Future getDesktopOrderId() async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  return sharedPreferences.getString("order_id");
}

Future setCommissionRate({required int commissionRate}) async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

  sharedPreferences.setInt("commissionRate", commissionRate);
}

Future getCommissionRate() async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  return sharedPreferences.getInt("commissionRate");
}
