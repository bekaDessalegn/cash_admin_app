import 'package:cash_admin_app/features/affiliate/data/models/transactions.dart';

abstract class TransactionsState {}

class InitialTransactionsState extends TransactionsState {}

class GetTransactionsSuccessfulState extends TransactionsState {
  final List<Transactions> transactions;
  GetTransactionsSuccessfulState(this.transactions);
}

class GetTransactionsLoadingState extends TransactionsState {}

class GetTransactionsFailedState extends TransactionsState {
  final String errorType;
  GetTransactionsFailedState(this.errorType);
}

abstract class SingleTransactionState {}

class InitialSingleTransactionState extends SingleTransactionState {}

class GetSingleTransactionSuccessfulState extends SingleTransactionState {
  final Transactions transaction;
  GetSingleTransactionSuccessfulState(this.transaction);
}

class GetSingleTransactionLoadingState extends SingleTransactionState {}

class GetSingleTransactionFailedState extends SingleTransactionState {
  final String errorType;
  GetSingleTransactionFailedState(this.errorType);
}

abstract class AffiliateTransactionsState {}

class InitialAffiliateTransactionsState extends AffiliateTransactionsState {}

class GetAffiliateTransactionsSuccessfulState extends AffiliateTransactionsState {
  final List<Transactions> transactions;
  GetAffiliateTransactionsSuccessfulState(this.transactions);
}

class GetAffiliateTransactionsLoadingState extends AffiliateTransactionsState {}

class GetAffiliateTransactionsFailedState extends AffiliateTransactionsState {
  final String errorType;
  GetAffiliateTransactionsFailedState(this.errorType);
}