abstract class ProfileEvent {}

class LoadAdminEvent extends ProfileEvent {}

class GetNewAccessTokenEvent extends ProfileEvent{}

class ChangeCommissionRateEvent extends ProfileEvent{
  int commissionRate;
  ChangeCommissionRateEvent(this.commissionRate);
}

class SignOutEvent extends ProfileEvent {}