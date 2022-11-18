abstract class FilterFeaturedEvent {}

class FilterFeaturedProductsEvent extends FilterFeaturedEvent {}

abstract class FilterTopSellerEvent {}

class FilterTopSellerProductsEvent extends FilterTopSellerEvent {}

abstract class FilterUnAnsweredEvent {}

class FilterUnAnsweredProductsEvent extends FilterUnAnsweredEvent {}

abstract class AnalyticsEvent {}

class GetAnalyticsEvent extends AnalyticsEvent {}

abstract class StaticWebContentEvent {}

class PutWhoAreWeWebContentEvent extends StaticWebContentEvent {
  String whoAreWe;
  PutWhoAreWeWebContentEvent(this.whoAreWe);
}

class PutHowToAffiliateWithUsWebContentEvent extends StaticWebContentEvent {
  String howToAffiliateWithUs;
  PutHowToAffiliateWithUsWebContentEvent(this.howToAffiliateWithUs);
}

abstract class VideoLinksEvent {}

class GetVideoLinksEvent extends VideoLinksEvent {}