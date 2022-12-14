import 'package:cash_admin_app/features/orders/data/models/orders.dart';

abstract class OrdersState {}

class InitialOrdersState extends OrdersState {}

class GetOrdersSuccessfulState extends OrdersState {
  final List<Orders> orders;
  GetOrdersSuccessfulState(this.orders);
}

class GetOrdersFailedState extends OrdersState {
  final String errorType;
  GetOrdersFailedState(this.errorType);
}

class GetOrdersLoadingState extends OrdersState {}

abstract class SingleOrderState {}

class InitialGetOrderState extends SingleOrderState {}

class GetSingleOrderSuccessful extends SingleOrderState {
  final Orders order;
  GetSingleOrderSuccessful(this.order);
}

class GetSingleOrderFailed extends SingleOrderState {
  final String errorType;
  GetSingleOrderFailed(this.errorType);
}

class DeletedOrderState extends SingleOrderState{}

class GetSingleOrderLoading extends SingleOrderState {}

abstract class PatchOrderState {}

class InitialPatchOrderState extends PatchOrderState {}

class PatchOrderStateSuccessful extends PatchOrderState {}

class PatchOrderStateFailed extends PatchOrderState {
  final String errorType;
  PatchOrderStateFailed(this.errorType);
}

class AcceptOrderStateLoading extends PatchOrderState {}

class RejectOrderStateLoading extends PatchOrderState {}

abstract class DeleteOrderState {}

class InitialDeleteOrderState extends DeleteOrderState {}

class DeleteOrderSuccessfulState extends DeleteOrderState{}

class DeleteOrderLoadingState extends DeleteOrderState {}

class DeleteOrderFailedState extends DeleteOrderState{
  String errorType;
  DeleteOrderFailedState(this.errorType);
}

abstract class SearchState {}

class InitialSearchOrderState extends SearchState {}

class SearchOrderSuccessful extends SearchState {
  final List<Orders> order;
  SearchOrderSuccessful(this.order);
}

class SearchOrderFailed extends SearchState {
  final String errorType;
  SearchOrderFailed(this.errorType);
}

class SearchOrderLoading extends SearchState {}