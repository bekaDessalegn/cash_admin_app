import 'package:cash_admin_app/features/products/data/models/categories.dart';

abstract class PushCategoriesEvent {}

class PostCategoriesEvent extends PushCategoriesEvent {
  Categories category;
  PostCategoriesEvent(this.category);
}

class PatchCategoryEvent extends PushCategoriesEvent{
  final String? categoryId;
  final String categoryName;
  PatchCategoryEvent(this.categoryId, this.categoryName);
}