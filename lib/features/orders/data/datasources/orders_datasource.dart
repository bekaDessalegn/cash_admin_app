import 'dart:convert';

import 'package:cash_admin_app/core/global.dart';
import 'package:cash_admin_app/core/services/auth_service.dart';
import 'package:cash_admin_app/core/services/shared_preference_service.dart';
import 'package:cash_admin_app/features/orders/data/models/orders.dart';
import 'package:cash_admin_app/features/orders/data/models/selected_affiliate.dart';
import 'package:http/http.dart' as http;

class OrdersDataSource {
  AuthService authService = AuthService();
  SelectedOrder selectedOrder = SelectedOrder();
  final _prefs = PrefService();

  var refreshToken;
  var accessToken;

  int limit = 9;

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

  Future<List<Orders>> getOrders(int skipNumber) async {

    await getAccessTokens().then((value) {
      accessToken = value;
    });

    var headersList = {
      'Accept': '*/*',
      'Api-Key': apiKey,
      'Authorization': 'Bearer $accessToken'
    };
    var url = Uri.parse('$baseUrl/orders?limit=$limit&skip=$skipNumber');

    try{
      var res = await http.get(url, headers: headersList);
      final resBody = res.body;

      var data = json.decode(resBody);

      if (res.statusCode >= 200 && res.statusCode < 300) {
        print(data);
        List content = json.decode(resBody);
        final List<Orders> orders = content.map((order) => Orders.fromJson(order)).toList();
        if(orders.isNotEmpty){
          print("It has entered");
          final orderId = orders.map((e) => e.orderId).last;
          await selectedOrder.setOrderId(orderId: orderId!);
          print("It has passed");
        }
        print("The first affiliate index is : ");
        print(orderId);
        return orders;
      } else if (data["message"] == "Not_Authorized") {
        print("ON 401 : $data");
        await getNewAccessToken();
        return await getOrders(skipNumber);
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

  Future<List<Orders>> searchOrders(String fullName, String companyName) async {

    await getAccessTokens().then((value) {
      accessToken = value;
    });

    var headersList = {
      'Accept': '*/*',
      'Api-Key': apiKey,
      'Authorization': 'Bearer $accessToken'
    };
    var url = Uri.parse('$baseUrl/orders?search={"orderedBy.fullName":"$fullName", "orderedBy.companyName":"$companyName"}');

    try{
      var res = await http.get(url, headers: headersList);
      final resBody = res.body;

      var data = json.decode(resBody);

      if (res.statusCode >= 200 && res.statusCode < 300) {
        print(data);
        List content = json.decode(resBody);
        final List<Orders> orders = content.map((order) => Orders.fromJson(order)).toList();
        if(orders.isNotEmpty){
          print("It has entered");
          final orderId = orders.map((e) => e.orderId).last;
          await selectedOrder.setOrderId(orderId: orderId!);
          print("It has passed");
        }
        print("The first affiliate index is : ");
        print(orderId);
        return orders;
      } else if (data["message"] == "Not_Authorized") {
        print("ON 401 : $data");
        await getNewAccessToken();
        return await searchOrders(fullName, companyName);
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

  Future<Orders> getSingleOrder(String orderId) async {

    await getAccessTokens().then((value) {
      accessToken = value;
    });

    var headersList = {
      'Accept': '*/*',
      'Api-Key': apiKey,
      'Authorization': 'Bearer $accessToken'
    };
    var url = Uri.parse('$baseUrl/orders/$orderId');

    try{
      var res = await http.get(url, headers: headersList);
      final resBody = res.body;

      var data = json.decode(resBody);

      if (res.statusCode >= 200 && res.statusCode < 300) {
        print(data);
        final order = Orders.fromJson(data);
        return order;
      } else if (data["message"] == "Not_Authorized") {
        print("ON 401 : $data");
        await getNewAccessToken();
        return await getSingleOrder(orderId);
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

  Future acceptOrder(String orderId) async {

    await getAccessTokens().then((value) {
      accessToken = value;
    });

    var headersList = {
      'Accept': '*/*',
      'Api-Key': apiKey,
      'Authorization': 'Bearer $accessToken'
    };
    var url = Uri.parse('$baseUrl/orders/$orderId/accept');

    try{
      var res = await http.patch(url, headers: headersList);
      final resBody = res.body;

      var data = json.decode(resBody);

      if (res.statusCode >= 200 && res.statusCode < 300) {
        print(resBody);
      } else if (data["message"] == "Not_Authorized") {
        print("ON 401 : $data");
        await getNewAccessToken();
        return await acceptOrder(orderId);
      }
      else {
        print(res.reasonPhrase);
        throw Exception();
      }
    } catch(e){
      print(e);
      throw Exception();
    }
  }

  Future rejectOrder(String orderId) async {

    await getAccessTokens().then((value) {
      accessToken = value;
    });

    var headersList = {
      'Accept': '*/*',
      'Api-Key': apiKey,
      'Authorization': 'Bearer $accessToken'
    };
    var url = Uri.parse('$baseUrl/orders/$orderId/reject');

    try{
      var res = await http.patch(url, headers: headersList);
      final resBody = res.body;

      var data = json.decode(resBody);

      if (res.statusCode >= 200 && res.statusCode < 300) {
        print(resBody);
      } else if (data["message"] == "Not_Authorized") {
        print("ON 401 : $data");
        await getNewAccessToken();
        return await rejectOrder(orderId);
      }
      else {
        print(res.reasonPhrase);
        throw Exception();
      }
    } catch(e){
      print(e);
      throw Exception();
    }
  }

  Future deleteOrder(String orderId) async {

    await getAccessTokens().then((value) {
      accessToken = value;
    });

    var headersList = {
      'Accept': '*/*',
      'Api-Key': apiKey,
      'Authorization': 'Bearer $accessToken'
    };
    var url = Uri.parse('$baseUrl/orders/$orderId');

    try{
      var res = await http.delete(url, headers: headersList);
      final resBody = res.body;

      var data = json.decode(resBody);

      if (res.statusCode >= 200 && res.statusCode < 300) {
        print(data);
      } else if (data["message"] == "Not_Authorized") {
        print("ON 401 : $data");
        await getNewAccessToken();
        return await deleteOrder(orderId);
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