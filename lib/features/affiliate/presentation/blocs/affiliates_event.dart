abstract class AffiliatesEvent {}

class GetAffiliatesEvent extends AffiliatesEvent {
  int skipNumber;
  GetAffiliatesEvent(this.skipNumber);
}

class GetMoreAffiliatesEvent extends AffiliatesEvent {
  int skipNumber;
  GetMoreAffiliatesEvent(this.skipNumber);
}

abstract class SingleAffiliateEvent {}

class GetSingleAffiliateEvent extends SingleAffiliateEvent {
  String userId;
  GetSingleAffiliateEvent(this.userId);
}

abstract class ChildrenEvent {}

class GetChildrenEvent extends ChildrenEvent {
  String userId;
  GetChildrenEvent(this.userId);
}

abstract class SearchEvent {}

class SearchAffiliatesEvent extends SearchEvent {
  String fullName;
  SearchAffiliatesEvent(this.fullName);
}

abstract class ParentAffiliateEvent {}

class GetParentAffiliateEvent extends ParentAffiliateEvent {
  String parentId;
  GetParentAffiliateEvent(this.parentId);
}

class StartGetParentAffiliateEvent extends ParentAffiliateEvent {}