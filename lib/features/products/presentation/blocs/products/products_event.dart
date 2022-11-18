import 'package:cash_admin_app/features/products/data/models/products.dart';

abstract class ProductsEvent {}

class PostProductsEvent extends ProductsEvent {
  Products products;
  List imageType;
  List listImageType;
  PostProductsEvent(this.products, this.imageType, this.listImageType);
}

class GetProductsEvent extends ProductsEvent {}

class GetProductsForListEvent extends ProductsEvent {
  int skipNumber;
  GetProductsForListEvent(this.skipNumber);
}

class GetMoreProductsForListEvent extends ProductsEvent {
  int skipNumber;
  GetMoreProductsForListEvent(this.skipNumber);
}

class GetProductEvent extends ProductsEvent {
  String? productId;
  GetProductEvent(this.productId);
}

class PatchProductEvent extends ProductsEvent {
  Products product;
  List imageType;
  List listImageType;
  PatchProductEvent(this.product, this.imageType, this.listImageType);
}

class SearchProductsEvent extends ProductsEvent {
  String productName;
  SearchProductsEvent(this.productName);
}

class FilterProductsByCategoryEvent extends ProductsEvent {
  String categoryName;
  int skipNumber;
  FilterProductsByCategoryEvent(this.categoryName, this.skipNumber);
}

class FilterMoreProductsByCategoryEvent extends ProductsEvent {
  String categoryName;
  int skipNumber;
  FilterMoreProductsByCategoryEvent(this.categoryName, this.skipNumber);
}

abstract class SearchEvent {}

class SearchProductEvent extends SearchEvent {
  String productName;
  SearchProductEvent(this.productName);
}

abstract class DeleteEvent {}

class DeleteProductEvent extends DeleteEvent {
  String? productId;
  DeleteProductEvent(this.productId);
}

