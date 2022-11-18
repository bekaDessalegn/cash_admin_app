import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

class AuthService {

  final StreamController<bool> _onAuthStateChange = StreamController.broadcast();

  Stream<bool> get onAuthStateChange => _onAuthStateChange.stream;

  Future<bool> login() async {

    _onAuthStateChange.add(true);
    return true;
  }

  void logOut() {
    _onAuthStateChange.add(false);
  }

  Future setAccessToken({required String accessToken}) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    sharedPreferences.setString("accessToken", accessToken);
  }

  Future setRefreshToken({required String refreshToken}) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    sharedPreferences.setString("refreshToken", refreshToken);
  }

  Future setEmail({required String email}) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    sharedPreferences.setString("email", email);
  }

}