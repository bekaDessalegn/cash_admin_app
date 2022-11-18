import 'package:cash_admin_app/features/products/data/models/products.dart';

abstract class SingleProductState {}

class InitialGetProductState extends SingleProductState {}

class GetSingleProductSuccessful extends SingleProductState {
  final Products product;
  GetSingleProductSuccessful(this.product);
}

class GetSingleProductFailed extends SingleProductState {
  final String errorType;
  GetSingleProductFailed(this.errorType);
}

class GetSingleProductLoading extends SingleProductState {}

class DeletedProductState extends SingleProductState {}