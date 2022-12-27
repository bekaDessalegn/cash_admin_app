import 'dart:convert';
import 'dart:io';

import 'package:cash_admin_app/core/global.dart';
import 'package:cash_admin_app/core/services/auth_service.dart';
import 'package:cash_admin_app/core/services/shared_preference_service.dart';
import 'package:cash_admin_app/features/customize/data/datasource/local/cutomize_local_datasource.dart';
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
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class CustomizeDataSource {

  AuthService authService = AuthService();
  final _prefs = PrefService();
  LogoImageLocalDb logoImageLocalDb = LogoImageLocalDb();

  var refreshToken;
  var accessToken;

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

  Future putLogoImage(LogoImage logoImage, List imageType) async {
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
    var url = Uri.parse('$baseUrl/static-web-contents/logo-Image');

    try{
      var req = http.MultipartRequest('PUT', url);
      req.headers.addAll(headersList);

      if (logoImage.logoImage != "[0, 0, 0, 0, 0, 0, 0, 0]") {
        req.files.add(await http.MultipartFile.fromBytes(
            'logoImage', logoImage.logoImage, contentType: MediaType("${imageType[0]}", "${imageType[1]}"), filename: "Any_name"));
      }

      var res = await req.send();
      final resBody = await res.stream.bytesToString();

      var data = json.decode(resBody);

      if (res.statusCode >= 200 && res.statusCode < 300) {
        print(resBody);
      } else if (data["message"] == "Not_Authorized") {
        print("ON 401 : $data");
        await getNewAccessToken();
        return await putLogoImage(logoImage, imageType);
      } else {
        print(data);
        throw Exception();
      }
    } on SocketException {
      throw Exception();
    }

  }

  Future getLogoImage() async {
    var headersList = {
      'Accept': '*/*',
      'Api-Key': apiKey
    };
    var url = Uri.parse('$baseUrl/static-web-contents?select=["logoImage"]');

    try{
      var res = await http.get(url, headers: headersList);
      final resBody = res.body;

      var data = json.decode(resBody);

      if (res.statusCode >= 200 && res.statusCode < 300) {
        var data = json.decode(resBody);
        var _imageBase64;

        http.Response imageResponse = await http.get(Uri.parse("$baseUrl${data["logoImage"]["path"]}"));
        _imageBase64 = base64Encode(imageResponse.bodyBytes);

        await logoImageLocalDb.addLogoImage(LogoImage(logoImage: base64Decode(_imageBase64)));

        await logoImageLocalDb.updateLogoImage(LogoImage(logoImage: base64Decode(_imageBase64)).toJson());

        final localLogoImage = await logoImageLocalDb.getLogoImage();

        // final logoImage = LogoImage.fromJson(data);
        return localLogoImage;
      } else {
        print(data);
        throw Exception();
      }
    } on SocketException {
      final localLogoImage = await logoImageLocalDb.getLogoImage();
      return localLogoImage;
    }
  }

  Future putHero(HeroContent hero, List imageType) async {
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
    var url = Uri.parse('$baseUrl/static-web-contents/hero');

    var body = {
      'heroShortTitle': hero.heroShortTitle,
      'heroLongTitle': hero.heroLongTitle,
      'heroDescription': hero.heroDescription
    };

    try{
      var req = http.MultipartRequest('PUT', url);
      req.headers.addAll(headersList);
      if (hero.heroImage.path != "[0, 0, 0, 0, 0, 0, 0, 0]") {
        req.files.add(await http.MultipartFile.fromBytes(
            'heroImage', json.decode(hero.heroImage.path).cast<int>(), contentType: MediaType("${imageType[0]}", "${imageType[1]}"), filename: "Any_name"));
      }
      req.fields.addAll(body);

      var res = await req.send();
      final resBody = await res.stream.bytesToString();

      var data = json.decode(resBody);

      if (res.statusCode >= 200 && res.statusCode < 300) {
        print(data);
      } else if (data["message"] == "Not_Authorized") {
        print("ON 401 : $data");
        await getNewAccessToken();
        return await putHero(hero, imageType);
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

  Future putAboutUsImage(AboutUsImage aboutUsImage, List imageType) async {
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
    var url = Uri.parse('$baseUrl/static-web-contents/about-us-image');

    try{
      var req = http.MultipartRequest('PUT', url);
      req.headers.addAll(headersList);

      if (aboutUsImage.aboutUsImage.path != "[0, 0, 0, 0, 0, 0, 0, 0]") {
        req.files.add(await http.MultipartFile.fromBytes(
            'aboutUsImage', json.decode(aboutUsImage.aboutUsImage.path).cast<int>(), contentType: MediaType("${imageType[0]}", "${imageType[1]}"), filename: "Any_name"));
      }

      var res = await req.send();
      final resBody = await res.stream.bytesToString();

      var data = json.decode(resBody);

      if (res.statusCode >= 200 && res.statusCode < 300) {
        print(resBody);
      } else if (data["message"] == "Not_Authorized") {
        print("ON 401 : $data");
        await getNewAccessToken();
        return await putAboutUsImage(aboutUsImage, imageType);
      } else {
        print(data);
        throw Exception();
      }
    } on SocketException {
      throw Exception();
    }

  }

  Future putWhyUsContent(WhyUsContent whyUsContent, List imageType) async {
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
    var url = Uri.parse('$baseUrl/static-web-contents/why-us');

    var body = {
      'whyUsTitle': whyUsContent.whyUsTitle,
      'whyUsDescription': whyUsContent.whyUsDescription
    };

    try{
      var req = http.MultipartRequest('PUT', url);
      req.headers.addAll(headersList);
      if (whyUsContent.whyUsImage.path != "[0, 0, 0, 0, 0, 0, 0, 0]") {
        req.files.add(await http.MultipartFile.fromBytes(
            'whyUsImage', json.decode(whyUsContent.whyUsImage.path).cast<int>(), contentType: MediaType("${imageType[0]}", "${imageType[1]}"), filename: "Any_name"));
      }
      req.fields.addAll(body);

      var res = await req.send();
      final resBody = await res.stream.bytesToString();

      var data = json.decode(resBody);

      if (res.statusCode >= 200 && res.statusCode < 300) {
        print(data);
      } else if (data["message"] == "Not_Authorized") {
        print("ON 401 : $data");
        await getNewAccessToken();
        return await putWhyUsContent(whyUsContent, imageType);
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

  Future putWhatMakesUsUnique(WhatMakesUsUnique whatMakesUsUnique, List imageType) async {
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
    var url = Uri.parse('$baseUrl/static-web-contents/what-makes-us-unique');

    var body = {
      'whatMakesUsUnique': '${json.encode(whatMakesUsUnique.whatMakesUsUnique)}'
    };

    try{
      var req = http.MultipartRequest('PUT', url);
      req.headers.addAll(headersList);
      if (whatMakesUsUnique.whatMakesUsUniqueImage.path != "[0, 0, 0, 0, 0, 0, 0, 0]") {
        req.files.add(await http.MultipartFile.fromBytes(
            'whatMakesUsUniqueImage', json.decode(whatMakesUsUnique.whatMakesUsUniqueImage.path).cast<int>(), contentType: MediaType("${imageType[0]}", "${imageType[1]}"), filename: "Any_name"));
      }
      req.fields.addAll(body);

      var res = await req.send();
      final resBody = await res.stream.bytesToString();

      var data = json.decode(resBody);

      if (res.statusCode >= 200 && res.statusCode < 300) {
        print(data);
      } else if (data["message"] == "Not_Authorized") {
        print("ON 401 : $data");
        await getNewAccessToken();
        return await putWhatMakesUsUnique(whatMakesUsUnique, imageType);
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

  Future putWhoAreWeContent(WhoAreWeContent whoAreWeContent, List imageType) async {
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
    var url = Uri.parse('$baseUrl/static-web-contents/who-are-we');

    var body = {
      'whoAreWeDescription': whoAreWeContent.whoAreWeDescription,
      'whoAreWeVideoLink': whoAreWeContent.whoAreWeVideoLink
    };

    try{
      var req = http.MultipartRequest('PUT', url);
      req.headers.addAll(headersList);
      if (whoAreWeContent.whoAreWeImage.path != "[0, 0, 0, 0, 0, 0, 0, 0]") {
        req.files.add(await http.MultipartFile.fromBytes(
            'whoAreWeImage', json.decode(whoAreWeContent.whoAreWeImage.path).cast<int>(), contentType: MediaType("${imageType[0]}", "${imageType[1]}"), filename: "Any_name"));
      }
      req.fields.addAll(body);

      var res = await req.send();
      final resBody = await res.stream.bytesToString();

      var data = json.decode(resBody);

      if (res.statusCode >= 200 && res.statusCode < 300) {
        print(data);
      } else if (data["message"] == "Not_Authorized") {
        print("ON 401 : $data");
        await getNewAccessToken();
        return await putWhoAreWeContent(whoAreWeContent, imageType);
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

  Future putHowTos(HowTos howTos) async{
    await getRefreshTokens().then((value) {
      refreshToken = value;
    });

    await getAccessTokens().then((value) {
      accessToken = value;
    });

    var headersList = {
      'Accept': '*/*',
      'Api-Key': apiKey,
      'Authorization': 'Bearer $accessToken',
      'Content-Type': 'application/json'
    };
    var url = Uri.parse('$baseUrl/static-web-contents/how-tos');

    var body = {
      "howToBuyFromUsDescription": howTos.howToBuyFromUsDescription,
      "howToAffiliateWithUsDescription": howTos.howToAffiliateWithUsDescription,
      "howToAffiliateWithUsVideoLink": howTos.howToAffiliateWithUsVideoLink
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
        return await putHowTos(howTos);
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

  Future postBrands(Brands brands, List imageType) async {
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
    var url = Uri.parse('$baseUrl/static-web-contents/brands');

    var body = {
      'link': brands.link,
      'rank': '${brands.rank}'
    };

    if(brands.link.isEmpty){
      body = {
        'rank': '${brands.rank}'
      };
    }

    try{
      var req = http.MultipartRequest('POST', url);
      req.headers.addAll(headersList);
      if (brands.logoImage.path != "[0, 0, 0, 0, 0, 0, 0, 0]") {
        req.files.add(await http.MultipartFile.fromBytes(
            'logoImage', json.decode(brands.logoImage.path).cast<int>(), contentType: MediaType("${imageType[0]}", "${imageType[1]}"), filename: "Any_name"));
      }
      req.fields.addAll(body);

      var res = await req.send();
      final resBody = await res.stream.bytesToString();

      var data = json.decode(resBody);

      if (res.statusCode >= 200 && res.statusCode < 300) {
        print(data);
      } else if (data["message"] == "Not_Authorized") {
        print("ON 401 : $data");
        await getNewAccessToken();
        return await postBrands(brands, imageType);
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

  Future postSocialLinks(SocialLinks socialLinks, List imageType) async {
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
    var url = Uri.parse('$baseUrl/static-web-contents/social-links');

    var body = {
      'link': socialLinks.link,
      'rank': '${socialLinks.rank}'
    };

    try{
      var req = http.MultipartRequest('POST', url);
      req.headers.addAll(headersList);
      if (socialLinks.logoImage.path != "[0, 0, 0, 0, 0, 0, 0, 0]") {
        req.files.add(await http.MultipartFile.fromBytes(
            'logoImage', json.decode(socialLinks.logoImage.path).cast<int>(), contentType: MediaType("${imageType[0]}", "${imageType[1]}"), filename: "Any_name"));
      }
      req.fields.addAll(body);

      var res = await req.send();
      final resBody = await res.stream.bytesToString();

      var data = json.decode(resBody);

      if (res.statusCode >= 200 && res.statusCode < 300) {
        print(data);
      } else if (data["message"] == "Not_Authorized") {
        print("ON 401 : $data");
        await getNewAccessToken();
        return await postSocialLinks(socialLinks, imageType);
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

  Future getHomeContent() async {
    var headersList = {
      'Accept': '*/*',
      'Api-Key': apiKey
    };
    var url = Uri.parse('$baseUrl/static-web-contents?select=["heroImage", "heroShortTitle", "heroLongTitle", "heroDescription", "whyUsImage", "whyUsTitle", "whyUsDescription", "whatMakesUsUnique", "whatMakesUsUniqueImage", "brands", "socialLinks" ]');

    try {
      var res = await http.get(url, headers: headersList);
      final resBody = res.body;

      final data = json.decode(resBody);

      if (res.statusCode >= 200 && res.statusCode < 300) {
        final homeContent = HomeContent.fromJson(data);
        print(data);
        return homeContent;
      } else {
        print(data);
        throw Exception();
      }
    } on SocketException {
      return "Socket Error";
    }
  }

  Future deleteBrand(String id) async {
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
    var url = Uri.parse('$baseUrl/static-web-contents/brands/$id');

    try{
      var res = await http.delete(url, headers: headersList);
      final resBody = res.body;

      var data = json.decode(resBody);

      if (res.statusCode >= 200 && res.statusCode < 300) {
        print(data);
      } else if (data["message"] == "Not_Authorized") {
        print("ON 401 : $data");
        await getNewAccessToken();
        return await deleteBrand(id);
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

  Future deleteSocialLink(String id) async {
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
    var url = Uri.parse('$baseUrl/static-web-contents/social-links/$id');

    try{
      var res = await http.delete(url, headers: headersList);
      final resBody = res.body;

      var data = json.decode(resBody);

      if (res.statusCode >= 200 && res.statusCode < 300) {
        print(data);
      } else if (data["message"] == "Not_Authorized") {
        print("ON 401 : $data");
        await getNewAccessToken();
        return await deleteSocialLink(id);
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

  Future patchBrands(Brands brands, List imageType, String id) async {
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
    var url = Uri.parse('$baseUrl/static-web-contents/brands/$id');

    var body = {
      'link': brands.link,
      'rank': '${brands.rank}'
    };

    if(brands.link.isEmpty){
      body = {
        'rank': '${brands.rank}'
      };
    }

    try{
      var req = http.MultipartRequest('PATCH', url);
      req.headers.addAll(headersList);
      if (brands.logoImage.path != "[0, 0, 0, 0, 0, 0, 0, 0]") {
        req.files.add(await http.MultipartFile.fromBytes(
            'logoImage', json.decode(brands.logoImage.path).cast<int>(), contentType: MediaType("${imageType[0]}", "${imageType[1]}"), filename: "Any_name"));
      }
      req.fields.addAll(body);

      var res = await req.send();
      final resBody = await res.stream.bytesToString();

      var data = json.decode(resBody);

      if (res.statusCode >= 200 && res.statusCode < 300) {
        print(data);
      } else if (data["message"] == "Not_Authorized") {
        print("ON 401 : $data");
        await getNewAccessToken();
        return await patchBrands(brands, imageType, id);
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

  Future patchSocialLinks(SocialLinks socialLinks, List imageType, String id) async {
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
    var url = Uri.parse('$baseUrl/static-web-contents/social-links/$id');

    var body = {
      'link': socialLinks.link,
      'rank': '${socialLinks.rank}'
    };

    try{
      var req = http.MultipartRequest('PATCH', url);
      req.headers.addAll(headersList);
      if (socialLinks.logoImage.path != "[0, 0, 0, 0, 0, 0, 0, 0]") {
        req.files.add(await http.MultipartFile.fromBytes(
            'logoImage', json.decode(socialLinks.logoImage.path).cast<int>(), contentType: MediaType("${imageType[0]}", "${imageType[1]}"), filename: "Any_name"));
      }
      req.fields.addAll(body);

      var res = await req.send();
      final resBody = await res.stream.bytesToString();

      var data = json.decode(resBody);

      if (res.statusCode >= 200 && res.statusCode < 300) {
        print(data);
      } else if (data["message"] == "Not_Authorized") {
        print("ON 401 : $data");
        await getNewAccessToken();
        return await patchSocialLinks(socialLinks, imageType, id);
      }
      else {
        print(data);
        throw Exception();
      }
    } catch(e) {
      print(e);
      throw Exception();
    }
  }

  Future getAboutUsContent() async{
    var headersList = {
      'Accept': '*/*',
      'Api-Key': apiKey
    };
    var url = Uri.parse('$baseUrl/static-web-contents?select=["aboutUsImage", "whoAreWeImage", "whoAreWeDescription", "whoAreWeVideoLink", "howToBuyFromUsDescription", "howToAffiliateWithUsDescription", "howToAffiliateWithUsVideoLink"]');

    try{
      var res = await http.get(url, headers: headersList);
      final resBody = res.body;

      var data = json.decode(resBody);

      if (res.statusCode >= 200 && res.statusCode < 300) {
        print(data);
        final aboutUsContent = AboutUsContent.fromJson(data);
        return aboutUsContent;
      } else {
        print(data);
        throw Exception();
      }
    } on SocketException {
      return "Socket Error";
    }
  }
}