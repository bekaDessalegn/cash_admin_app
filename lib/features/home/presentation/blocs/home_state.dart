import 'package:cash_admin_app/features/home/data/models/analytics.dart';
import 'package:cash_admin_app/features/home/data/models/video_links.dart';
import 'package:cash_admin_app/features/orders/data/models/orders.dart';
import 'package:cash_admin_app/features/products/data/models/products.dart';

abstract class FilterFeaturedState {}

class InitialFilterFeaturedState extends FilterFeaturedState {}

class FilterFeaturedSuccessful extends FilterFeaturedState {
  final List<Products> products;
  FilterFeaturedSuccessful(this.products);
}

class FilterFeaturedLoading extends FilterFeaturedState {}

class FilterFeaturedFailed extends FilterFeaturedState {
  final String errorType;
  FilterFeaturedFailed(this.errorType);
}

abstract class FilterTopSellerState {}

class InitialFilterTopSellerState extends FilterTopSellerState {}

class FilterTopSellerSuccessful extends FilterTopSellerState {
  final List<Products> products;
  FilterTopSellerSuccessful(this.products);
}

class FilterTopSellerLoading extends FilterTopSellerState {}

class FilterTopSellerFailed extends FilterTopSellerState {
  final String errorType;
  FilterTopSellerFailed(this.errorType);
}

abstract class FilterUnAnsweredState {}

class InitialFilterUnAnsweredState extends FilterUnAnsweredState {}

class FilterUnAnsweredSuccessful extends FilterUnAnsweredState {
  final List<Orders> orders;
  FilterUnAnsweredSuccessful(this.orders);
}

class FilterUnAnsweredLoading extends FilterUnAnsweredState {}

class FilterUnAnsweredFailed extends FilterUnAnsweredState {
  final String errorType;
  FilterUnAnsweredFailed(this.errorType);
}

abstract class AnalyticsState {}

class InitialGetAnalyticsState extends AnalyticsState {}

class GetAnalyticsSuccessfulState extends AnalyticsState{
  final Analytics analytics;
  GetAnalyticsSuccessfulState(this.analytics);
}

class GetAnalyticsLoadingState extends AnalyticsState {}

class GetAnalyticsFailedState extends AnalyticsState {
  final String errorType;
  GetAnalyticsFailedState(this.errorType);
}

abstract class StaticWebContentState {}

class InitialStaticWebContentState extends StaticWebContentState {}

class PutStaticWebContentSuccessfulState extends StaticWebContentState{}

class PutWhoAreWeWebContentLoadingState extends StaticWebContentState {}

class PutHowToAffiliateWithUsWebContentLoadingState extends StaticWebContentState {}

class PutStaticWebContentFailedState extends StaticWebContentState {
  final String errorType;
  PutStaticWebContentFailedState(this.errorType);
}