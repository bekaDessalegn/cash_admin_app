abstract class EmailEvent {}

class InitialPutEmailEvent extends EmailEvent {}

class PutEmailEvent extends EmailEvent {
  String email;
  PutEmailEvent(this.email);
}

class VerifyEmailEvent extends EmailEvent {
  String verificationCode;
  VerifyEmailEvent(this.verificationCode);
}