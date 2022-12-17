import 'package:cash_admin_app/features/affiliate/data/datasources/remote/transactions_datasource.dart';
import 'package:cash_admin_app/features/affiliate/data/models/transactions.dart';

class TransactionsRepository {
  TransactionsDataSource transactionsDataSource;
  TransactionsRepository(this.transactionsDataSource);

  Future<List<Transactions>> getTransactions() async {
    try {
      print("On the way to get transactions");
      final transactions = await transactionsDataSource.getTransactions();
      return transactions;
    } catch(e){
      print(e);
      throw Exception();
    }
  }

  Future<Transactions> getTransaction(String transactionId) async {
    try{
      final transaction = await transactionsDataSource.getTransaction(transactionId);
      return transaction;
    } catch(e){
      print(e);
      throw Exception();
    }
  }

  Future<List<Transactions>> getAffiliateTransactions(String userId, int skipNumber) async {
    try {
      print("On the way to get transactions");
      final transactions = await transactionsDataSource.getAffiliateTransactions(userId, skipNumber);
      return transactions;
    } catch(e){
      print(e);
      throw Exception();
    }
  }
}