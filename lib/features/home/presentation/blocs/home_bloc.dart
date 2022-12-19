import 'dart:io';

import 'package:cash_admin_app/features/home/data/repositories/home_repository.dart';
import 'package:cash_admin_app/features/home/presentation/blocs/home_event.dart';
import 'package:cash_admin_app/features/home/presentation/blocs/home_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FilterFeaturedBloc extends Bloc<FilterFeaturedEvent, FilterFeaturedState> {
  HomeRepository homeRepository;
  FilterFeaturedBloc(this.homeRepository) : super(InitialFilterFeaturedState()){
    on<FilterFeaturedProductsEvent>(_onFilterFeaturedProductsEvent);
  }

  void _onFilterFeaturedProductsEvent(FilterFeaturedProductsEvent event, Emitter emit) async {
    emit(FilterFeaturedLoading());
    try {
      final products = await homeRepository.filterFeaturedProducts();
      if(products.runtimeType.toString() == "List<LocalProducts>"){
        emit(FilterFeaturedSocketErrorState(products));
      } else {
        emit(FilterFeaturedSuccessful(products));
      }
    } on SocketException{
      emit(FilterFeaturedFailed("Something went wrong please, try again"));
    } on Exception{
      emit(FilterFeaturedFailed("Something went wrong please, try again"));
    }
  }

}

class FilterTopSellerBloc extends Bloc<FilterTopSellerEvent, FilterTopSellerState> {
  HomeRepository homeRepository;
  FilterTopSellerBloc(this.homeRepository) : super(InitialFilterTopSellerState()){
    on<FilterTopSellerProductsEvent>(_onFilterTopSellerProductsEvent);
  }

  void _onFilterTopSellerProductsEvent(FilterTopSellerProductsEvent event, Emitter emit) async {
    emit(FilterTopSellerLoading());
    try {
      final products = await homeRepository.filterTopSellerProducts();
      if(products.runtimeType.toString() == "List<LocalProducts>"){
        emit(FilterTopSellerSocketErrorState(products));
      } else {
        emit(FilterTopSellerSuccessful(products));
      }
    } on SocketException{
      emit(FilterTopSellerFailed("Something went wrong please, try again"));
    } on Exception{
      emit(FilterTopSellerFailed("Something went wrong please, try again"));
    }
  }

}

class FilterUnAnsweredBloc extends Bloc<FilterUnAnsweredEvent, FilterUnAnsweredState> {
  HomeRepository homeRepository;
  FilterUnAnsweredBloc(this.homeRepository) : super(InitialFilterUnAnsweredState()){
    on<FilterUnAnsweredProductsEvent>(_onFilterUnAnsweredProductsEvent);
  }

  void _onFilterUnAnsweredProductsEvent(FilterUnAnsweredProductsEvent event, Emitter emit) async {
    emit(FilterUnAnsweredLoading());
    try {
      final orders = await homeRepository.filterUnAnsweredProducts();
      if(orders.runtimeType.toString() == "List<LocalOrder>"){
        emit(FilterUnAnsweredSocketErrorState(orders));
      } else {
        emit(FilterUnAnsweredSuccessful(orders));
      }
    } on SocketException{
      emit(FilterUnAnsweredFailed("Something went wrong please, try again"));
    } on Exception{
      emit(FilterUnAnsweredFailed("Something went wrong please, try again"));
    }
  }

}

class AnalyticsBloc extends Bloc<AnalyticsEvent, AnalyticsState> {
  HomeRepository homeRepository;
  AnalyticsBloc(this.homeRepository) : super(InitialGetAnalyticsState()){
    on<GetAnalyticsEvent>(_onGetAnalyticsEvent);
  }

  void _onGetAnalyticsEvent(GetAnalyticsEvent event, Emitter emit) async {
    emit(GetAnalyticsLoadingState());
    try{
      final analytics = await homeRepository.getAnalytics();
      emit(GetAnalyticsSuccessfulState(analytics));
    } catch(e) {
      emit(GetAnalyticsFailedState("Something went wrong"));
    }
  }
}

class StaticWebContentBloc extends Bloc<StaticWebContentEvent, StaticWebContentState> {
  HomeRepository homeRepository;
  StaticWebContentBloc(this.homeRepository) : super(InitialStaticWebContentState()){
    on<PutWhoAreWeWebContentEvent>(_onPutWhoAreWeWebContentEvent);
    on<PutHowToAffiliateWithUsWebContentEvent>(_onPutHowToAffiliateWithUsWebContentEvent);
  }

  void _onPutWhoAreWeWebContentEvent(PutWhoAreWeWebContentEvent event, Emitter emit) async {
    emit(PutWhoAreWeWebContentLoadingState());
    try{
      await homeRepository.putWhoAreWeWebContents(event.whoAreWe);
      emit(PutStaticWebContentSuccessfulState());
    } catch(e) {
      emit(PutStaticWebContentFailedState("Something went wrong, please try again"));
    }
  }

  void _onPutHowToAffiliateWithUsWebContentEvent(PutHowToAffiliateWithUsWebContentEvent event, Emitter emit) async {
    emit(PutHowToAffiliateWithUsWebContentLoadingState());
    try{
      await homeRepository.putHowToAffiliateWithUsWebContents(event.howToAffiliateWithUs);
      emit(PutStaticWebContentSuccessfulState());
    } catch(e) {
      emit(PutStaticWebContentFailedState("Something went wrong, please try again"));
    }
  }
}