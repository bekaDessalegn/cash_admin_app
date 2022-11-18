import 'dart:io';

import 'package:cash_admin_app/features/products/data/repositories/products_repositories.dart';
import 'package:cash_admin_app/features/products/presentation/blocs/products/product_event.dart';
import 'package:cash_admin_app/features/products/presentation/blocs/products/product_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SingleProductBloc extends Bloc<SingleProductEvent, SingleProductState>{
  ProductsRepository productsRepository;
  SingleProductBloc(this.productsRepository) : super(InitialGetProductState()){
    on<GetSingleProductEvent>(_onGetSingleProductEvent);
    on<DeleteSingleProductEvent>(_onDeleteSingleProductEvent);
  }

  void _onGetSingleProductEvent(GetSingleProductEvent event, Emitter emit) async {
    emit(GetSingleProductLoading());
    try {
      final product = await productsRepository.getProduct(event.productId);
      emit(GetSingleProductSuccessful(product));
    } on SocketException{
      emit(GetSingleProductFailed("Something went wrong please, try again"));
    } on Exception{
      emit(GetSingleProductFailed("Something went wrong please, try again"));
    }
  }

  void _onDeleteSingleProductEvent(DeleteSingleProductEvent event, Emitter emit) async {
    emit(DeletedProductState());
  }

}