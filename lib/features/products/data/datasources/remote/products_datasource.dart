import 'dart:convert';
import 'dart:io';

import 'package:cash_admin_app/core/global.dart';
import 'package:cash_admin_app/core/services/auth_service.dart';
import 'package:cash_admin_app/core/services/shared_preference_service.dart';
import 'package:cash_admin_app/features/products/data/models/categories.dart';
import 'package:cash_admin_app/features/products/data/models/products.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

Products? product_contents;
// String? desktopProductId;

class ProductsDataSource {
  AuthService authService = AuthService();
  final _prefs = PrefService();

  var refreshToken;
  var accessToken;

  int limit = 9;

  Future postProducts(Products products, List imageType, List listImageType) async {
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
    var url = Uri.parse('$baseUrl/products');

    var body = {
      'productDetails':
          '{ "productName": "${products.productName}", "description": ${json.encode(products.description)}, "price": ${products.price}, "categories": ${json.encode(products.categories)}, "commission": ${products.commission}, "published": ${products.published}, "featured": ${products.featured}, "topSeller": ${products.topSeller} }'
    };

    try {
      var req = http.MultipartRequest('POST', url);
      req.headers.addAll(headersList);
      if (products.mainImage!.path != "[0, 0, 0, 0, 0, 0, 0, 0]") {
        req.files.add(await http.MultipartFile.fromBytes(
            'mainImage', json.decode(products.mainImage!.path).cast<int>(), contentType: MediaType("${imageType[0]}", "${imageType[1]}"), filename: "Any_name"));
      }
      if (products.moreImages!.isNotEmpty) {
        for (var images = 0; images < products.moreImages!.length; images++) {
          req.files.add(await http.MultipartFile.fromBytes(
              'moreImages', products.moreImages![images], contentType: MediaType("${listImageType[images][0]}", "${listImageType[images][1]}"), filename: "Any_name"));
        }
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
        return await postProducts(products, imageType, listImageType);
      } else if (data["message"] == "Product_Name_Already_Exist") {
        print(data);
        throw const HttpException("404");
      } else {
        print(data);
        throw Exception();
      }
    } on SocketException {
      throw Exception();
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

  Future<List<Products>> getProducts() async {
    var headersList = {
      'Accept': '*/*',
      'Api-Key': apiKey,
      'Authorization': 'Bearer $accessToken'
    };
    var url = Uri.parse('$baseUrl/products');

    try {
      var res = await http.get(url, headers: headersList);
      final resBody = res.body;

      var data = json.decode(resBody);
      List content = json.decode(resBody);

      if (res.statusCode >= 200 && res.statusCode < 300) {
        final List<Products> products =
            content.map((product) => Products.fromJson(product)).toList();
        print(data);
        return products;
      } else if (data["message"] == "Not_Authorized") {
        print("ON 401 : $data");
        await getNewAccessToken();
        return await getProducts();
      } else {
        print(data);
        throw Exception();
      }
    } on SocketException {
      throw Exception();
    }
  }

  Future<List<Products>> getProductsForList(int skipNumber) async {

    await getAccessTokens().then((value) {
      accessToken = value;
    });

    var headersList = {
      'Accept': '*/*',
      'Api-Key': apiKey,
      'Authorization': 'Bearer $accessToken'
    };
    var url = Uri.parse('$baseUrl/products?select=["productName","price","viewCount","mainImage", "commission", "categories", "featured", "published", "topSeller"]&limit=$limit&skip=$skipNumber');

    try {
      var res = await http.get(url, headers: headersList);
      final resBody = res.body;

      var data = json.decode(resBody);
      List content = json.decode(resBody);

      if (res.statusCode >= 200 && res.statusCode < 300) {
        final List<Products> products =
        content.map((product) => Products.fromJson(product)).toList();
        // desktopProductId = products.map((e) => e.productId).last;
        // print("The first index is : ");
        // print(desktopProductId);
        print("The first index is : ");
        print(productId);
        print(data);
        return products;
      } else if (data["message"] == "Not_Authorized") {
        print("ON 401 : $data");
        await getNewAccessToken();
        return await getProductsForList(skipNumber);
      } else if(res.statusCode == 429){
        print("Too many requests");
        throw Exception();
      } else {
        print(data);
        throw Exception();
      }
    } on SocketException {
      throw Exception();
    }
  }

  Future<Products> getProduct(String? productId) async {

    await getAccessTokens().then((value) {
      accessToken = value;
    });

    var headersList = {
      'Accept': '*/*',
      'Api-Key': apiKey,
      'Authorization': 'Bearer $accessToken'
    };
    var url = Uri.parse('$baseUrl/products/$productId');

    print("WWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWwww");
    print(accessToken);

    try{
      var res = await http.get(url, headers: headersList);
      final resBody = res.body;

      var data = json.decode(resBody);

      if (res.statusCode >= 200 && res.statusCode < 300) {
        final product = Products.fromJson(data);
        product_contents = product;
        print("The procts are : ");
        print(product_contents!.toJson());
        print(data);
        return product;
      } else if (data["message"] == "Not_Authorized") {
        print("ON 401 : $data");
        await getNewAccessToken();
        return await getProduct(productId);
      } else {
        print(data);
        throw Exception();
      }
    } on SocketException {
      throw Exception();
    }
  }

  Future editProduct(Products product, List imageType, List listImageType) async {

    await getAccessTokens().then((value) {
      accessToken = value;
    });

    var headersList = {
      'Accept': '*/*',
      'Api-Key': apiKey,
      'Authorization': 'Bearer $accessToken'
    };
    var url = Uri.parse('$baseUrl/products/${product.productId}');

    var body = {
      'productDetails':
      '{ "productName": "${product.productName}", "description": ${json.encode(product.description)}, "price": ${product.price}, "categories": ${json.encode(product.categories)}, "commission": ${product.commission}, "published": ${product.published}, "featured": ${product.featured}, "topSeller": ${product.topSeller} }'
    };

    try{
      var req = http.MultipartRequest('PATCH', url);
      req.headers.addAll(headersList);
      if (product.mainImage!.path != "[0, 0, 0, 0, 0, 0, 0, 0]") {
        req.files.add(await http.MultipartFile.fromBytes(
            'mainImage', json.decode(product.mainImage!.path).cast<int>(), contentType: MediaType("${imageType[0]}", "${imageType[1]}"), filename: "Any_name"));
      }
      if (product.moreImages!.isNotEmpty) {
        for (var images = 0; images < product.moreImages!.length; images++) {
          req.files.add(await http.MultipartFile.fromBytes(
              'moreImages', product.moreImages![images], contentType: MediaType("${listImageType[images][0]}", "${listImageType[images][1]}"), filename: "Any_name"));
        }
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
        return await editProduct(product, imageType, listImageType);
      } else if (data["message"] == "Product_Name_Already_Exist") {
        print(data);
        throw const HttpException("404");
      } else {
        print(data);
        throw Exception();
      }
    } on SocketException {
      throw Exception();
    }
  }

  Future deleteProduct(String? productId) async {

    await getAccessTokens().then((value) {
      accessToken = value;
    });

    var headersList = {
      'Accept': '*/*',
      'Api-Key': apiKey,
      'Authorization': 'Bearer $accessToken'
    };
    var url = Uri.parse('$baseUrl/products/$productId');

    try{
      var res = await http.delete(url, headers: headersList);
      final resBody = res.body;

      var data = json.decode(resBody);

      if (res.statusCode >= 200 && res.statusCode < 300) {
        print(data);
      } else if (data["message"] == "Not_Authorized") {
        print("ON 401 : $data");
        await getNewAccessToken();
        return await deleteProduct(productId);
      } else if(data["message"] == "Pending_Order") {
        print(data);
        throw const HttpException("404");
      } else{
        throw Exception();
      }
    } on SocketException{
      throw Exception();
    }
  }

  Future<List<Products>> searchProducts(String productName) async {

    await getAccessTokens().then((value) {
      accessToken = value;
    });

    var headersList = {
      'Accept': '*/*',
      'Api-Key': apiKey,
      'Authorization': 'Bearer $accessToken'
    };
    var url = Uri.parse('$baseUrl/products?search={"productName" : "$productName"}&select=["productName","price","viewCount","mainImage", "commission", "categories", "featured", "published", "topSeller"]&limit=50');

    try {
      var res = await http.get(url, headers: headersList);
      final resBody = res.body;

      var data = json.decode(resBody);
      List content = json.decode(resBody);

      if (res.statusCode >= 200 && res.statusCode < 300) {
        final List<Products> products =
        content.map((product) => Products.fromJson(product)).toList();
        return products;
      } else if (data["message"] == "Not_Authorized") {
        print("ON 401 : $data");
        await getNewAccessToken();
        return await searchProducts(productName);
      } else if(res.statusCode == 429){
        print("Too many requests");
        throw Exception();
      }
      else {
        print(data);
        throw Exception();
      }
    } on SocketException {
      throw Exception();
    }
  }

  Future<List<Products>> filterProductsByCategory(String categoryName, int skipNumber) async {

    await getAccessTokens().then((value) {
      accessToken = value;
    });

    var headersList = {
      'Accept': '*/*',
      'Api-Key': apiKey,
      'Authorization': 'Bearer $accessToken'
    };
    var url = Uri.parse('$baseUrl/products?categories=["$categoryName"]&select=["productName","price","viewCount","mainImage", "commission", "categories", "featured", "published", "topSeller"]&limit=$limit&skip=$skipNumber');

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
        return await filterProductsByCategory(categoryName, skipNumber);
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

  Future postCategories(Categories category) async {

    await getAccessTokens().then((value) {
      accessToken = value;
    });

    var headersList = {
      'Accept': '*/*',
      'Api-Key': apiKey,
      'Authorization': 'Bearer $accessToken',
      'Content-Type': 'application/json'
    };
    var url = Uri.parse('$baseUrl/product-categories');

    var body = {"categoryName": category.categoryName};

    try {
      var res =
          await http.post(url, headers: headersList, body: json.encode(body));
      final resBody = res.body;

      var data = json.decode(resBody);

      if (res.statusCode >= 200 && res.statusCode < 300) {
        print(data);
      } else if (data["message"] == "Not_Authorized") {
        print("ON 401 : $data");
        await getNewAccessToken();
        return await postCategories(category);
      } else if (data["message"] == "Category_Name_Already_Exist") {
        print(data);
        throw const HttpException("404");
      } else {
        print(data);
        throw Exception();
      }
    } on SocketException {
      throw Exception();
    }
  }

  Future<List<Categories>> getCategories() async {

    await getAccessTokens().then((value) {
      accessToken = value;
    });

    var headersList = {
      'Accept': '*/*',
      'Api-Key': apiKey,
      'Authorization': 'Bearer $accessToken'
    };
    var url = Uri.parse('$baseUrl/product-categories');

    try {
      var res = await http.get(url, headers: headersList);
      final resBody = res.body;

      final List content = json.decode(resBody);
      var data = json.decode(resBody);

      if (res.statusCode >= 200 && res.statusCode < 300) {
        print(data);

        final List<Categories> categories =
            content.map((category) => Categories.fromJson(category)).toList();

        return categories;
      } else if (data["message"] == "Not_Authorized") {
        print("ON 401 : $data");
        await getNewAccessToken();
        return await getCategories();
      } else {
        print(data);
        throw Exception();
      }
    } on SocketException {
      throw Exception();
    }
  }

  Future editCategoryName(String? categoryId, String categoryName) async {

    await getAccessTokens().then((value) {
      accessToken = value;
    });

    var headersList = {
      'Accept': '*/*',
      'Api-Key': apiKey,
      'Authorization': 'Bearer $accessToken',
      'Content-Type': 'application/json'
    };
    var url = Uri.parse('$baseUrl/product-categories/$categoryId');

    var body = {"categoryName": categoryName};

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
        return await editCategoryName(categoryId, categoryName);
      } else if (data["message"] == "Category_Name_Already_Exist") {
        print(data);
        throw const HttpException("404");
      } else {
        print(data);
        throw Exception("api");
      }
    } on SocketException {
      throw Exception("network");
    }
  }

  Future deleteCategory(String? categoryId) async {

    await getAccessTokens().then((value) {
      accessToken = value;
    });

    var headersList = {
      'Accept': '*/*',
      'Api-Key': apiKey,
      'Authorization': 'Bearer $accessToken'
    };
    var url = Uri.parse('$baseUrl/product-categories/$categoryId');

    try {
      var res = await http.delete(url, headers: headersList);
      final resBody = res.body;

      var data = json.decode(resBody);

      if (res.statusCode >= 200 && res.statusCode < 300) {
        print(data);
      } else if (data["message"] == "Not_Authorized") {
        print("ON 401 : $data");
        await getNewAccessToken();
        return await deleteCategory(categoryId);
      } else {
        print(data);
        throw Exception();
      }
    } catch (e) {
      throw Exception();
    }
  }
}
