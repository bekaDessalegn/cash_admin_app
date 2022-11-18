import 'package:cash_admin_app/features/affiliate/data/repositories/affiliate_transactions_repository.dart';
import 'package:cash_admin_app/features/affiliate/presentation/blocs/affiliate_transactions/transactions_event.dart';
import 'package:cash_admin_app/features/affiliate/presentation/blocs/affiliate_transactions/transactions_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TransactionsBloc extends Bloc<TransactionsEvent, TransactionsState> {
  TransactionsRepository transactionsRepository;
  TransactionsBloc(this.transactionsRepository) : super(InitialTransactionsState()) {
    on<GetTransactionsEvent>(_onGetTransactionsEvent);
  }

  void _onGetTransactionsEvent(GetTransactionsEvent event, Emitter emit) async {
    emit(GetTransactionsLoadingState());
    try{
      final transactions = await transactionsRepository.getTransactions();
      emit(GetTransactionsSuccessfulState(transactions));
    } catch(e){
      emit(GetTransactionsFailedState("Something went wrong"));
    }
  }

}

class SingleTransactionBloc extends Bloc<SingleTransactionEvent, SingleTransactionState> {
  TransactionsRepository transactionsRepository;
  SingleTransactionBloc(this.transactionsRepository) : super(InitialSingleTransactionState()) {
    on<GetSingleTransactionEvent>(_onGetSingleTransactionEvent);
  }

  void _onGetSingleTransactionEvent(GetSingleTransactionEvent event, Emitter emit) async {
    emit(GetSingleTransactionLoadingState());
    try{
      final transaction = await transactionsRepository.getTransaction(event.transactionId);
      emit(GetSingleTransactionSuccessfulState(transaction));
    } catch(e){
      emit(GetSingleTransactionFailedState("Something went wrong"));
    }
  }

}

class AffiliateTransactionsBloc extends Bloc<AffiliateTransactionsEvent, AffiliateTransactionsState> {
  TransactionsRepository transactionsRepository;
  AffiliateTransactionsBloc(this.transactionsRepository) : super(InitialAffiliateTransactionsState()) {
    on<GetAffiliateTransactionsEvent>(_onGetAffiliateTransactionsEvent);
    on<GetMoreAffiliateTransactionsEvent>(_onGetMoreAffiliateTransactionsEvent);
  }

  void _onGetAffiliateTransactionsEvent(GetAffiliateTransactionsEvent event, Emitter emit) async {
    emit(GetAffiliateTransactionsLoadingState());
    try{
      final transactions = await transactionsRepository.getAffiliateTransactions(event.userId, event.skipNumber);
      emit(GetAffiliateTransactionsSuccessfulState(transactions));
    } catch(e){
      emit(GetAffiliateTransactionsFailedState("Something went wrong"));
    }
  }

  void _onGetMoreAffiliateTransactionsEvent(GetMoreAffiliateTransactionsEvent event, Emitter emit) async {
    try{
      final transactions = await transactionsRepository.getAffiliateTransactions(event.userId, event.skipNumber);
      emit(GetAffiliateTransactionsSuccessfulState(transactions));
    } catch(e){
      emit(GetAffiliateTransactionsFailedState("Something went wrong"));
    }
  }

}