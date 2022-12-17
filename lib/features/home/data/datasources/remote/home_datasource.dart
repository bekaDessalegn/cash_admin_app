import 'dart:convert';
import 'dart:io';

import 'package:cash_admin_app/core/global.dart';
import 'package:cash_admin_app/core/services/auth_service.dart';
import 'package:cash_admin_app/core/services/shared_preference_service.dart';
import 'package:cash_admin_app/features/home/data/datasources/local/analytics_local_datasource.dart';
import 'package:cash_admin_app/features/home/data/models/analytics.dart';
import 'package:cash_admin_app/features/home/data/models/video_links.dart';
import 'package:cash_admin_app/features/orders/data/models/orders.dart';
import 'package:cash_admin_app/features/products/data/models/products.dart';
import 'package:http/http.dart' as http;

class HomeDataSource {
  AuthService authService = AuthService();
  final _prefs = PrefService();
  AnalyticsLocalDb analyticsLocalDb = AnalyticsLocalDb();

  var refreshToken;
  var accessToken;

  int limit = 50;

  Future getNewAccessToken() async {
    await getRefreshTokens().then((value) {
      refreshToken = value;
    });

    await getAccessTokens().then((value) {
      accessToken = value;
    });

    var headersList = {
      'Accept': '*/*',
      'Api-Key': apiKey,
      'Refresh-Token': '$refreshToken',
      'Authorization': 'Bearer $accessToken'
    };
    var url = Uri.parse('$baseUrl/sessions/refresh');

    var res = await http.get(url, headers: headersList);
    final resBody = res.body;

    var data = json.decode(resBody);

    if (res.statusCode >= 200 && res.statusCode < 300) {
      print(data);
      await authService.setAccessToken(accessToken: data["newAccessToken"]);
    } else if(data["message"] == "Invalid_Refresh_Token") {
      _prefs.removeCache();
      authService.logOut();
    } else {
      print(data);
      throw Exception();
    }
  }

  Future<List<Products>> filterFeaturedProducts() async {
    var headersList = {
      'Accept': '*/*',
      'Api-Key': apiKey,
      'Authorization': 'Bearer $accessToken'
    };
    var url = Uri.parse('$baseUrl/products?filter={"featured" : true}&select=["productName","price","mainImage", "commission"]&limit=$limit');

    try {
      var res = await http.get(url, headers: headersList);
      final resBody = res.body;

      print("This is it");
      print(resBody);
      print(res.statusCode);

      var data = json.decode(resBody);

      List content = json.decode(resBody);

      if (res.statusCode >= 200 && res.statusCode < 300) {
        print("aaaaaaaaaaaaaaaaaaaaa");
        final List<Products> products = content.map((product) => Products.fromJson(product)).toList();
        // print(data);
        return products;
      } else if (data["message"] == "Not_Authorized") {
        print("ON 401 : $data");
        await getNewAccessToken();
        return await filterFeaturedProducts();
      } else if(res.statusCode == 429){
        print("Too many requests");
        throw Exception();
      }
      else {
        print(data);
        print("Something Something hard");
        throw Exception();
      }
    } on SocketException {
      print("Socket Socket");
      throw Exception();
    }
  }

  Future<List<Products>> filterTopSellerProducts() async {
    var headersList = {
      'Accept': '*/*',
      'Api-Key': apiKey,
      'Authorization': 'Bearer $accessToken'
    };
    var url = Uri.parse('$baseUrl/products?filter={"topSeller" : true}&select=["productName","price","mainImage", "commission"]&limit=$limit');

    try {
      var res = await http.get(url, headers: headersList);
      final resBody = res.body;

      print("This is it");
      print(resBody);
      print(res.statusCode);

      var data = json.decode(resBody);

      List content = json.decode(resBody);

      if (res.statusCode >= 200 && res.statusCode < 300) {
        print("aaaaaaaaaaaaaaaaaaaaa");
        final List<Products> products = content.map((product) => Products.fromJson(product)).toList();
        // print(data);
        return products;
      } else if (data["message"] == "Not_Authorized") {
        print("ON 401 : $data");
        await getNewAccessToken();
        return await filterFeaturedProducts();
      } else if(res.statusCode == 429){
        print("Too many requests");
        throw Exception();
      }
      else {
        print(data);
        print("Something Something hard");
        throw Exception();
      }
    } on SocketException {
      print("Socket Socket");
      throw Exception();
    }
  }

  Future<List<Orders>> filterUnAnsweredProducts() async {

    await getAccessTokens().then((value) {
      accessToken = value;
    });

    var headersList = {
      'Accept': '*/*',
      'Api-Key': apiKey,
      'Authorization': 'Bearer $accessToken'
    };
    var url = Uri.parse('$baseUrl/orders?limit=$limit&filter={"status":"Pending"}');

    try{
      var res = await http.get(url, headers: headersList);
      final resBody = res.body;

      var data = json.decode(resBody);

      if (res.statusCode >= 200 && res.statusCode < 300) {
        print(data);
        List contents = json.decode(resBody);
        List<Orders> unAnsweredProducts = contents.map((unAnsweredProduct) => Orders.fromJson(unAnsweredProduct)).toList();
        return unAnsweredProducts;
      } else if (data["message"] == "Not_Authorized") {
        print("ON 401 : $data");
        await getNewAccessToken();
        return await filterUnAnsweredProducts();
      } else if(res.statusCode == 429){
        print("Too many requests");
        throw Exception();
      } else {
        print(data);
        throw Exception();
      }
    } catch(e){
      print(e);
      throw Exception();
    }

  }

  Future<Analytics> getAnalytics() async {

    await getAccessTokens().then((value) {
      accessToken = value;
    });

    var headersList = {
      'Accept': '*/*',
      'Api-Key': apiKey,
      'Authorization': 'Bearer $accessToken'
    };
    var url = Uri.parse('$baseUrl/analytics/counts');
    
    try{
      var res = await http.get(url, headers: headersList);
      final resBody = res.body;

      var data = json.decode(resBody);

      if (res.statusCode >= 200 && res.statusCode < 300) {
        print(data);
        await analyticsLocalDb.addAnalytics(Analytics.fromJson(data["counts"]));
        final updated = await analyticsLocalDb.updateAnalytics(Analytics.fromJson(data["counts"]).toJson());

        print("Is it updated");
        print(updated);

        final analytics = Analytics.fromJson(data["counts"]);
        return analytics;
      } else if (data["message"] == "Not_Authorized") {
        print("ON 401 : $data");
        await getNewAccessToken();
        return await getAnalytics();
      } else {
        throw Exception("api");
      }
    } on SocketException {
      final analytics = await analyticsLocalDb.getAnalytics();
      return analytics;
    }
  }

  Future putWhoAreWeWebContent(String whoAreWe) async {

    await getAccessTokens().then((value) {
      accessToken = value;
    });

    var headersList = {
      'Accept': '*/*',
      'Api-Key': apiKey,
      'Authorization': 'Bearer $accessToken',
      'Content-Type': 'application/json'
    };
    var url = Uri.parse('$baseUrl/static-web-contents');

    var body = {
      "videoLinks": {
        "whoAreWe": whoAreWe
      }
    };
    try{
      var res = await http.put(url, headers: headersList, body: json.encode(body));
      final resBody = res.body;

      var data = json.decode(resBody);

      if (res.statusCode >= 200 && res.statusCode < 300) {
        print(data);
      } else if (data["message"] == "Not_Authorized") {
        print("ON 401 : $data");
        await getNewAccessToken();
        return await putWhoAreWeWebContent(whoAreWe);
      }
      else {
        print(data);
        throw Exception();
      }
    } catch(e){
      print(e);
      throw Exception();
    }
  }

  Future putHowToAffiliateWithUsWebContent(String howToAffiliateWithUs) async {

    await getAccessTokens().then((value) {
      accessToken = value;
    });

    var headersList = {
      'Accept': '*/*',
      'Api-Key': apiKey,
      'Authorization': 'Bearer $accessToken',
      'Content-Type': 'application/json'
    };
    var url = Uri.parse('$baseUrl/static-web-contents');

    var body = {
      "videoLinks": {
        "howToAffiliateWithUs": howToAffiliateWithUs
      }
    };
    try{
      var res = await http.put(url, headers: headersList, body: json.encode(body));
      final resBody = res.body;

      var data = json.decode(resBody);

      if (res.statusCode >= 200 && res.statusCode < 300) {
        print(data);
      } else if (data["message"] == "Not_Authorized") {
        print("ON 401 : $data");
        await getNewAccessToken();
        return await putHowToAffiliateWithUsWebContent(howToAffiliateWithUs);
      }
      else {
        print(data);
        throw Exception();
      }
    } catch(e){
      print(e);
      throw Exception();
    }
  }

  Future<VideoLinks> getVideoLinks() async {

    var headersList = {
      'Accept': '*/*',
      'Api-Key': apiKey
    };
    var url = Uri.parse('$baseUrl/static-web-contents');

    try{
      var res = await http.get(url, headers: headersList);
      final resBody = res.body;

      var data = json.decode(resBody);

      if (res.statusCode >= 200 && res.statusCode < 300) {
        print(data);
        if(data["videoLinks"].toString() != "null"){
          final videoLinks = VideoLinks.fromJson(data["videoLinks"]);
          return videoLinks;
        } else{
          return VideoLinks(whoAreWe: "null", howToAffiliateWithUs: "null");
        }
      }
      else {
        print(data);
        throw Exception();
      }
    } catch(e){
      print(e);
      throw Exception();
    }
  }
}