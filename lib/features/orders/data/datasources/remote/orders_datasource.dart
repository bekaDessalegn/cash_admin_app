import 'dart:convert';
import 'dart:io';

import 'package:cash_admin_app/core/global.dart';
import 'package:cash_admin_app/core/services/auth_service.dart';
import 'package:cash_admin_app/core/services/shared_preference_service.dart';
import 'package:cash_admin_app/features/orders/data/datasources/local/order_local_datasource.dart';
import 'package:cash_admin_app/features/orders/data/models/local_order.dart';
import 'package:cash_admin_app/features/orders/data/models/ordered_affiliate.dart';
import 'package:cash_admin_app/features/orders/data/models/orders.dart';
import 'package:http/http.dart' as http;

class OrdersDataSource {
  AuthService authService = AuthService();
  final _prefs = PrefService();
  OrderLocalDb orderLocalDb = OrderLocalDb();

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
      await authService.setAccessToken(accessToken: data["newAccessToken"]);
    } else if(data["message"] == "Invalid_Refresh_Token") {
      _prefs.removeCache();
      authService.logOut();
    } else {
      throw Exception();
    }
  }

  Future getOrders(int skipNumber) async {

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
        for (var order in data) {
          await orderLocalDb.addOrder(LocalOrder(
              orderId : order["orderId"],
              productName: order["product"]["productName"],
              phone: order["orderedBy"]["phone"],
              fullName: order["affiliate"] == null ? "None" : order["affiliate"]["fullName"],
              orderedAt: order["orderedAt"]
          ));
          print("Has entered");
        }
        List content = json.decode(resBody);
        final List<Orders> orders = content.map((order) => Orders.fromJson(order)).toList();
        return orders;
      } else if (data["message"] == "Not_Authorized") {
        await getNewAccessToken();
        return await getOrders(skipNumber);
      } else {
        print(data);
        throw Exception();
      }
    } on SocketException {
      final localOrder = await orderLocalDb.getListOrders();
      print(localOrder[0].productName);
      return localOrder;
    }

  }

  Future<List<Orders>> filterPendingOrders(int skipNumber) async {
    await getAccessTokens().then((value) {
      accessToken = value;
    });

    var headersList = {
      'Accept': '*/*',
      'Api-Key': apiKey,
      'Authorization': 'Bearer $accessToken'
    };
    var url = Uri.parse('$baseUrl/orders?filter={"status": "Pending"}&limit=$limit&skip=$skipNumber');

    try{
      var res = await http.get(url, headers: headersList);
      final resBody = res.body;

      var data = json.decode(resBody);

      if (res.statusCode >= 200 && res.statusCode < 300) {
        List content = json.decode(resBody);
        final List<Orders> orders = content.map((order) => Orders.fromJson(order)).toList();
        return orders;
      } else if (data["message"] == "Not_Authorized") {
        await getNewAccessToken();
        return await filterPendingOrders(skipNumber);
      }
      else {
        throw Exception();
      }
    } catch(e){
      throw Exception();
    }
  }

  Future<List<Orders>> filterAcceptedOrders(int skipNumber) async {
    await getAccessTokens().then((value) {
      accessToken = value;
    });

    var headersList = {
      'Accept': '*/*',
      'Api-Key': apiKey,
      'Authorization': 'Bearer $accessToken'
    };
    var url = Uri.parse('$baseUrl/orders?filter={"status": "Accepted"}&limit=$limit&skip=$skipNumber');

    try{
      var res = await http.get(url, headers: headersList);
      final resBody = res.body;

      var data = json.decode(resBody);

      if (res.statusCode >= 200 && res.statusCode < 300) {
        List content = json.decode(resBody);
        final List<Orders> orders = content.map((order) => Orders.fromJson(order)).toList();
        return orders;
      } else if (data["message"] == "Not_Authorized") {
        await getNewAccessToken();
        return await filterAcceptedOrders(skipNumber);
      }
      else {
        throw Exception();
      }
    } catch(e){
      throw Exception();
    }
  }

  Future<List<Orders>> filterRejectedOrders(int skipNumber) async {
    await getAccessTokens().then((value) {
      accessToken = value;
    });

    var headersList = {
      'Accept': '*/*',
      'Api-Key': apiKey,
      'Authorization': 'Bearer $accessToken'
    };
    var url = Uri.parse('$baseUrl/orders?filter={"status": "Rejected"}&limit=$limit&skip=$skipNumber');

    try{
      var res = await http.get(url, headers: headersList);
      final resBody = res.body;

      var data = json.decode(resBody);

      if (res.statusCode >= 200 && res.statusCode < 300) {
        List content = json.decode(resBody);
        final List<Orders> orders = content.map((order) => Orders.fromJson(order)).toList();
        return orders;
      } else if (data["message"] == "Not_Authorized") {
        await getNewAccessToken();
        return await filterRejectedOrders(skipNumber);
      }
      else {
        throw Exception();
      }
    } catch(e){
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
        List content = json.decode(resBody);
        final List<Orders> orders = content.map((order) => Orders.fromJson(order)).toList();
        return orders;
      } else if (data["message"] == "Not_Authorized") {
        await getNewAccessToken();
        return await searchOrders(fullName, companyName);
      }
      else {
        throw Exception();
      }
    } catch(e){
      throw Exception();
    }

  }

  Future getSingleOrder(String orderId) async {

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
        final order = Orders.fromJson(data);
        return order;
      } else if (data["message"] == "Not_Authorized") {
        await getNewAccessToken();
        return await getSingleOrder(orderId);
      } else {
        print(data);
        throw Exception();
      }
    } on SocketException {
      return "Socket Error";
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
      } else if (data["message"] == "Not_Authorized") {
        await getNewAccessToken();
        return await acceptOrder(orderId);
      }
      else {
        throw Exception();
      }
    } catch(e){
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
      } else if (data["message"] == "Not_Authorized") {
        await getNewAccessToken();
        return await rejectOrder(orderId);
      }
      else {
        throw Exception();
      }
    } catch(e){
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
      } else if (data["message"] == "Not_Authorized") {
        await getNewAccessToken();
        return await deleteOrder(orderId);
      }
      else {
        throw Exception();
      }
    } catch(e){
      throw Exception();
    }
  }
}