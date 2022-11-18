import 'dart:io';

import 'package:cash_admin_app/features/profile/data/datasources/profile_datasource.dart';
import 'package:cash_admin_app/features/profile/data/models/admin.dart';

class ProfileRepository{
  ProfileDataSource profileDataSource;
  ProfileRepository(this.profileDataSource);

  Future<Admin> getAdmin() async {
    try{
      print("get Admin Sucess");
      final admin = await profileDataSource.getAdmin();
      return admin;
    } on SocketException {
      throw const SocketException("network");
    } on Exception {
      throw Exception("api");
    }
  }

  Future editUsername(String newUsername) async {
    try{
      print("Edit Sucess");
      await profileDataSource.editUsername(newUsername);
    }
    catch (e){
      print("Edit Not Sucessful");
      print(e);
      throw Exception(e);
    }
  }

  Future editPassword(String oldPasswordHash, String newPasswordHash) async {
    try{
      print("Edit Password Success");
      await profileDataSource.editPassword(oldPasswordHash, newPasswordHash);
    } on HttpException {
      print("http");
      throw const HttpException("404");
    } on SocketException {
      print("Socket");
      throw SocketException("No Internet");
    } on Exception {
      print("EXp");
      throw Exception();
    }
  }

  Future changeCommissionRate(int commissionRate) async {
    try{
      print("Change Commission Rate Success");
      await profileDataSource.changeCommissionRate(commissionRate);
    }
    catch (e){
      print("Change Commission Rate Not Successful");
      print(e);
      throw Exception(e);
    }
  }

  Future putEmail(String email) async {
    try{
      print("Put Email Success");
      await profileDataSource.putEmail(email);
    } on HttpException {
      print("http");
      throw const HttpException("404");
    } on SocketException {
      print("Socket");
      throw SocketException("No Internet");
    } on Exception {
      print("EXp");
      throw Exception();
    }
  }

  Future verifyEmail(String verificationCode) async {
    try{
      print("Verify Email Success");
      await profileDataSource.verifyEmail(verificationCode);
    } on HttpException {
      print("http");
      throw const HttpException("404");
    } on SocketException {
      print("Socket");
      throw SocketException("No Internet");
    } on Exception {
      print("EXp");
      throw Exception();
    }
  }

  Future signOut() async {
    try{
      print("Signout Sucess");
      await profileDataSource.signout();
    }
    catch (e){
      print("Not Sucessful");
      print(e);
      throw Exception(e);
    }
  }

}