import 'dart:io';

import 'package:cash_admin_app/features/home/data/datasources/remote/home_datasource.dart';
import 'package:cash_admin_app/features/home/data/models/analytics.dart';
import 'package:cash_admin_app/features/home/data/models/video_links.dart';
import 'package:cash_admin_app/features/orders/data/models/orders.dart';
import 'package:cash_admin_app/features/products/data/models/products.dart';

class HomeRepository{
  HomeDataSource homeDataSource;
  HomeRepository(this.homeDataSource);

  Future<List<Products>> filterFeaturedProducts() async{
    try{
      print("Filter Published Products Success");
      final products = await homeDataSource.filterFeaturedProducts();
      return products;
    } on SocketException {
      print("Socket");
      throw SocketException("No Internet");
    } catch(e) {
      print(e);
      throw Exception();
    }
  }

  Future<List<Products>> filterTopSellerProducts() async{
    try{
      print("Filter Top Seller Products Success");
      final products = await homeDataSource.filterTopSellerProducts();
      return products;
    } on SocketException {
      print("Socket");
      throw SocketException("No Internet");
    } catch(e) {
      print(e);
      throw Exception();
    }
  }

  Future<List<Orders>> filterUnAnsweredProducts() async{
    try{
      final unAnsweredProducts = await homeDataSource.filterUnAnsweredProducts();
      return unAnsweredProducts;
    } catch(e){
      print(e);
      throw Exception();
    }
  }

  Future<Analytics> getAnalytics() async {
    try{
      final analytics = await homeDataSource.getAnalytics();
      return analytics;
    } catch(e){
      print(e);
      throw Exception();
    }
  }

  Future putWhoAreWeWebContents(String whoAreWe) async{
    try{
      await homeDataSource.putWhoAreWeWebContent(whoAreWe);
    } catch(e){
      print(e);
      throw Exception();
    }
  }

  Future putHowToAffiliateWithUsWebContents(String howToAffiliateWithUs) async{
    try{
      await homeDataSource.putHowToAffiliateWithUsWebContent(howToAffiliateWithUs);
    } catch(e){
      print(e);
      throw Exception();
    }
  }

  Future<VideoLinks> getVideoLinks() async{
    try{
      final videoLinks = await homeDataSource.getVideoLinks();
      return videoLinks;
    } catch(e){
      print(e);
      throw Exception();
    }
  }
}