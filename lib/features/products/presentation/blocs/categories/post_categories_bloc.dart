import 'dart:io';

import 'package:cash_admin_app/features/products/data/repositories/products_repositories.dart';
import 'package:cash_admin_app/features/products/presentation/blocs/categories/post_categories_event.dart';
import 'package:cash_admin_app/features/products/presentation/blocs/categories/post_categories_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PostCategoriesBloc extends Bloc<PushCategoriesEvent, PostCategoriesState> {
  ProductsRepository productsRepository;
  PostCategoriesBloc(this.productsRepository) : super(InitialPostCategoriesState()){
    on<PostCategoriesEvent>(_onPostCategoriesEvent);
    on<PatchCategoryEvent>(_onPatchCategoryEvent);
  }

  void _onPostCategoriesEvent(PostCategoriesEvent event, Emitter emit) async {
    emit(PostCategoriesLoading());
    try {
      await productsRepository.postCategories(event.category);
      emit(PostCategoriesSuccessful());
    } on HttpException{
      emit(PostCategoriesFailed("Category name already exists"));
    } on SocketException{
      emit(PostCategoriesFailed("Something went wrong please, try again"));
    } on Exception{
      emit(PostCategoriesFailed("Something went wrong please, try again"));
    }
  }

  void _onPatchCategoryEvent(PatchCategoryEvent event, Emitter emit) async {
    emit(PatchCategoriesLoading());
    try {
      await productsRepository.editCategoryName(event.categoryId, event.categoryName);
      emit(PatchCategoriesSuccessful());
    } on HttpException{
      emit(PatchCategoriesFailed("Category name already exists"));
    } on SocketException{
      emit(PatchCategoriesFailed("Something went wrong please, try again"));
    } on Exception{
      emit(PatchCategoriesFailed("Something went wrong please, try again"));
    }
  }
}