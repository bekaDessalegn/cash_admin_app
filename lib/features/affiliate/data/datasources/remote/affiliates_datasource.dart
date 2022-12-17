import 'dart:convert';
import 'dart:io';

import 'package:cash_admin_app/core/global.dart';
import 'package:cash_admin_app/core/services/auth_service.dart';
import 'package:cash_admin_app/core/services/shared_preference_service.dart';
import 'package:cash_admin_app/features/affiliate/data/datasources/local/affiliate_local_datasource.dart';
import 'package:cash_admin_app/features/affiliate/data/models/affiliates.dart';
import 'package:cash_admin_app/features/affiliate/data/models/children.dart';
import 'package:cash_admin_app/features/affiliate/data/models/local_affiliate.dart';
import 'package:cash_admin_app/features/affiliate/data/models/parent_affiliate.dart';
import 'package:http/http.dart' as http;

class AffiliatesDataSource {
  AuthService authService = AuthService();
  final _prefs = PrefService();
  AffiliateLocalDb affiliateLocalDb = AffiliateLocalDb();

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
    } else if (data["message"] == "Invalid_Refresh_Token") {
      _prefs.removeCache();
      authService.logOut();
    } else {
      throw Exception();
    }
  }

  Future getAffiliates(int skipNumber) async {
    await getAccessTokens().then((value) {
      accessToken = value;
    });

    var headersList = {
      'Accept': '*/*',
      'Api-Key': apiKey,
      'Authorization': 'Bearer $accessToken'
    };
    var url = Uri.parse('$baseUrl/affiliates?limit=$limit&skip=$skipNumber');

    try {
      var res = await http.get(url, headers: headersList);
      final resBody = res.body;

      var data = json.decode(resBody);

      if (res.statusCode >= 200 && res.statusCode < 300) {
        List content = json.decode(resBody);
        final List<Affiliates> affiliates =
            content.map((affiliate) => Affiliates.fromJson(affiliate)).toList();

        var data = json.decode(resBody);

        for (var affiliate in data) {
          print(affiliate);
          await affiliateLocalDb.addAffiliate(LocalAffiliate(
              userId: affiliate["userId"],
              fullName: affiliate["fullName"],
              phone: affiliate["phone"],
              totalMade: affiliate["wallet"]["totalMade"]));
          print("Has entered");
        }

        return affiliates;
      } else if (data["message"] == "Not_Authorized") {
        await getNewAccessToken();
        return await getAffiliates(skipNumber);
      } else {
        print(data);
        throw Exception();
      }
    } on SocketException {
      final localAffiliate = await affiliateLocalDb.getListAffiliates();
      print(localAffiliate[0].fullName);
      return localAffiliate;
    }
  }

  Future<ParentAffiliate> getParentAffiliate(String parentId) async {
    await getAccessTokens().then((value) {
      accessToken = value;
    });

    var headersList = {
      'Accept': '*/*',
      'Api-Key': apiKey,
      'Authorization': 'Bearer $accessToken'
    };
    var url = Uri.parse('$baseUrl/affiliates/$parentId');

    try {
      var res = await http.get(url, headers: headersList);
      final resBody = res.body;

      var data = json.decode(resBody);

      if (res.statusCode >= 200 && res.statusCode < 300) {
        final affiliate = ParentAffiliate.fromJson(data);
        return affiliate;
      } else if (data["message"] == "Not_Authorized") {
        await getNewAccessToken();
        return await getParentAffiliate(parentId);
      } else if (data["message"] == "User_Not_Found") {
        return ParentAffiliate(userId: "0", fullName: "Deleted Affiliate");
      } else {
        throw Exception();
      }
    } catch (e) {
      throw Exception();
    }
  }

  Future<List<Affiliates>> searchAffiliates(String affiliateName) async {
    await getAccessTokens().then((value) {
      accessToken = value;
    });

    var headersList = {
      'Accept': '*/*',
      'Api-Key': apiKey,
      'Authorization': 'Bearer $accessToken'
    };
    var url =
        Uri.parse('$baseUrl/affiliates?search={"fullName":"$affiliateName"}');

    try {
      var res = await http.get(url, headers: headersList);
      final resBody = res.body;

      var data = json.decode(resBody);
      List content = json.decode(resBody);

      if (res.statusCode >= 200 && res.statusCode < 300) {
        final List<Affiliates> affiliates =
            content.map((affiliate) => Affiliates.fromJson(affiliate)).toList();
        return affiliates;
      } else if (data["message"] == "Not_Authorized") {
        await getNewAccessToken();
        return await searchAffiliates(affiliateName);
      } else if (res.statusCode == 429) {
        throw Exception();
      } else {
        throw Exception();
      }
    } on SocketException {
      throw Exception();
    }
  }

  Future getAffiliate(String userId) async {
    await getAccessTokens().then((value) {
      accessToken = value;
    });

    var headersList = {
      'Accept': '*/*',
      'Api-Key': apiKey,
      'Authorization': 'Bearer $accessToken'
    };
    var url = Uri.parse('$baseUrl/affiliates/$userId');

    try {
      var res = await http.get(url, headers: headersList);
      final resBody = res.body;

      var data = json.decode(resBody);

      if (res.statusCode >= 200 && res.statusCode < 300) {
        final affiliate = Affiliates.fromJson(data);
        return affiliate;
      } else if (data["message"] == "Not_Authorized") {
        await getNewAccessToken();
        return await getAffiliate(userId);
      } else {
        print(data);
        throw Exception();
      }
    } on SocketException {
      return "Socket Error";
    }
  }

  Future<List<Children>> getChildren(String userId) async {
    await getAccessTokens().then((value) {
      accessToken = value;
    });

    var headersList = {
      'Accept': '*/*',
      'Api-Key': apiKey,
      'Authorization': 'Bearer $accessToken'
    };
    var url = Uri.parse('$baseUrl/affiliates/$userId/children');

    try {
      var res = await http.get(url, headers: headersList);
      final resBody = res.body;

      var data = json.decode(resBody);

      if (res.statusCode >= 200 && res.statusCode < 300) {
        List content = json.decode(resBody);
        List<Children> children =
            content.map((child) => Children.fromJson(child)).toList();
        return children;
      } else if (data["message"] == "Not_Authorized") {
        await getNewAccessToken();
        return await getChildren(userId);
      } else {
        throw Exception();
      }
    } catch (e) {
      throw Exception();
    }
  }

  Future<List<Affiliates>> getAffiliateEarningsFromLowToHigh(
      int skipNumber) async {
    await getAccessTokens().then((value) {
      accessToken = value;
    });

    var headersList = {
      'Accept': '*/*',
      'Api-Key': apiKey,
      'Authorization': 'Bearer $accessToken'
    };
    var url = Uri.parse(
        '$baseUrl/affiliates?sort={"wallet.totalMade": 1}&limit=$limit&skip=$skipNumber');

    try {
      var res = await http.get(url, headers: headersList);
      final resBody = res.body;

      final data = json.decode(resBody);

      if (res.statusCode >= 200 && res.statusCode < 300) {
        List content = json.decode(resBody);
        final List<Affiliates> affiliates =
            content.map((affiliate) => Affiliates.fromJson(affiliate)).toList();
        return affiliates;
      } else if (data["message"] == "Not_Authorized") {
        await getNewAccessToken();
        return await getAffiliateEarningsFromLowToHigh(skipNumber);
      } else {
        throw Exception();
      }
    } catch (e) {
      throw Exception();
    }
  }

  Future<List<Affiliates>> getAffiliateEarningsFromHighToLow(
      int skipNumber) async {
    await getAccessTokens().then((value) {
      accessToken = value;
    });

    var headersList = {
      'Accept': '*/*',
      'Api-Key': apiKey,
      'Authorization': 'Bearer $accessToken'
    };
    var url = Uri.parse(
        '$baseUrl/affiliates?sort={"wallet.totalMade": -1}&limit=$limit&skip=$skipNumber');

    try {
      var res = await http.get(url, headers: headersList);
      final resBody = res.body;

      final data = json.decode(resBody);

      if (res.statusCode >= 200 && res.statusCode < 300) {
        List content = json.decode(resBody);
        final List<Affiliates> affiliates =
            content.map((affiliate) => Affiliates.fromJson(affiliate)).toList();
        return affiliates;
      } else if (data["message"] == "Not_Authorized") {
        await getNewAccessToken();
        return await getAffiliateEarningsFromHighToLow(skipNumber);
      } else {
        throw Exception();
      }
    } catch (e) {
      throw Exception();
    }
  }

  Future<List<Affiliates>> getMostParentAffiliate(int skipNumber) async {
    await getAccessTokens().then((value) {
      accessToken = value;
    });

    var headersList = {
      'Accept': '*/*',
      'Api-Key': apiKey,
      'Authorization': 'Bearer $accessToken'
    };
    var url = Uri.parse(
        '$baseUrl/affiliates?sort={"childrenCount":-1}&limit=$limit&skip=$skipNumber');

    try {
      var res = await http.get(url, headers: headersList);
      final resBody = res.body;

      final data = json.decode(resBody);

      if (res.statusCode >= 200 && res.statusCode < 300) {
        List content = json.decode(resBody);
        final List<Affiliates> affiliates =
            content.map((affiliate) => Affiliates.fromJson(affiliate)).toList();
        return affiliates;
      } else if (data["message"] == "Not_Authorized") {
        await getNewAccessToken();
        return await getAffiliateEarningsFromHighToLow(skipNumber);
      } else {
        throw Exception();
      }
    } catch (e) {
      throw Exception();
    }
  }
}
