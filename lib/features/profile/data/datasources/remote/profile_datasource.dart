import 'dart:convert';
import 'dart:io';

import 'package:cash_admin_app/core/global.dart';
import 'package:cash_admin_app/core/services/auth_service.dart';
import 'package:cash_admin_app/core/services/shared_preference_service.dart';
import 'package:cash_admin_app/features/profile/data/datasources/local/profile_local_datasource.dart';
import 'package:cash_admin_app/features/profile/data/models/admin.dart';
import 'package:http/http.dart' as http;

class ProfileDataSource {
  AuthService authService = AuthService();
  final _prefs = PrefService();
  ProfileLocalDb profileLocalDb = ProfileLocalDb();

  var refreshToken;
  var accessToken;
  var verificationToken;

  Future<Admin> getAdmin() async {
    await getRefreshTokens().then((value) {
      refreshToken = value;
    });

    await getAccessTokens().then((value) {
      accessToken = value;
    });

    var headersList = {
      'Accept': '*/*',
      'Api-Key': apiKey,
      'Authorization': 'Bearer $accessToken'
    };

    var url = Uri.parse('$baseUrl/admin');

    try {
      var res = await http.get(url, headers: headersList);
      final resBody = res.body;

      var data = json.decode(resBody);

      if (res.statusCode >= 200 && res.statusCode < 300) {
        // Admin admin;
        //
        // admin = Admin(
        //     id: data["userId"],
        //     username: data["username"],
        //     email: data["email"] ?? "Null",
        //     commissionRate: data["settings"]["commissionRate"]);

        await setCommissionRate(
            commissionRate: data["settings"]["commissionRate"]);
        await authService.setEmail(email: data["email"] ?? "Null");

        print(data);

        print("Admin recieved from remote");
        print(data);
        print(data["userId"]);
        print(data["settings"]["commissionRate"]);

        await profileLocalDb.addAdmin(Admin(
            id: data["userId"],
            username: data["username"],
            email: data["email"] ?? "Null",
            commissionRate: data["settings"]["commissionRate"]));

        final updated = await profileLocalDb.updateAdmin(data["userId"], Admin(
            id: data["userId"],
            username: data["username"],
            email: data["email"] ?? "Null",
            commissionRate: data["settings"]["commissionRate"]).toJson());

        print("Is it updated");
        print(updated);

        final admin = await profileLocalDb.getAdmin();
        print("This is the local DB");
        print(admin.toJson());

        return admin;
      } else if (data["message"] == "Not_Authorized") {
        await getNewAccessToken();
        return await getAdmin();
      } else {
        throw Exception("api");
      }
    } on SocketException {
      throw const SocketException("network");
    }
  }

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

  Future editUsername(String newUsername) async {
    await getAccessTokens().then((value) {
      accessToken = value;
    });

    var headersList = {
      'Accept': '*/*',
      'Api-Key': apiKey,
      'Authorization': 'Bearer $accessToken',
      'Content-Type': 'application/json'
    };

    var url = Uri.parse('$baseUrl/admin/username');

    var body = {"newUsername": newUsername};

    try {
      var res =
          await http.patch(url, headers: headersList, body: json.encode(body));

      final resBody = res.body;

      var data = json.decode(resBody);

      if (res.statusCode >= 200 && res.statusCode < 300) {
      } else if (data["message"] == "Not_Authorized") {
        print("ON 401 : $data");
        await getNewAccessToken();
        return await editUsername(newUsername);
      } else {
        print(data);
        throw Exception("api");
      }
    } on SocketException {
      throw Exception("network");
    }
  }

  Future editPassword(String oldPasswordHash, String newPasswordHash) async {
    await getAccessTokens().then((value) {
      accessToken = value;
    });

    var headersList = {
      'Accept': '*/*',
      'Api-Key': apiKey,
      'Authorization': 'Bearer $accessToken',
      'Content-Type': 'application/json'
    };
    var url = Uri.parse('$baseUrl/admin/password-hash');

    var body = {
      "oldPasswordHash": oldPasswordHash,
      "newPasswordHash": newPasswordHash
    };

    try {
      var res =
          await http.patch(url, headers: headersList, body: json.encode(body));
      final resBody = res.body;

      var data = json.decode(resBody);

      if (res.statusCode >= 200 && res.statusCode < 300) {
        print(data);
      } else if (data["message"] == "Not_Authorized") {
        print("ON 401 : $data");
        await getNewAccessToken();
        return await editPassword(oldPasswordHash, newPasswordHash);
      } else if (data["message"] == "User_Not_Found" ||
          data["message"] == "Wrong_Password_Hash" ||
          data["message"] == "Invalid_Input") {
        print(data);
        throw const HttpException("404");
      } else {
        throw Exception();
      }
    } on SocketException {
      throw Exception();
    }
  }

  Future changeCommissionRate(int commissionRate) async {
    await getAccessTokens().then((value) {
      accessToken = value;
    });

    var headersList = {
      'Accept': '*/*',
      'Api-Key': apiKey,
      'Authorization': 'Bearer $accessToken',
      'Content-Type': 'application/json'
    };
    var url = Uri.parse('$baseUrl/admin/settings');

    var body = {"commissionRate": commissionRate};

    try {
      var res =
          await http.patch(url, headers: headersList, body: json.encode(body));
      final resBody = res.body;

      var data;

      if(res.body.isNotEmpty) {
        data = json.decode(resBody);
      }

      if (res.statusCode >= 200 && res.statusCode < 300) {
        print(data);
      } else if (data["message"] == "Not_Authorized") {
        print("ON 401 : $data");
        await getNewAccessToken();
        return await changeCommissionRate(commissionRate);
      } else {
        print(data);
        throw Exception("api");
      }
    } on SocketException {
      throw Exception("network");
    }
  }

  Future putEmail(String email) async {
    await getAccessTokens().then((value) {
      accessToken = value;
    });

    var headersList = {
      'Accept': '*/*',
      'Api-Key': apiKey,
      'Authorization': 'Bearer $accessToken',
      'Content-Type': 'application/json'
    };
    var url = Uri.parse('$baseUrl/admin/email');

    var body = {"newEmail": email};

    try {
      var res =
          await http.put(url, headers: headersList, body: json.encode(body));
      final resBody = res.body;

      var data = json.decode(resBody);

      if (res.statusCode >= 200 && res.statusCode < 300) {
        verificationToken = data["verificationToken"];
        print(data);
      } else if (data["message"] == "Not_Authorized") {
        print("ON 401 : $data");
        await getNewAccessToken();
        return await putEmail(email);
      } else if (data["message"] == "User_Not_Found" ||
          data["message"] == "Invalid_Email" ||
          data["message"] == "Invalid_Input") {
        print(data);
        throw const HttpException("404");
      } else {
        throw Exception();
      }
    } on SocketException {
      throw Exception();
    }
  }

  Future verifyEmail(String verificationCode) async {
    await getAccessTokens().then((value) {
      accessToken = value;
    });

    var headersList = {
      'Accept': '*/*',
      'Api-Key': apiKey,
      'Authorization': 'Bearer $accessToken',
      'Content-Type': 'application/json'
    };
    var url = Uri.parse('$baseUrl/admin/verify-email');

    var body = {
      "verificationCode": verificationCode,
      "verificationToken": verificationToken
    };

    try {
      var res =
          await http.put(url, headers: headersList, body: json.encode(body));
      final resBody = res.body;

      var data = json.decode(resBody);

      if (res.statusCode >= 200 && res.statusCode < 300) {
        print(data);
      } else if (data["message"] == "Not_Authorized") {
        print("ON 401 : $data");
        await getNewAccessToken();
        return await verifyEmail(verificationCode);
      } else if (data["message"] == "User_Not_Found" ||
          data["message"] == "Invalid_Email" ||
          data["message"] == "Invalid_Input" ||
          data["message"] == "Invalid_Verification_Code" ||
          data["message"] == "Expired_Token" ||
          data["message"] == "Invalid_Token") {
        print(data);
        throw const HttpException("404");
      } else {
        throw Exception();
      }
    } on SocketException {
      throw Exception();
    }
  }

  Future signout() async {
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
    var url = Uri.parse('$baseUrl/sessions/sign-out');

    var res = await http.delete(url, headers: headersList);
    final resBody = res.body;

    var data = json.decode(resBody);
    print(refreshToken);

    if (res.statusCode >= 200 && res.statusCode < 300) {
      print(data);
    } else if (data["message"] == "Not_Authorized") {
      print("ON 401 : $data");
      await getNewAccessToken();
      return await signout();
    }
    else {
      print(data);
      throw Exception();
    }
  }
}
