import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

String LOGIN_KEY = "5FD6G46SDF4GD64F1VG9SD26";

class AppService with ChangeNotifier {
  late final SharedPreferences sharedPreferences;
  final StreamController<bool> _loginStateChange = StreamController<bool>.broadcast();
  bool _loginState = false;
  bool _initialized = false;
  bool _isEditUsername = false;
  bool _isEditEmail = false;
  bool _isVerify = false;

  AppService(this.sharedPreferences);

  bool get loginState => _loginState;
  bool get initialized => _initialized;
  bool get isEditUsername => _isEditUsername;
  bool get isEditEmail => _isEditEmail;
  bool get isVerify => _isVerify;
  Stream<bool> get loginStateChange => _loginStateChange.stream;

  set loginState(bool state) {
    sharedPreferences.setBool(LOGIN_KEY, state);
    _loginState = state;
    _loginStateChange.add(state);
    notifyListeners();
  }

  set initialized(bool value) {
    _initialized = value;
    notifyListeners();
  }

  set isEditUsername(bool value){
    _isEditUsername = value;
    notifyListeners();
  }

  set isEditEmail(bool value){
    _isEditEmail = value;
    notifyListeners();
  }

  set isVerify(bool value){
    _isVerify = value;
    notifyListeners();
  }

  Future<void> onAppStart() async {
    _loginState = sharedPreferences.getBool(LOGIN_KEY) ?? false;

    await Future.delayed(const Duration(seconds: 0));

    _initialized = true;
    notifyListeners();
  }

  void changeIsEditUsername(bool value){
    _isEditUsername = value;
    notifyListeners();
  }

  void changeIsEditEmail(bool value){
    _isEditEmail = value;
    notifyListeners();
  }

  void changeIsVerify(bool value){
    _isVerify = value;
    notifyListeners();
  }

}
