import 'package:cash_admin_app/features/products/data/models/categories.dart';

abstract class CategoriesEvent {}

class GetCategoriesEvent extends CategoriesEvent {}

class DeleteCategoryEvent extends CategoriesEvent {
  final String? categoryId;
  DeleteCategoryEvent(this.categoryId);
}