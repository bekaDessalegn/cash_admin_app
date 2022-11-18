abstract class SingleProductEvent {}

class GetSingleProductEvent extends SingleProductEvent {
  String productId;
  GetSingleProductEvent(this.productId);
}

class DeleteSingleProductEvent extends SingleProductEvent {}