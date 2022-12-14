abstract class AffiliatesEvent {}

class GetAffiliatesEvent extends AffiliatesEvent {
  int skipNumber;
  GetAffiliatesEvent(this.skipNumber);
}

class GetMoreAffiliatesEvent extends AffiliatesEvent {
  int skipNumber;
  GetMoreAffiliatesEvent(this.skipNumber);
}

class GetAffiliatesEarningFromLowToHighEvent extends AffiliatesEvent {
  int skipNumber;
  GetAffiliatesEarningFromLowToHighEvent(this.skipNumber);
}

class GetMoreAffiliatesEarningFromLowToHighEvent extends AffiliatesEvent {
  int skipNumber;
  GetMoreAffiliatesEarningFromLowToHighEvent(this.skipNumber);
}

class GetAffiliatesEarningFromHighToLowEvent extends AffiliatesEvent {
  int skipNumber;
  GetAffiliatesEarningFromHighToLowEvent(this.skipNumber);
}

class GetMoreAffiliatesEarningFromHighToLowEvent extends AffiliatesEvent {
  int skipNumber;
  GetMoreAffiliatesEarningFromHighToLowEvent(this.skipNumber);
}

class GetMostParentAffiliateEvent extends AffiliatesEvent {
  int skipNumber;
  GetMostParentAffiliateEvent(this.skipNumber);
}

class GetMoreMostParentAffiliateEvent extends AffiliatesEvent {
  int skipNumber;
  GetMoreMostParentAffiliateEvent(this.skipNumber);
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