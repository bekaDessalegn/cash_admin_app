import 'package:cash_admin_app/features/affiliate/data/models/affiliates.dart';
import 'package:cash_admin_app/features/affiliate/data/models/children.dart';
import 'package:cash_admin_app/features/affiliate/data/models/local_affiliate.dart';
import 'package:cash_admin_app/features/affiliate/data/models/parent_affiliate.dart';

abstract class AffiliatesState {}

class InitialAffiliatesState extends AffiliatesState {}

class GetAffiliatesSuccessfulState extends AffiliatesState {
  final List<Affiliates> affiliates;
  GetAffiliatesSuccessfulState(this.affiliates);
}

class GetAffiliatesLoadingState extends AffiliatesState {}

class GetAffiliatesSocketErrorState extends AffiliatesState {
  final List<LocalAffiliate> localAffiliate;
  GetAffiliatesSocketErrorState(this.localAffiliate);
}

class GetAffiliatesFailedState extends AffiliatesState {
  String errorType;
  GetAffiliatesFailedState(this.errorType);
}

abstract class SingleAffiliateState {}

class InitialSingleAffiliateState extends SingleAffiliateState {}

class GetSingleAffiliateSuccessfulState extends SingleAffiliateState {
  final Affiliates affiliate;
  GetSingleAffiliateSuccessfulState(this.affiliate);
}

class GetSingleAffiliateLoadingState extends SingleAffiliateState {}

class GetSingleAffiliateSocketError extends SingleAffiliateState {}

class GetSingleAffiliateFailedState extends SingleAffiliateState {
  String errorType;
  GetSingleAffiliateFailedState(this.errorType);
}

abstract class ChildrenState {}

class InitialChildrenState extends ChildrenState {}

class GetChildrenSuccessfulState extends ChildrenState {
  final List<Children> children;
  GetChildrenSuccessfulState(this.children);
}

class GetChildrenLoadingState extends ChildrenState {}

class GetChildrenFailedState extends ChildrenState {
  String errorType;
  GetChildrenFailedState(this.errorType);
}

abstract class SearchState {}

class InitialSearchAffiliateState extends SearchState {}

class SearchAffiliateSuccessful extends SearchState {
  final List<Affiliates> affiliate;
  SearchAffiliateSuccessful(this.affiliate);
}

class SearchAffiliateSocketErrorState extends SearchState {
  final List<LocalAffiliate> affiliate;
  SearchAffiliateSocketErrorState(this.affiliate);
}

class SearchAffiliateFailed extends SearchState {
  final String errorType;
  SearchAffiliateFailed(this.errorType);
}

class SearchAffiliateLoading extends SearchState {}

abstract class ParentAffiliateState {}

class InitialParentAffiliateState extends ParentAffiliateState {}

class GetParentAffiliateSuccessfulState extends ParentAffiliateState {
  final ParentAffiliate affiliate;
  GetParentAffiliateSuccessfulState(this.affiliate);
}

class GetParentAffiliateLoadingState extends ParentAffiliateState {}

class GetParentAffiliateFailedState extends ParentAffiliateState {
  String errorType;
  GetParentAffiliateFailedState(this.errorType);
}
