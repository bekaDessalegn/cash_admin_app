import 'package:cash_admin_app/features/products/data/models/local_products.dart';
import 'package:cash_admin_app/features/products/data/models/products.dart';

abstract class ProductsState {}

class InitialProductsState extends ProductsState {}

class PostProductsSuccessful extends ProductsState {}

class PostProductsLoading extends ProductsState {}

class PostProductsFailed extends ProductsState {
  final String errorType;
  PostProductsFailed(this.errorType);
}

class GetProductsSuccessful extends ProductsState {
  final List<Products> products;
  GetProductsSuccessful(this.products);
}

class GetProductsLoading extends ProductsState {}

class GetProductsFailed extends ProductsState {
  final String errorType;
  GetProductsFailed(this.errorType);
}

class SocketErrorState extends ProductsState {
  final List<LocalProducts> localProducts;
  SocketErrorState(this.localProducts);
}

abstract class SearchState {}

class InitialSearchProductState extends SearchState {}

class SearchProductSuccessful extends SearchState {
  final List<Products> product;
  SearchProductSuccessful(this.product);
}

class SearchProductFailed extends SearchState {
  final String errorType;
  SearchProductFailed(this.errorType);
}

class SearchProductLoading extends SearchState {}

class SearchProductSocketErrorState extends SearchState {
  final List<LocalProducts> localProducts;
  SearchProductSocketErrorState(this.localProducts);
}

// class GetProductSuccessful extends ProductsState {
//   final Products product;
//   GetProductSuccessful(this.product);
// }

abstract class DeleteProductState {}

class InitialDeleteState extends DeleteProductState {}

class DeleteProductSuccessful extends DeleteProductState {}

class DeleteProductLoading extends DeleteProductState {}

class DeleteProductFailed extends DeleteProductState {
  final String errorType;
  DeleteProductFailed(this.errorType);
}