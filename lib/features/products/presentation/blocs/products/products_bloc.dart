import 'dart:io';

import 'package:cash_admin_app/features/products/data/repositories/products_repositories.dart';
import 'package:cash_admin_app/features/products/presentation/blocs/products/products_event.dart';
import 'package:cash_admin_app/features/products/presentation/blocs/products/products_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductsBloc extends Bloc<ProductsEvent, ProductsState> {
  ProductsRepository productsRepository;
  ProductsBloc(this.productsRepository) : super(InitialProductsState()){
    on<PostProductsEvent>(_onPostProductsEvent);
    on<GetProductsEvent>(_onGetProductsEvent);
    on<GetProductsForListEvent>(_onGetProductsForListEvent);
    on<GetMoreProductsForListEvent>(_onGetMoreProductsForListEvent);
    // on<GetProductEvent>(_onGetProductEvent);
    on<PatchProductEvent>(_onPatchProductEvent);
    on<SearchProductsEvent>(_onSearchProductsEvent);
    on<FilterProductsByCategoryEvent>(_onFilterProductsByCategoryEvent);
    on<FilterMoreProductsByCategoryEvent>(_onFilterMoreProductsByCategoryEvent);
  }

  void _onPostProductsEvent(PostProductsEvent event, Emitter emit) async {
    emit(PostProductsLoading());
    try {
      await productsRepository.postProducts(event.products, event.imageType, event.listImageType);
      emit(PostProductsSuccessful());
    } on HttpException{
      emit(PostProductsFailed("Product name already exists"));
    } on SocketException{
      emit(PostProductsFailed("Something went wrong please, try again"));
    } on Exception{
      emit(PostProductsFailed("Something went wrong please, try again"));
    }
  }

  void _onGetProductsEvent(GetProductsEvent event, Emitter emit) async {
    emit(GetProductsLoading());
    try {
      final products = await productsRepository.getProducts();
      emit(GetProductsSuccessful(products));
    } on SocketException{
      emit(GetProductsFailed("Something went wrong please, try again"));
    } on Exception{
      emit(GetProductsFailed("Something went wrong please, try again"));
    }
  }

  void _onGetProductsForListEvent(GetProductsForListEvent event, Emitter emit) async {
    emit(GetProductsLoading());
    try {
      final products = await productsRepository.getProductsForList(event.skipNumber);
      emit(GetProductsSuccessful(products));
    } on SocketException{
      emit(GetProductsFailed("Something went wrong please, try again"));
    } on Exception{
      emit(GetProductsFailed("Something went wrong please, try again"));
    }
  }

  void _onGetMoreProductsForListEvent(GetMoreProductsForListEvent event, Emitter emit) async {
    try {
      final products = await productsRepository.getProductsForList(event.skipNumber);
      emit(GetProductsSuccessful(products));
    } on SocketException{
      emit(GetProductsFailed("Something went wrong please, try again"));
    } on Exception{
      emit(GetProductsFailed("Something went wrong please, try again"));
    }
  }

  // void _onGetProductEvent(GetProductEvent event, Emitter emit) async {
  //   emit(GetProductsLoading());
  //   await layed(Duration(seconds: 2));
  //   try {
  //     final product = await productsRepository.getProduct(event.productId);
  //     emit(GetProductSuccessful(product));
  //   } on SocketException{
  //     emit(GetProductsFailed("Something went wrong please, try again"));
  //   } on Exception{
  //     emit(GetProductsFailed("Something went wrong please, try again"));
  //   }
  // }

  void _onPatchProductEvent(PatchProductEvent event, Emitter emit) async {
    emit(PostProductsLoading());
    try {
      await productsRepository.editProduct(event.product, event.imageType, event.listImageType);
      emit(PostProductsSuccessful());
    } on HttpException{
      emit(PostProductsFailed("Product name already exists"));
    } on SocketException{
      emit(PostProductsFailed("Something went wrong please, try again"));
    } on Exception{
      emit(PostProductsFailed("Something went wrong please, try again"));
    }
  }

  void _onSearchProductsEvent(SearchProductsEvent event, Emitter emit) async {
    emit(GetProductsLoading());
    try {
      final products = await productsRepository.searchProducts(event.productName);
      emit(GetProductsSuccessful(products));
    } on SocketException{
      emit(GetProductsFailed("Something went wrong please, try again"));
    } on Exception{
      emit(GetProductsFailed("Something went wrong please, try again"));
    }
  }

  void _onFilterProductsByCategoryEvent(FilterProductsByCategoryEvent event, Emitter emit) async {
    emit(GetProductsLoading());
    try {
      final products = await productsRepository.filterProductsByCategory(event.categoryName, event.skipNumber);
      emit(GetProductsSuccessful(products));
    } on SocketException{
      emit(GetProductsFailed("Something went wrong please, try again"));
    } on Exception{
      emit(GetProductsFailed("Something went wrong please, try again"));
    }
  }

  void _onFilterMoreProductsByCategoryEvent(FilterMoreProductsByCategoryEvent event, Emitter emit) async {
    try {
      final products = await productsRepository.filterProductsByCategory(event.categoryName, event.skipNumber);
      emit(GetProductsSuccessful(products));
    } on SocketException{
      emit(GetProductsFailed("Something went wrong please, try again"));
    } on Exception{
      emit(GetProductsFailed("Something went wrong please, try again"));
    }
  }

}

class SearchProductBloc extends Bloc<SearchEvent, SearchState>{
  ProductsRepository productsRepository;
  SearchProductBloc(this.productsRepository) : super(InitialSearchProductState()){
    on<SearchProductEvent>(_onSearchProductEvent);
  }

  void _onSearchProductEvent(SearchProductEvent event, Emitter emit) async {
    emit(SearchProductLoading());
    try {
      final products = await productsRepository.searchProducts(event.productName);
      emit(SearchProductSuccessful(products));
    } on SocketException{
      emit(SearchProductFailed("Something went wrong please, try again"));
    } on Exception{
      emit(SearchProductFailed("Something went wrong please, try again"));
    }
  }

}

class DeleteProductBloc extends Bloc<DeleteEvent, DeleteProductState>{
  ProductsRepository productsRepository;
  DeleteProductBloc(this.productsRepository) : super(InitialDeleteState()){
    on<DeleteProductEvent>(_onDeleteProductEvent);
  }

  void _onDeleteProductEvent(DeleteProductEvent event, Emitter emit) async {
    emit(DeleteProductLoading());
    try {
      await productsRepository.deleteProduct(event.productId);
      emit(DeleteProductSuccessful());
    } on HttpException{
      emit(DeleteProductFailed("You can not delete this product, it has orders"));
    } on SocketException{
      emit(DeleteProductFailed("Something went wrong please, try again"));
    } on Exception{
      emit(DeleteProductFailed("Something went wrong please, try again"));
    }
  }

}