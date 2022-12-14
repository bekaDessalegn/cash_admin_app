import 'dart:io';

import 'package:cash_admin_app/features/affiliate/data/repositories/affiliates_repository.dart';
import 'package:cash_admin_app/features/affiliate/presentation/blocs/affiliates_event.dart';
import 'package:cash_admin_app/features/affiliate/presentation/blocs/affiliates_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AffiliatesBloc extends Bloc<AffiliatesEvent, AffiliatesState> {
  AffiliatesRepository affiliatesRepository;
  AffiliatesBloc(this.affiliatesRepository) : super(InitialAffiliatesState()){
    on<GetAffiliatesEvent>(_onGetAffiliatesEvent);
    on<GetMoreAffiliatesEvent>(_onGetMoreAffiliatesEvent);
    on<GetAffiliatesEarningFromLowToHighEvent>(_onGetAffiliatesEarningFromLowToHighEvent);
    on<GetMoreAffiliatesEarningFromLowToHighEvent>(_onGetMoreAffiliatesEarningFromLowToHighEvent);
    on<GetAffiliatesEarningFromHighToLowEvent>(_onGetAffiliatesEarningFromHighToLowEvent);
    on<GetMoreAffiliatesEarningFromHighToLowEvent>(_onGetMoreAffiliatesEarningFromHighToLowEvent);
    on<GetMostParentAffiliateEvent>(_onGetMostParentAffiliateEvent);
    on<GetMoreMostParentAffiliateEvent>(_onGetMoreMostParentAffiliateEvent);
  }

  void _onGetAffiliatesEvent(GetAffiliatesEvent event, Emitter emit) async {
    emit(GetAffiliatesLoadingState());
    try{
      final affiliates = await affiliatesRepository.getAffiliates(event.skipNumber);
      emit(GetAffiliatesSuccessfulState(affiliates));
    } catch(e){
      emit(GetAffiliatesFailedState("Something went wrong"));
    }
  }

  void _onGetMoreAffiliatesEvent(GetMoreAffiliatesEvent event, Emitter emit) async {
    try{
      final affiliates = await affiliatesRepository.getAffiliates(event.skipNumber);
      emit(GetAffiliatesSuccessfulState(affiliates));
    } catch(e){
      emit(GetAffiliatesFailedState("Something went wrong"));
    }
  }

  void _onGetAffiliatesEarningFromLowToHighEvent(GetAffiliatesEarningFromLowToHighEvent event, Emitter emit) async {
    emit(GetAffiliatesLoadingState());
    try{
      final affiliates = await affiliatesRepository.getAffiliatesFromLowToHigh(event.skipNumber);
      emit(GetAffiliatesSuccessfulState(affiliates));
    } catch(e){
      emit(GetAffiliatesFailedState("Something went wrong"));
    }
  }

  void _onGetMoreAffiliatesEarningFromLowToHighEvent(GetMoreAffiliatesEarningFromLowToHighEvent event, Emitter emit) async {
    try{
      final affiliates = await affiliatesRepository.getAffiliatesFromLowToHigh(event.skipNumber);
      emit(GetAffiliatesSuccessfulState(affiliates));
    } catch(e){
      emit(GetAffiliatesFailedState("Something went wrong"));
    }
  }

  void _onGetAffiliatesEarningFromHighToLowEvent(GetAffiliatesEarningFromHighToLowEvent event, Emitter emit) async {
    emit(GetAffiliatesLoadingState());
    try{
      final affiliates = await affiliatesRepository.getAffiliatesFromHighToLow(event.skipNumber);
      emit(GetAffiliatesSuccessfulState(affiliates));
    } catch(e){
      emit(GetAffiliatesFailedState("Something went wrong"));
    }
  }

  void _onGetMoreAffiliatesEarningFromHighToLowEvent(GetMoreAffiliatesEarningFromHighToLowEvent event, Emitter emit) async {
    try{
      final affiliates = await affiliatesRepository.getAffiliatesFromHighToLow(event.skipNumber);
      emit(GetAffiliatesSuccessfulState(affiliates));
    } catch(e){
      emit(GetAffiliatesFailedState("Something went wrong"));
    }
  }

  void _onGetMostParentAffiliateEvent(GetMostParentAffiliateEvent event, Emitter emit) async {
    emit(GetAffiliatesLoadingState());
    try{
      final affiliates = await affiliatesRepository.getMostParentAffiliate(event.skipNumber);
      emit(GetAffiliatesSuccessfulState(affiliates));
    } catch(e){
      emit(GetAffiliatesFailedState("Something went wrong"));
    }
  }

  void _onGetMoreMostParentAffiliateEvent(GetMoreMostParentAffiliateEvent event, Emitter emit) async {
    try{
      final affiliates = await affiliatesRepository.getMostParentAffiliate(event.skipNumber);
      emit(GetAffiliatesSuccessfulState(affiliates));
    } catch(e){
      emit(GetAffiliatesFailedState("Something went wrong"));
    }
  }

}

class SingleAffiliateBloc extends Bloc<SingleAffiliateEvent, SingleAffiliateState> {
  AffiliatesRepository affiliatesRepository;
  SingleAffiliateBloc(this.affiliatesRepository) : super(InitialSingleAffiliateState()){
    on<GetSingleAffiliateEvent>(_onGetSingleAffiliateEvent);
  }

  void _onGetSingleAffiliateEvent(GetSingleAffiliateEvent event, Emitter emit) async {
    emit(GetSingleAffiliateLoadingState());
    try{
      final affiliate = await affiliatesRepository.getAffiliate(event.userId);
      emit(GetSingleAffiliateSuccessfulState(affiliate));
    } catch(e){
      emit(GetSingleAffiliateFailedState("Something went wrong"));
    }
  }
}

class ChildrenBloc extends Bloc<ChildrenEvent, ChildrenState> {
  AffiliatesRepository affiliatesRepository;
  ChildrenBloc(this.affiliatesRepository) : super(InitialChildrenState()){
    on<GetChildrenEvent>(_onGetChildrenEvent);
  }

  void _onGetChildrenEvent(GetChildrenEvent event, Emitter emit) async {
    emit(GetChildrenLoadingState());
    try{
      final children = await affiliatesRepository.getChildren(event.userId);
      emit(GetChildrenSuccessfulState(children));
    } catch(e){
      emit(GetChildrenFailedState("Something went wrong"));
    }
  }
}

class SearchAffiliateBloc extends Bloc<SearchEvent, SearchState>{
  AffiliatesRepository affiliatesRepository;
  SearchAffiliateBloc(this.affiliatesRepository) : super(InitialSearchAffiliateState()){
    on<SearchAffiliatesEvent>(_onSearchAffiliateEvent);
  }

  void _onSearchAffiliateEvent(SearchAffiliatesEvent event, Emitter emit) async {
    emit(SearchAffiliateLoading());
    try {
      final affiliates = await affiliatesRepository.searchAffiliates(event.fullName);
      emit(SearchAffiliateSuccessful(affiliates));
    } on SocketException{
      emit(SearchAffiliateFailed("Something went wrong please, try again"));
    } on Exception{
      emit(SearchAffiliateFailed("Something went wrong please, try again"));
    }
  }

}

class ParentAffiliateBloc extends Bloc<ParentAffiliateEvent, ParentAffiliateState> {
  AffiliatesRepository affiliatesRepository;
  ParentAffiliateBloc(this.affiliatesRepository) : super(InitialParentAffiliateState()){
    on<GetParentAffiliateEvent>(_onGetParentAffiliateEvent);
    on<StartGetParentAffiliateEvent>(_onStartGetParentAffiliateEvent);
  }

  void _onGetParentAffiliateEvent(GetParentAffiliateEvent event, Emitter emit) async {
    emit(GetParentAffiliateLoadingState());
    try{
      final affiliate = await affiliatesRepository.getParentAffiliate(event.parentId);
      emit(GetParentAffiliateSuccessfulState(affiliate));
    } catch(e){
      emit(GetParentAffiliateFailedState("Something went wrong"));
    }
  }

  void _onStartGetParentAffiliateEvent(StartGetParentAffiliateEvent event, Emitter emit) async {
    emit(GetParentAffiliateLoadingState());
  }

}