import 'dart:io';

import 'package:cash_admin_app/features/customize/data/datasource/customize_datasource.dart';
import 'package:cash_admin_app/features/customize/data/model/about_content.dart';
import 'package:cash_admin_app/features/customize/data/model/about_us_image.dart';
import 'package:cash_admin_app/features/customize/data/model/brands.dart';
import 'package:cash_admin_app/features/customize/data/model/hero.dart';
import 'package:cash_admin_app/features/customize/data/model/home_content.dart';
import 'package:cash_admin_app/features/customize/data/model/how_tos.dart';
import 'package:cash_admin_app/features/customize/data/model/logo_image.dart';
import 'package:cash_admin_app/features/customize/data/model/social_links.dart';
import 'package:cash_admin_app/features/customize/data/model/what_makes_us_unique.dart';
import 'package:cash_admin_app/features/customize/data/model/who_are_we.dart';
import 'package:cash_admin_app/features/customize/data/model/why_us.dart';

class CustomizeRepository{
  CustomizeDataSource customizeDataSource;
  CustomizeRepository(this.customizeDataSource);

  Future putLogoImage(LogoImage logoImage, List imageType) async{
    try{
      await customizeDataSource.putLogoImage(logoImage, imageType);
    } on HttpException {
      throw const HttpException("404");
    } on SocketException {
      throw SocketException("No Internet");
    } on Exception {
      throw Exception();
    }
  }

  Future<LogoImage> getLogoImage() async{
    try{
      final logoImage = await customizeDataSource.getLogoImage();
      return logoImage;
    } catch(e){
      print(e);
      throw Exception();
    }
  }

  Future putHero(HeroContent hero, List imageType) async{
    try{
      await customizeDataSource.putHero(hero, imageType);
    } on HttpException {
      throw const HttpException("404");
    } on SocketException {
      throw SocketException("No Internet");
    } on Exception {
      throw Exception();
    }
  }

  Future putAboutUsImage(AboutUsImage aboutUsImage, List imageType) async{
    try{
      await customizeDataSource.putAboutUsImage(aboutUsImage, imageType);
    } on HttpException {
      throw const HttpException("404");
    } on SocketException {
      throw SocketException("No Internet");
    } on Exception {
      throw Exception();
    }
  }

  Future putWhyUsContent(WhyUsContent whyUsContent, List imageType) async{
    try{
      await customizeDataSource.putWhyUsContent(whyUsContent, imageType);
    } on HttpException {
      throw const HttpException("404");
    } on SocketException {
      throw SocketException("No Internet");
    } on Exception {
      throw Exception();
    }
  }

  Future putWhatMakesUsUnique(WhatMakesUsUnique whatMakesUsUnique, List imageType) async{
    try{
      await customizeDataSource.putWhatMakesUsUnique(whatMakesUsUnique, imageType);
    } on HttpException {
      throw const HttpException("404");
    } on SocketException {
      throw SocketException("No Internet");
    } on Exception {
      throw Exception();
    }
  }

  Future putWhoAreWeContent(WhoAreWeContent whoAreWeContent, List imageType) async{
    try{
      await customizeDataSource.putWhoAreWeContent(whoAreWeContent, imageType);
    } on HttpException {
      throw const HttpException("404");
    } on SocketException {
      throw SocketException("No Internet");
    } on Exception {
      throw Exception();
    }
  }

  Future putHowTos(HowTos howTos) async{
    try{
      await customizeDataSource.putHowTos(howTos);
    } on HttpException {
      throw const HttpException("404");
    } on SocketException {
      throw SocketException("No Internet");
    } on Exception {
      throw Exception();
    }
  }

  Future postBrands(Brands brands, List imageType) async{
    try{
      await customizeDataSource.postBrands(brands, imageType);
    } on HttpException {
      throw const HttpException("404");
    } on SocketException {
      throw SocketException("No Internet");
    } on Exception {
      throw Exception();
    }
  }

  Future postSocialLinks(SocialLinks socialLinks, List imageType) async{
    try{
      await customizeDataSource.postSocialLinks(socialLinks, imageType);
    } on HttpException {
      throw const HttpException("404");
    } on SocketException {
      throw SocketException("No Internet");
    } on Exception {
      throw Exception();
    }
  }

  Future<HomeContent> getHomeContent() async{
    try{
      final homeContent = await customizeDataSource.getHomeContent();
      return homeContent;
    } catch(e){
      print(e);
      throw Exception();
    }
  }

  Future deleteBrand(String id) async {
    try{
      await customizeDataSource.deleteBrand(id);
    } catch(e){
      print(e);
      throw Exception();
    }
  }

  Future deleteSocialLink(String id) async {
    try{
      await customizeDataSource.deleteSocialLink(id);
    } catch(e){
      print(e);
      throw Exception();
    }
  }

  Future patchBrands(Brands brands, List imageType, String id) async{
    try{
      await customizeDataSource.patchBrands(brands, imageType, id);
    } on HttpException {
      throw const HttpException("404");
    } on SocketException {
      throw SocketException("No Internet");
    } on Exception {
      throw Exception();
    }
  }

  Future patchSocialLinks(SocialLinks socialLinks, List imageType, String id) async{
    try{
      await customizeDataSource.patchSocialLinks(socialLinks, imageType, id);
    } on HttpException {
      throw const HttpException("404");
    } on SocketException {
      throw SocketException("No Internet");
    } on Exception {
      throw Exception();
    }
  }

  Future<AboutUsContent> getAboutUsContent() async{
    try{
      final aboutUsContent = await customizeDataSource.getAboutUsContent();
      return aboutUsContent;
    } catch(e){
      print(e);
      throw Exception();
    }
  }
}