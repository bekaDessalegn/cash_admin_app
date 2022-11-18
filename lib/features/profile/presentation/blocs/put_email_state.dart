abstract class PutEmailState{}

class PutEmailInitialState extends PutEmailState {}

class PutEmailSuccessful extends PutEmailState {}

class PutEmailLoading extends PutEmailState {}

class PutEmailFailed extends PutEmailState {
  final String errorType;
  PutEmailFailed(this.errorType);
}

class VerifyEmailSuccessful extends PutEmailState {}

class VerifyEmailLoading extends PutEmailState {}

class VerifyEmailFailed extends PutEmailState {
  final String errorType;
  VerifyEmailFailed(this.errorType);
}
