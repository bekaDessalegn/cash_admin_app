import 'dart:io';

import 'package:cash_admin_app/features/products/data/repositories/products_repositories.dart';
import 'package:cash_admin_app/features/products/presentation/blocs/categories/categories_event.dart';
import 'package:cash_admin_app/features/products/presentation/blocs/categories/categories_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoriesBloc extends Bloc<CategoriesEvent, CategoriesState> {
  ProductsRepository productsRepository;
  CategoriesBloc(this.productsRepository) : super(InitialCategoriesState()){
    on<GetCategoriesEvent>(_onGetCategoriesEvent);
    on<DeleteCategoryEvent>(_onDeleteCategoryEvent);
  }

  void _onGetCategoriesEvent(GetCategoriesEvent event, Emitter emit) async {
    emit(GetCategoriesLoading());
    try {
      final categories = await productsRepository.getCategories();
      emit(GetCategoriesSuccessful(categories));
    } on SocketException{
      emit(GetCategoriesFailed("Something went wrong please, try again"));
    } on Exception{
      emit(GetCategoriesFailed("Something went wrong please, try again"));
    }
  }

  void _onDeleteCategoryEvent(DeleteCategoryEvent event, Emitter emit) async {
    emit(GetCategoriesLoading());
    try {
      await productsRepository.deleteCategory(event.categoryId);
      final categories = await productsRepository.getCategories();
      emit(GetCategoriesSuccessful(categories));
    } on SocketException{
      emit(GetCategoriesFailed("Something went wrong please, try again"));
    } on Exception{
      emit(GetCategoriesFailed("Something went wrong please, try again"));
    }
  }
}