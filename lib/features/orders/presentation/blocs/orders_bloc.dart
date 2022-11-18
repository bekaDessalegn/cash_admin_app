import 'dart:io';

import 'package:cash_admin_app/features/orders/data/repositories/orders_repository.dart';
import 'package:cash_admin_app/features/orders/presentation/blocs/orders_event.dart';
import 'package:cash_admin_app/features/orders/presentation/blocs/orders_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OrdersBloc extends Bloc<OrdersEvent, OrdersState> {
  OrdersRepository ordersRepository;
  OrdersBloc(this.ordersRepository) : super(InitialOrdersState()){
    on<GetOrdersEvent>(_onGetOrdersEvent);
    on<GetMoreOrdersEvent>(_onGetMoreOrdersEvent);
  }

  void _onGetOrdersEvent(GetOrdersEvent event, Emitter emit) async {
    emit(GetOrdersLoadingState());
    try{
      final orders = await ordersRepository.getOrders(event.skipNumber);
      emit(GetOrdersSuccessfulState(orders));
    } catch(e){
      emit(GetOrdersFailedState("Something went wrong"));
    }
  }

  void _onGetMoreOrdersEvent(GetMoreOrdersEvent event, Emitter emit) async {
    try{
      final orders = await ordersRepository.getOrders(event.skipNumber);
      emit(GetOrdersSuccessfulState(orders));
    } catch(e){
      emit(GetOrdersFailedState("Something went wrong"));
    }
  }

}

class SingleOrderBloc extends Bloc<SingleOrderEvent, SingleOrderState>{
  OrdersRepository ordersRepository;
  SingleOrderBloc(this.ordersRepository) : super(InitialGetOrderState()){
    on<GetSingleOrderEvent>(_onGetSingleOrderEvent);
  }

  void _onGetSingleOrderEvent(GetSingleOrderEvent event, Emitter emit) async {
    emit(GetSingleOrderLoading());
    try {
      final order = await ordersRepository.getSingleOrder(event.orderId);
      emit(GetSingleOrderSuccessful(order));
    } on SocketException{
      emit(GetSingleOrderFailed("Something went wrong please, try again"));
    } on Exception{
      emit(GetSingleOrderFailed("Something went wrong please, try again"));
    }
  }

}

class PatchOrderBloc extends Bloc<PatchOrderEvent, PatchOrderState> {
  OrdersRepository ordersRepository;
  PatchOrderBloc(this.ordersRepository) : super(InitialPatchOrderState()){
    on<AcceptOrderEvent>(_onAcceptOrderEvent);
    on<RejectOrderEvent>(_onRejectOrderEvent);
  }

  void _onAcceptOrderEvent(AcceptOrderEvent event, Emitter emit) async {
    emit(AcceptOrderStateLoading());
    try{
      await ordersRepository.acceptOrder(event.orderId);
      emit(PatchOrderStateSuccessful());
    } catch(e){
      emit(PatchOrderStateFailed("Something went wrong"));
    }
  }

  void _onRejectOrderEvent(RejectOrderEvent event, Emitter emit) async {
    emit(RejectOrderStateLoading());
    try{
      await ordersRepository.rejectOrder(event.orderId);
      emit(PatchOrderStateSuccessful());
    } catch(e){
      emit(PatchOrderStateFailed("Something went wrong"));
    }
  }
}

class DeleteOrderBloc extends Bloc<DeleteOrderEvent, DeleteOrderState>{
  OrdersRepository ordersRepository;
  DeleteOrderBloc(this.ordersRepository) : super(InitialDeleteOrderState()){
    on<DeleteSingleOrderEvent>(_onDeleteSingleOrderEvent);
  }

  void _onDeleteSingleOrderEvent(DeleteSingleOrderEvent event, Emitter emit) async{
    emit(DeleteOrderLoadingState());
    try{
      await ordersRepository.deleteOrder(event.orderId);
      emit(DeleteOrderSuccessfulState());
    } catch(e){
      emit(DeleteOrderFailedState("Something went wrong"));
    }
  }

}

class SearchOrderBloc extends Bloc<SearchEvent, SearchState>{
  OrdersRepository ordersRepository;
  SearchOrderBloc(this.ordersRepository) : super(InitialSearchOrderState()){
    on<SearchOrdersEvent>(_onSearchOrderEvent);
  }

  void _onSearchOrderEvent(SearchOrdersEvent event, Emitter emit) async {
    emit(SearchOrderLoading());
    try {
      final orders = await ordersRepository.searchOrders(event.fullName, event.companyName);
      emit(SearchOrderSuccessful(orders));
    } on SocketException{
      emit(SearchOrderFailed("Something went wrong please, try again"));
    } on Exception{
      emit(SearchOrderFailed("Something went wrong please, try again"));
    }
  }

}