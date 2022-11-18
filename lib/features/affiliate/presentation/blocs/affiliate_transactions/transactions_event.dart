abstract class TransactionsEvent {}

class GetTransactionsEvent extends TransactionsEvent {}

abstract class SingleTransactionEvent {}

class GetSingleTransactionEvent extends SingleTransactionEvent {
  String transactionId;
  GetSingleTransactionEvent(this.transactionId);
}

abstract class AffiliateTransactionsEvent {}

class GetAffiliateTransactionsEvent extends AffiliateTransactionsEvent {
  String userId;
  int skipNumber;
  GetAffiliateTransactionsEvent(this.userId, this.skipNumber);
}

class GetMoreAffiliateTransactionsEvent extends AffiliateTransactionsEvent {
  String userId;
  int skipNumber;
  GetMoreAffiliateTransactionsEvent(this.userId, this.skipNumber);
}