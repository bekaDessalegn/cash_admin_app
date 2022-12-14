abstract class OrdersEvent {}

class GetOrdersEvent extends OrdersEvent {
  int skipNumber;
  GetOrdersEvent(this.skipNumber);
}

class GetMoreOrdersEvent extends OrdersEvent {
  int skipNumber;
  GetMoreOrdersEvent(this.skipNumber);
}

class FilterPendingEvent extends OrdersEvent {
  int skipNumber;
  FilterPendingEvent(this.skipNumber);
}

class MoreFilterPendingEvent extends OrdersEvent {
  int skipNumber;
  MoreFilterPendingEvent(this.skipNumber);
}

class FilterAcceptedEvent extends OrdersEvent {
  int skipNumber;
  FilterAcceptedEvent(this.skipNumber);
}

class MoreFilterAcceptedEvent extends OrdersEvent {
  int skipNumber;
  MoreFilterAcceptedEvent(this.skipNumber);
}

class FilterRejectedEvent extends OrdersEvent {
  int skipNumber;
  FilterRejectedEvent(this.skipNumber);
}

class MoreFilterRejectedEvent extends OrdersEvent {
  int skipNumber;
  MoreFilterRejectedEvent(this.skipNumber);
}

abstract class SingleOrderEvent {}

class GetSingleOrderEvent extends SingleOrderEvent {
  String orderId;
  GetSingleOrderEvent(this.orderId);
}

class DeletedOrderEvent extends SingleOrderEvent {}

class GetAnsweredSingleOrderEvent extends SingleOrderEvent {}

abstract class PatchOrderEvent {}

class AcceptOrderEvent extends PatchOrderEvent {
  String orderId;
  AcceptOrderEvent(this.orderId);
}

class RejectOrderEvent extends PatchOrderEvent {
  String orderId;
  RejectOrderEvent(this.orderId);
}

abstract class DeleteOrderEvent {}

class DeleteSingleOrderEvent extends DeleteOrderEvent {
  String orderId;
  DeleteSingleOrderEvent(this.orderId);
}

abstract class SearchEvent {}

class SearchOrdersEvent extends SearchEvent {
  String fullName;
  String companyName;
  SearchOrdersEvent(this.fullName, this.companyName);
}