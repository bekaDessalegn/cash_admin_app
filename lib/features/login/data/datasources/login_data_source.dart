import 'dart:convert';
import 'dart:io';

import 'package:cash_admin_app/core/global.dart';
import 'package:cash_admin_app/core/services/auth_service.dart';
import 'package:cash_admin_app/features/login/data/models/login.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' show Client;

class LoginDataSource{
  Client client = Client();
  AuthService authService = AuthService();

  Future loginAdmin(Login login) async {

    var headersList = {
      'Accept': '*/*',
      'Content-Type': 'application/json',
      'Api-Key': apiKey
    };
    var url = Uri.parse('$baseUrl/admin/sign-in');

    var body = {
      "username": login.username,
      "passwordHash": login.passwordHash
    };

    try{
      var res = await client.post(url, headers: headersList, body: json.encode(body));
      final resBody = res.body;

      var data = json.decode(resBody);

      if (res.statusCode >= 200 && res.statusCode < 300) {

        print("The login data");
        print(data);
        await authService.setAccessToken(accessToken: data["accessToken"]);
        await authService.setRefreshToken(refreshToken: data["refreshToken"]);
        await authService.setEmail(email: data["admin"]["email"] ?? "Null");
      }
      else if(data["message"] == "User_Not_Found") {
        throw const HttpException("404");
      } else{
        throw Exception();
      }
    } catch(e){
      print(e);
    }
  }

  Future sendRecoveryEmail(String email) async {
    var headersList = {
      'Accept': '*/*',
      'Api-Key': apiKey,
      'Content-Type': 'application/json'
    };
    var url = Uri.parse('$baseUrl/admin/forgot-password');

    var body = {
      "email": email
    };

    try{
      var res = await client.put(url, headers: headersList, body: json.encode(body));
      final resBody = res.body;

      var data = json.decode(resBody);

      if (res.statusCode >= 200 && res.statusCode < 300) {
      }
      else if(data["message"] == "User_Not_Found" || data["message"] == "Invalid_Email") {
        throw const HttpException("404");
      }
      else{
        throw Exception();
      }
    } on SocketException{
      throw Exception();
    }
  }
  //
  // Future resetPassword(String recoveryToken, String newHashPassword) async {
  //   var headersList = {
  //     'Accept': '*/*',
  //     'Api-Key': apiKey,
  //     'Content-Type': 'application/json'
  //   };
  //   var url = Uri.parse('$baseUrl/admin/recover-password');
  //
  //   var body = {
  //     "recoveryToken": recoveryToken,
  //     "newPasswordHash": newHashPassword
  //   };
  //
  //   try{
  //     var res = await client.put(url, headers: headersList, body: json.encode(body));
  //     final resBody = res.body;
  //
  //     var data = json.decode(resBody);
  //
  //     if (res.statusCode >= 200 && res.statusCode < 300) {
  //
  //     }
  //     else if(data["message"] == "Expired_Token") {
  //       print(data);
  //       throw const HttpException("404");
  //     }
  //     else{
  //       throw Exception();
  //     }
  //   } on SocketException{
  //     throw Exception();
  //   }
  // }
  }