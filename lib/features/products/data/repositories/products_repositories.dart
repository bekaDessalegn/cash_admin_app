import 'dart:io';

import 'package:cash_admin_app/features/products/data/datasources/remote/products_datasource.dart';
import 'package:cash_admin_app/features/products/data/models/categories.dart';
import 'package:cash_admin_app/features/products/data/models/products.dart';

class ProductsRepository{
  ProductsDataSource productsDataSource;
  ProductsRepository(this.productsDataSource);

  Future postProducts(Products products, List imageType, List listImageType) async{
    try{
      await productsDataSource.postProducts(products, imageType, listImageType);
    } on HttpException {
      throw const HttpException("404");
    } on SocketException {
      throw SocketException("No Internet");
    } on Exception {
      throw Exception();
    }
  }

  Future<List<Products>> getProducts() async{
    try{
      final products = await productsDataSource.getProducts();
      return products;
    } on SocketException {
      throw SocketException("No Internet");
    } on Exception {
      throw Exception();
    }
  }

  Future getProductsForList(int skipNumber) async{
    try{
      final products = await productsDataSource.getProductsForList(skipNumber);
      return products;
    } on SocketException {
      throw SocketException("No Internet");
    } on Exception {
      throw Exception();
    }
  }

  Future<List<Products>> searchProducts(String productName) async{
    try{
      final products = await productsDataSource.searchProducts(productName);
      return products;
    } on SocketException {
      throw SocketException("No Internet");
    } catch(e) {
      throw Exception();
    }
  }

  Future<List<Products>> filterProductsByCategory(String categoryName, int skipNumber) async{
    try{
      final products = await productsDataSource.filterProductsByCategory(categoryName, skipNumber);
      return products;
    } on SocketException {
      throw SocketException("No Internet");
    } catch(e) {
      throw Exception();
    }
  }

  Future<Products> getProduct(String? productId) async {
    try{
      final product = await productsDataSource.getProduct(productId);
      return product;
    } on SocketException {
      throw SocketException("No Internet");
    } on Exception {
      throw Exception();
    }
  }

  Future editProduct(Products product, List imageType, List listImageType) async{
    try{
      await productsDataSource.editProduct(product, imageType, listImageType);
    } on HttpException {
      throw const HttpException("404");
    } on SocketException {
      throw SocketException("No Internet");
    } on Exception {
      throw Exception();
    }
  }

  Future deleteProduct(String? productId) async {
    try{
      await productsDataSource.deleteProduct(productId);
    } on HttpException {
      print("http");
      throw const HttpException("404");
    } on SocketException {
      print("stf");
      throw SocketException("No Internet");
    } on Exception {
      throw Exception();
    }
  }

  Future postCategories(Categories category) async{
    try{
      await productsDataSource.postCategories(category);
    } on HttpException {
      print("http");
      throw const HttpException("404");
    } on SocketException {
      throw SocketException("No Internet");
    } on Exception {
      throw Exception();
    }
  }

  Future<List<Categories>> getCategories() async{
    try{
      final categories = await productsDataSource.getCategories();
      return categories;
    } on SocketException {
      throw SocketException("No Internet");
    } on Exception {
      throw Exception();
    }
  }

  Future editCategoryName(String? categoryId, String categoryName) async {
    try{
      await productsDataSource.editCategoryName(categoryId, categoryName);
    } on HttpException {
      throw const HttpException("404");
    } on SocketException {
      throw SocketException("No Internet");
    } on Exception {
      throw Exception();
    }
  }

  Future deleteCategory(String? categoryId) async {
    try{
      await productsDataSource.deleteCategory(categoryId);
    } catch(e){
      throw Exception();
    }
  }
}