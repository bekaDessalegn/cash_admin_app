import 'package:cash_admin_app/features/products/data/models/categories.dart';

abstract class PostCategoriesState {}

class InitialPostCategoriesState extends PostCategoriesState {}

class PostCategoriesSuccessful extends PostCategoriesState {}

class PostCategoriesLoading extends PostCategoriesState {}

class PostCategoriesFailed extends PostCategoriesState {
  final String errorType;
  PostCategoriesFailed(this.errorType);
}

class PatchCategoriesSuccessful extends PostCategoriesState {}

class PatchCategoriesLoading extends PostCategoriesState {}

class PatchCategoriesFailed extends PostCategoriesState {
  final String errorType;
  PatchCategoriesFailed(this.errorType);
}