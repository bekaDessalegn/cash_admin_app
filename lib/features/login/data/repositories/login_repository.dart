import 'dart:io';

import 'package:cash_admin_app/features/login/data/datasources/login_data_source.dart';
import 'package:cash_admin_app/features/login/data/models/login.dart';

class LoginRepository {
  LoginDataSource loginDataSource;

  LoginRepository(this.loginDataSource);

  Future loginAdmin(Login login) async {
    try {
      await loginDataSource.loginAdmin(login);
    } on HttpException {
      throw const HttpException("404");
    } on SocketException {
      throw SocketException("No Internet");
    } on Exception {
      throw Exception();
    }
  }

  Future sendRecoveryEmail(String email) async {
    try {
      await loginDataSource.sendRecoveryEmail(email);
    } on HttpException {
      throw const HttpException("404");
    } on SocketException {
      throw SocketException("No Internet");
    } on Exception {
      throw Exception();
    }
  }
  //
  // Future resetPassword(String recoveryToken, String newHashPassword) async {
  //   try {
  //     await loginDataSource.resetPassword(recoveryToken, newHashPassword);
  //   } on HttpException {
  //
  //     throw const HttpException("404");
  //   } on SocketException {
  //
  //     throw SocketException("No Internet");
  //   } on Exception {
  //
  //     throw Exception();
  //   }
  // }
}
